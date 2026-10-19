--!strict
-- Baut die Haupt-UI (HUD) und skaliert sie passend für Handy, Tablet und PC.
-- Neue Menüs (Shop, Inventar, Settings) kommen als eigene Module unter client/UI/
-- und werden hier eingehängt.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local UIStyle = require(Shared.Config.UIStyle)
local GameConfig = require(Shared.Config.GameConfig)
local Format = require(Shared.Util.Format)
local Net = require(Shared.Net)

local UI = script.Parent.Parent:WaitForChild("UI")
local Button = require(UI.Components.Button)
local CurrencyDisplay = require(UI.Components.CurrencyDisplay)

local DataController = require(script.Parent.DataController)
local FeedbackController = require(script.Parent.FeedbackController)

local UIController = {
	Name = "UIController",
	Priority = 20,
}

local player = Players.LocalPlayer
local screenGui: ScreenGui
local hud: Frame

-- Skaliert die komplette UI relativ zur Referenz-Auflösung (wichtig für Handys).
local function setupScaling(gui: ScreenGui)
	local uiScale = Instance.new("UIScale")
	uiScale.Parent = gui

	local function update()
		local camera = workspace.CurrentCamera
		if not camera then
			return
		end
		local viewport = camera.ViewportSize
		local ref = UIStyle.Sizes.ReferenceResolution
		uiScale.Scale = math.clamp(math.min(viewport.X / ref.X, viewport.Y / ref.Y), 0.55, 1.5)
	end

	update()
	local camera = workspace.CurrentCamera
	if camera then
		camera:GetPropertyChangedSignal("ViewportSize"):Connect(update)
	end
end

-- Kurze Meldung oben in der Mitte (z. B. "Nicht genug Coins!")
function UIController.Toast(text: string, kind: string?)
	local color = if kind == "error"
		then UIStyle.Colors.Danger
		elseif kind == "success" then UIStyle.Colors.Success
		else UIStyle.Colors.Text

	local label = Instance.new("TextLabel")
	label.AnchorPoint = Vector2.new(0.5, 0)
	label.Position = UDim2.new(0.5, 0, 0, -60)
	label.Size = UDim2.fromOffset(500, 44)
	label.BackgroundTransparency = 1
	label.Font = UIStyle.Fonts.Title
	label.TextScaled = true
	label.TextColor3 = color
	label.Text = text

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2.5
	stroke.Color = UIStyle.Colors.Stroke
	stroke.Parent = label
	label.Parent = screenGui

	TweenService:Create(label, UIStyle.Tweens.Pop, { Position = UDim2.new(0.5, 0, 0, 24) }):Play()
	FeedbackController.PlaySound(if kind == "error" then "Error" else "Reward")

	task.delay(2.2, function()
		local fade = TweenService:Create(label, UIStyle.Tweens.Fade, { TextTransparency = 1 })
		TweenService:Create(stroke, UIStyle.Tweens.Fade, { Transparency = 1 }):Play()
		fade.Completed:Once(function()
			label:Destroy()
		end)
		fade:Play()
	end)
end

local function buildCurrencyBar()
	local bar = Instance.new("Frame")
	bar.Name = "CurrencyBar"
	bar.BackgroundTransparency = 1
	bar.Position = UDim2.fromOffset(16, 16)
	bar.Size = UDim2.fromOffset(240, 400)
	bar.Parent = hud

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = bar

	local names = {}
	for currency in GameConfig.Currencies do
		table.insert(names, currency)
	end
	table.sort(names)

	local displays = {}
	for order, currency in names do
		displays[currency] = CurrencyDisplay.new(currency, order, bar)
	end

	DataController.Observe("Currencies", function(currencies: { [string]: number }?, old: { [string]: number }?)
		if not currencies then
			return
		end
		for currency, display in displays do
			display:SetValue(currencies[currency] or 0, old ~= nil)
		end
	end)
end

-- DEMO: großer Klick-Button unten in der Mitte. Wird durch den echten Core Loop ersetzt.
local function buildDemoClickButton()
	local clickRemote = Net.event("Click")
	local button = Button.new({
		Text = "KLICK!",
		Size = UDim2.fromOffset(260, 90),
		Position = UDim2.new(0.5, 0, 1, -40),
		AnchorPoint = Vector2.new(0.5, 1),
		Parent = hud,
		OnClick = function()
			clickRemote:FireServer()
		end,
	})

	-- Feedback erst, wenn der Server die Coins bestätigt hat
	DataController.Observe("Currencies", function(currencies: { [string]: number }?, old: { [string]: number }?)
		if not currencies or not old then
			return
		end
		local gained = (currencies.Coins or 0) - (old.Coins or 0)
		if gained > 0 then
			-- Position relativ zum HUD (in Prozent, damit UIScale nicht stört)
			local pos = button.AbsolutePosition + button.AbsoluteSize / 2 - hud.AbsolutePosition
			local size = hud.AbsoluteSize
			local start = UDim2.fromScale(pos.X / size.X, pos.Y / size.Y) - UDim2.fromOffset(0, 70)
			FeedbackController.FloatingText(hud, "+" .. Format.abbreviate(gained), start)
		end
	end)
end

function UIController:Start()
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MainGui"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	setupScaling(screenGui)

	hud = Instance.new("Frame")
	hud.Name = "HUD"
	hud.BackgroundTransparency = 1
	hud.Size = UDim2.fromScale(1, 1)
	hud.Parent = screenGui

	screenGui.Parent = player:WaitForChild("PlayerGui")

	buildCurrencyBar()
	buildDemoClickButton()

	Net.event("Notify").OnClientEvent:Connect(function(text: string, kind: string?)
		UIController.Toast(text, kind)
	end)

	DataController.WaitUntilLoaded()
	UIController.Toast(`Willkommen bei {GameConfig.GameName}!`, "success")
end

return UIController
