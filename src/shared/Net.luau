--!strict
-- Zentrale Liste aller Remotes (Client <-> Server).
-- Neue Remote = Namen hier eintragen. Der Server legt sie an, der Client wartet darauf.
-- SICHERHEIT: Alles, was vom Client kommt, auf dem Server prüfen (Typ, Wertebereich, Rate-Limit).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Net = {}

local EVENTS = {
	"DataChanged", -- Server -> Client: (key, value)
	"Click", -- Client -> Server: Demo-Core-Loop
	"Notify", -- Server -> Client: (text, kind)
}

local FUNCTIONS = {
	"GetInitialData", -- Client -> Server: liefert den kompletten Spielstand
}

local FOLDER_NAME = "Remotes"
local folder: Folder

if RunService:IsServer() then
	folder = Instance.new("Folder")
	folder.Name = FOLDER_NAME
	for _, name in EVENTS do
		local remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = folder
	end
	for _, name in FUNCTIONS do
		local remote = Instance.new("RemoteFunction")
		remote.Name = name
		remote.Parent = folder
	end
	folder.Parent = ReplicatedStorage
else
	folder = ReplicatedStorage:WaitForChild(FOLDER_NAME) :: Folder
end

function Net.event(name: string): RemoteEvent
	assert(table.find(EVENTS, name), `Unbekanntes RemoteEvent: {name} (in Net.luau eintragen)`)
	return folder:WaitForChild(name) :: RemoteEvent
end

function Net.func(name: string): RemoteFunction
	assert(table.find(FUNCTIONS, name), `Unbekannte RemoteFunction: {name} (in Net.luau eintragen)`)
	return folder:WaitForChild(name) :: RemoteFunction
end

return Net
