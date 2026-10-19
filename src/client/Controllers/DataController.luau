--!strict
-- Hält eine Kopie des eigenen Spielstands auf dem Client (nur zum Anzeigen!).
-- Der Client ändert nie selbst Daten - er fragt den Server per Remote.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Net = require(Shared.Net)
local Signal = require(Shared.Util.Signal)

local DataController = {
	Name = "DataController",
	Priority = 1,
	Loaded = false,
	-- Feuert bei jeder Änderung: (key, neuerWert, alterWert)
	Changed = Signal.new() :: Signal.Signal<string, any, any>,
	OnLoaded = Signal.new() :: Signal.Signal<()>,
}

local data: { [string]: any } = {}

function DataController.Get(key: string): any
	return data[key]
end

-- Wartet, bis die Daten da sind.
function DataController.WaitUntilLoaded()
	if not DataController.Loaded then
		DataController.OnLoaded:Wait()
	end
end

-- Ruft fn sofort mit dem aktuellen Wert auf und danach bei jeder Änderung von key.
function DataController.Observe(key: string, fn: (value: any, old: any) -> ()): Signal.Connection
	if DataController.Loaded then
		task.spawn(fn, data[key], nil)
	else
		DataController.OnLoaded:Once(function()
			fn(data[key], nil)
		end)
	end
	return DataController.Changed:Connect(function(changedKey, value, old)
		if changedKey == key then
			fn(value, old)
		end
	end)
end

function DataController:Start()
	Net.event("DataChanged").OnClientEvent:Connect(function(key: string, value: any)
		local old = data[key]
		data[key] = value
		DataController.Changed:Fire(key, value, old)
	end)

	local initial = nil
	while initial == nil do
		local ok, result = pcall(function()
			return Net.func("GetInitialData"):InvokeServer()
		end)
		if ok and type(result) == "table" then
			initial = result
		else
			task.wait(2)
		end
	end

	for key, value in initial do
		data[key] = value
	end
	DataController.Loaded = true
	DataController.OnLoaded:Fire()
end

return DataController
