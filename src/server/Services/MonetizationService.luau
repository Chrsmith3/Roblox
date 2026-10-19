--!strict
-- Gamepässe, Developer Products und Policy-Checks (z. B. für Robux-Eggs).
-- Käufe werden sicher abgewickelt: Belohnung wird erst bestätigt, wenn sie gespeichert ist
-- (kein Verlust bei Server-Crash, keine doppelte Vergabe).

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local PolicyService = game:GetService("PolicyService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameConfig = require(Shared.Config.GameConfig)
local Products = require(Shared.Config.Products)
local DataService = require(script.Parent.DataService)
local CurrencyService = require(script.Parent.CurrencyService)

local MonetizationService = {
	Name = "MonetizationService",
	Priority = 20,
}

local ownedPasses: { [Player]: { [string]: boolean } } = {}
local policyCache: { [Player]: any } = {}
local productsById: { [number]: Products.DevProduct } = {}
local passNameById: { [number]: string } = {}

-- Handler-Funktionen für Developer Products (Name steht in Products.DevProducts[...].Handler)
MonetizationService.ProductHandlers = {
	GrantCurrency = function(player: Player, product: Products.DevProduct)
		CurrencyService.Add(player, "Coins", product.Amount or 0, false)
	end,
	GrantGems = function(player: Player, product: Products.DevProduct)
		CurrencyService.Add(player, "Gems", product.Amount or 0, false)
	end,
} :: { [string]: (Player, Products.DevProduct) -> () }

function MonetizationService.OwnsPass(player: Player, passName: string): boolean
	local owned = ownedPasses[player]
	return owned ~= nil and owned[passName] == true
end

function MonetizationService.PromptPass(player: Player, passName: string)
	local pass = Products.GamePasses[passName]
	if pass and pass.Id ~= 0 then
		MarketplaceService:PromptGamePassPurchase(player, pass.Id)
	end
end

function MonetizationService.PromptProduct(player: Player, productName: string)
	local product = Products.DevProducts[productName]
	if product and product.Id ~= 0 then
		MarketplaceService:PromptProductPurchase(player, product.Id)
	end
end

-- Policy pro Spieler (gecacht). Wichtig für Robux-Eggs und Trading (Roblox-Regeln, je nach Land).
function MonetizationService.GetPolicy(player: Player): any?
	if policyCache[player] == nil then
		local ok, info = pcall(PolicyService.GetPolicyInfoForPlayerAsync, PolicyService, player)
		if ok then
			policyCache[player] = info
		end
	end
	return policyCache[player]
end

-- Darf dieser Spieler zufällige Items mit Robux kaufen (Eggs, Spins, ...)?
-- Wenn nein: Alternative anbieten (siehe Regeln in CLAUDE.md).
function MonetizationService.CanBuyPaidRandomItems(player: Player): boolean
	local policy = MonetizationService.GetPolicy(player)
	return policy ~= nil and policy.ArePaidRandomItemsRestricted == false
end

function MonetizationService.CanTradePaidItems(player: Player): boolean
	local policy = MonetizationService.GetPolicy(player)
	return policy ~= nil and policy.IsPaidItemTradingAllowed == true
end

local function loadOwnedPasses(player: Player)
	local owned: { [string]: boolean } = {}
	ownedPasses[player] = owned
	for name, pass in Products.GamePasses do
		if pass.Id ~= 0 then
			local ok, result =
				pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, player.UserId, pass.Id)
			owned[name] = ok and result == true
		end
	end
end

-- Wartet, bis der Kauf sicher gespeichert ist (Muster aus der ProfileStore-Doku).
local function purchaseIdCheckAsync(profile: any, purchaseId: string, grant: () -> ()): Enum.ProductPurchaseDecision
	if profile:IsActive() ~= true then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local cache = profile.Data.PurchaseIdCache
	if table.find(cache, purchaseId) == nil then
		local ok, err = pcall(function()
			grant()
			return nil
		end)
		if not ok then
			warn(`[Monetization] Kauf fehlgeschlagen: {profile.Key} {purchaseId} {err}`)
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
		while #cache >= GameConfig.Data.PurchaseIdCacheSize do
			table.remove(cache, 1)
		end
		table.insert(cache, purchaseId)
	end

	local function isSaved(): boolean
		local saved = profile.LastSavedData and profile.LastSavedData.PurchaseIdCache
		return saved ~= nil and table.find(saved, purchaseId) ~= nil
	end

	if isSaved() then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	while profile:IsActive() == true do
		local lastSaved = profile.LastSavedData
		profile:Save()
		if profile.LastSavedData == lastSaved then
			profile.OnAfterSave:Wait()
		end
		if isSaved() then
			return Enum.ProductPurchaseDecision.PurchaseGranted
		end
		if profile:IsActive() == true then
			task.wait(10)
		end
	end

	return Enum.ProductPurchaseDecision.NotProcessedYet
end

local function processReceipt(receipt: any): Enum.ProductPurchaseDecision
	local player = Players:GetPlayerByUserId(receipt.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	DataService.WaitForData(player, 15)
	local profile = DataService.GetProfile(player)
	local product = productsById[receipt.ProductId]
	if not profile or not product then
		if not product then
			warn(`[Monetization] Unbekanntes Produkt: {receipt.ProductId}`)
		end
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local handler = MonetizationService.ProductHandlers[product.Handler]
	if not handler then
		warn(`[Monetization] Kein Handler "{product.Handler}" für {product.DisplayName}`)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	return purchaseIdCheckAsync(profile, receipt.PurchaseId, function()
		handler(player, product)
	end)
end

function MonetizationService:Init()
	for _, product in Products.DevProducts do
		if product.Id ~= 0 then
			productsById[product.Id] = product
		end
	end
	for name, pass in Products.GamePasses do
		if pass.Id ~= 0 then
			passNameById[pass.Id] = name
		end
	end

	-- Gamepass-Multiplikatoren für Coins
	CurrencyService.RegisterMultiplier(function(player, currency)
		if currency ~= "Coins" then
			return 1
		end
		local total = 1
		for passName, multiplier in Products.PassMultipliers do
			if MonetizationService.OwnsPass(player, passName) then
				total *= multiplier
			end
		end
		return total
	end)
end

function MonetizationService:Start()
	MarketplaceService.ProcessReceipt = processReceipt

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, purchased)
		local name = passNameById[passId]
		if purchased and name then
			ownedPasses[player] = ownedPasses[player] or {}
			ownedPasses[player][name] = true
		end
	end)

	DataService.OnPlayerLoaded(function(player)
		loadOwnedPasses(player)
		MonetizationService.GetPolicy(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		ownedPasses[player] = nil
		policyCache[player] = nil
	end)
end

return MonetizationService
