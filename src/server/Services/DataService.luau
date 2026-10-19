--!strict
-- Lädt, speichert und synchronisiert Spielstände (mit ProfileStore, inkl. Session-Lock gegen Duplikate).
-- Andere Services ändern Daten NUR über DataService.Set / DataService.Update,
-- damit der Client automatisch die neuen Werte bekommt.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local ProfileStore = require(ServerStorage:WaitForChild("ServerPackages"):WaitForChild("ProfileStore")) :: any
local Shared = ReplicatedStorage:WaitForChild("Shared")
local DataTemplate = require(Shared:WaitForChild("DataTemplate"))
local GameConfig = require(Shared.Config.GameConfig)
local Net = require(Shared.Net)
local Signal = require(Shared.Util.Signal)

type PlayerData = DataTemplate.PlayerData

local DataService = {
	Name = "DataService",
	Priority = 1, -- zuerst initialisieren
	PlayerLoaded = Signal.new() :: Signal.Signal<Player, PlayerData>,
}

local store = ProfileStore.New(GameConfig.Data.StoreName, DataTemplate)
local profiles: { [Player]: any } = {}
local dataChanged = Net.event("DataChanged")

-- Gibt das Profil zurück (für Spezialfälle wie Kauf-Abwicklung), sonst lieber GetData nutzen.
function DataService.GetProfile(player: Player): any?
	return profiles[player]
end

function DataService.GetData(player: Player): PlayerData?
	local profile = profiles[player]
	return if profile then profile.Data else nil
end

-- Wartet, bis die Daten geladen sind (oder Timeout / Spieler weg).
function DataService.WaitForData(player: Player, timeout: number?): PlayerData?
	local deadline = os.clock() + (timeout or 30)
	while not profiles[player] and player.Parent == Players and os.clock() < deadline do
		task.wait(0.1)
	end
	return DataService.GetData(player)
end

-- Ruft fn für alle bereits geladenen UND alle künftigen Spieler auf. Immer das hier statt PlayerLoaded nutzen.
function DataService.OnPlayerLoaded(fn: (Player, PlayerData) -> ())
	DataService.PlayerLoaded:Connect(fn)
	for player, profile in profiles do
		task.spawn(fn, player, profile.Data)
	end
end

-- Schickt einen Top-Level-Key an den Client.
function DataService.Replicate(player: Player, key: string)
	local data = DataService.GetData(player)
	if data then
		dataChanged:FireClient(player, key, (data :: any)[key])
	end
end

function DataService.Set(player: Player, key: string, value: any)
	local data = DataService.GetData(player)
	if not data then
		return
	end
	(data :: any)[key] = value
	DataService.Replicate(player, key)
end

-- Ändert einen Top-Level-Key über eine Funktion und repliziert danach.
-- Beispiel: DataService.Update(player, "Stats", function(stats) stats.Rebirths += 1 return stats end)
function DataService.Update(player: Player, key: string, fn: (any) -> any)
	local data = DataService.GetData(player)
	if not data then
		return
	end
	(data :: any)[key] = fn((data :: any)[key])
	DataService.Replicate(player, key)
end

local function onPlayerAdded(player: Player)
	local profile = store:StartSessionAsync(`Player_{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	if profile == nil then
		player:Kick("Dein Spielstand konnte nicht geladen werden. Bitte versuche es gleich nochmal.")
		return
	end

	profile:AddUserId(player.UserId) -- DSGVO / Datenlöschung
	profile:Reconcile() -- neue Template-Felder ergänzen

	profile.OnSessionEnd:Connect(function()
		profiles[player] = nil
		player:Kick("Dein Spielstand wurde auf einem anderen Server geöffnet.")
	end)

	if player.Parent ~= Players then
		profile:EndSession()
		return
	end

	local data = profile.Data :: PlayerData
	local now = os.time()
	if data.FirstJoin == 0 then
		data.FirstJoin = now
	end
	data.LastJoin = now

	profiles[player] = profile
	DataService.PlayerLoaded:Fire(player, data)
end

local function onPlayerRemoving(player: Player)
	local profile = profiles[player]
	if profile then
		profile:EndSession()
	end
end

function DataService:Init()
	Net.func("GetInitialData").OnServerInvoke = function(player: Player)
		return DataService.WaitForData(player, 30)
	end
end

function DataService:Start()
	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)
	for _, player in Players:GetPlayers() do
		task.spawn(onPlayerAdded, player)
	end

	-- Spielzeit zählen (wird nicht an den Client geschickt)
	while true do
		task.wait(10)
		for _, profile in profiles do
			profile.Data.Stats.PlayTime += 10
		end
	end
end

return DataService
