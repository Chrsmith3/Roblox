--!strict
-- Client-Start: lädt alle Controller aus dem Ordner "Controllers".
-- Ablauf: 1) alle Controller laden  2) Init() in Reihenfolge (Priority)  3) Start() parallel.
-- Init = vorbereiten (keine anderen Controller nutzen, die evtl. noch nicht bereit sind)
-- Start = loslegen (Events verbinden, Loops starten)

type Controller = {
	Name: string,
	Priority: number?,
	Init: ((self: any) -> ())?,
	Start: ((self: any) -> ())?,
}

local controllersFolder = script:WaitForChild("Controllers")
local controllers: { Controller } = {}

for _, module in controllersFolder:GetChildren() do
	if module:IsA("ModuleScript") then
		local ok, result = pcall(require, module)
		if ok then
			local controller = result :: Controller
			controller.Name = controller.Name or module.Name
			table.insert(controllers, controller)
		else
			warn(`[Client] Controller {module.Name} konnte nicht geladen werden: {result}`)
		end
	end
end

table.sort(controllers, function(a, b)
	return (a.Priority or 100) < (b.Priority or 100)
end)

for _, controller in controllers do
	if controller.Init then
		local ok, err = pcall(function()
			(controller.Init :: any)(controller)
			return nil
		end)
		if not ok then
			warn(`[Client] {controller.Name}:Init() Fehler: {err}`)
		end
	end
end

for _, controller in controllers do
	if controller.Start then
		task.spawn(function()
			local ok, err = pcall(function()
				(controller.Start :: any)(controller)
				return nil
			end)
			if not ok then
				warn(`[Client] {controller.Name}:Start() Fehler: {err}`)
			end
		end)
	end
end

print(`[Client] {#controllers} Controller gestartet`)
