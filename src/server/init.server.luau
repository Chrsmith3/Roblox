--!strict
-- Server-Start: lädt alle Services aus dem Ordner "Services".
-- Ablauf: 1) alle Services laden  2) Init() in Reihenfolge (Priority)  3) Start() parallel.
-- Init = vorbereiten (keine anderen Services nutzen, die evtl. noch nicht bereit sind)
-- Start = loslegen (Events verbinden, Loops starten)

type Service = {
	Name: string,
	Priority: number?,
	Init: ((self: any) -> ())?,
	Start: ((self: any) -> ())?,
}

local servicesFolder = script:WaitForChild("Services")
local services: { Service } = {}

for _, module in servicesFolder:GetChildren() do
	if module:IsA("ModuleScript") then
		local ok, result = pcall(require, module)
		if ok then
			local service = result :: Service
			service.Name = service.Name or module.Name
			table.insert(services, service)
		else
			warn(`[Server] Service {module.Name} konnte nicht geladen werden: {result}`)
		end
	end
end

table.sort(services, function(a, b)
	return (a.Priority or 100) < (b.Priority or 100)
end)

for _, service in services do
	if service.Init then
		local ok, err = pcall(function()
			(service.Init :: any)(service)
			return nil
		end)
		if not ok then
			warn(`[Server] {service.Name}:Init() Fehler: {err}`)
		end
	end
end

for _, service in services do
	if service.Start then
		task.spawn(function()
			local ok, err = pcall(function()
				(service.Start :: any)(service)
				return nil
			end)
			if not ok then
				warn(`[Server] {service.Name}:Start() Fehler: {err}`)
			end
		end)
	end
end

print(`[Server] {#services} Services gestartet`)
