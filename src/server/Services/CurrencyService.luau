--!strict
-- Alle Währungen (Coins, Gems, ...). Nur der Server darf Währung ändern.
-- Multiplikatoren (Gamepässe, Boosts, Rebirths) werden über RegisterMultiplier eingehängt.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameConfig = require(Shared.Config.GameConfig)
local DataService = require(script.Parent.DataService)

type MultiplierFn = (player: Player, currency: string) -> number

local CurrencyService = {
	Name = "CurrencyService",
	Priority = 10,
}

local multipliers: { MultiplierFn } = {}

local function isValidAmount(amount: number): boolean
	return type(amount) == "number" and amount == amount and amount > 0 and amount < math.huge
end

local function updateLeaderstat(player: Player, currency: string, value: number)
	local leaderstats = player:FindFirstChild("leaderstats")
	local stat = leaderstats and leaderstats:FindFirstChild(currency)
	if stat and stat:IsA("NumberValue") then
		stat.Value = value
	end
end

-- Andere Services hängen hier ihre Multiplikatoren ein. Alle werden miteinander multipliziert.
function CurrencyService.RegisterMultiplier(fn: MultiplierFn)
	table.insert(multipliers, fn)
end

function CurrencyService.GetMultiplier(player: Player, currency: string): number
	local total = 1
	for _, fn in multipliers do
		local ok, value = pcall(fn, player, currency)
		if ok and type(value) == "number" and value > 0 then
			total *= value
		end
	end
	return total
end

function CurrencyService.Get(player: Player, currency: string): number
	local data = DataService.GetData(player)
	return if data then data.Currencies[currency] or 0 else 0
end

-- Fügt Währung hinzu. applyMultipliers = true für Gameplay-Belohnungen, false für Käufe.
-- Gibt die tatsächlich hinzugefügte Menge zurück.
function CurrencyService.Add(player: Player, currency: string, amount: number, applyMultipliers: boolean?): number
	assert(GameConfig.Currencies[currency], `Unbekannte Währung: {currency}`)
	if not isValidAmount(amount) or not DataService.GetData(player) then
		return 0
	end

	local final = if applyMultipliers then amount * CurrencyService.GetMultiplier(player, currency) else amount
	DataService.Update(player, "Currencies", function(currencies)
		currencies[currency] = (currencies[currency] or 0) + final
		return currencies
	end)
	updateLeaderstat(player, currency, CurrencyService.Get(player, currency))
	return final
end

-- Zieht Währung ab, falls genug da ist. Gibt true zurück, wenn erfolgreich.
function CurrencyService.Spend(player: Player, currency: string, amount: number): boolean
	assert(GameConfig.Currencies[currency], `Unbekannte Währung: {currency}`)
	if not isValidAmount(amount) then
		return false
	end
	if CurrencyService.Get(player, currency) < amount then
		return false
	end

	DataService.Update(player, "Currencies", function(currencies)
		currencies[currency] -= amount
		return currencies
	end)
	updateLeaderstat(player, currency, CurrencyService.Get(player, currency))
	return true
end

function CurrencyService:Start()
	DataService.OnPlayerLoaded(function(player, data)
		local leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		for currency, info in GameConfig.Currencies do
			if info.ShowInLeaderstats then
				local stat = Instance.new("NumberValue")
				stat.Name = currency
				stat.Value = data.Currencies[currency] or 0
				stat.Parent = leaderstats
			end
		end
		leaderstats.Parent = player
	end)
end

return CurrencyService
