--!strict
-- Anzeige für eine Währung (Icon + Zahl). Zählt bei Änderungen animiert hoch und ploppt auf.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local UIStyle = require(Shared.Config.UIStyle)
local GameConfig = require(Shared.Config.GameConfig)
local Format = require(Shared.Util.Format)

local Controllers = script.Parent.Parent.Parent:WaitForChild("Controllers")
local FeedbackController = require(Controllers:WaitForChild("FeedbackController"))

export type CurrencyDisplay = {
	Instance: Frame,
	SetValue: (self: CurrencyDisplay, value: number, animate: boolean?) -> (),
}

local CurrencyDisplay = {}

local COUNT_DURATION = 0.4

function CurrencyDisplay.new(currency: string, layoutOrder: number?, parent: Instance?): CurrencyDisplay
	local info = GameConfig.Currencies[currency]

	local frame = Instance.new("Frame")
	frame.Name = currency
	frame.Size = UDim2.fromOffset(220, 56)
	frame.BackgroundColor3 = UIStyle.Colors.Panel
	frame.BackgroundTransparency = 0.15
	frame.LayoutOrder = layoutOrder or 0

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UIStyle.Sizes.CornerRadius
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = UIStyle.Sizes.StrokeThickness
	stroke.Color = UIStyle.Colors.Stroke
	stroke.Parent = frame

	local icon = Instance.new("ImageLabel")
	icon.Name = "Icon"
	icon.BackgroundTransparency = 1
	icon.Size = UDim2.fromOffset(44, 44)
	icon.Position = UDim2.new(0, 6, 0.5, 0)
	icon.AnchorPoint = Vector2.new(0, 0.5)
	icon.Image = if info then info.Icon else ""
	icon.Parent = frame

	local label = Instance.new("TextLabel")
	label.Name = "Amount"
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 56, 0, 6)
	label.Size = UDim2.new(1, -66, 1, -12)
	label.Font = UIStyle.Fonts.Title
	label.TextScaled = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = UIStyle.Colors.Text
	label.Text = "0"
	label.Parent = frame

	local labelStroke = Instance.new("UIStroke")
	labelStroke.Thickness = 2
	labelStroke.Color = UIStyle.Colors.Stroke
	labelStroke.Parent = label

	frame.Parent = parent

	local shown = 0
	local countConnection: RBXScriptConnection? = nil

	local self = { Instance = frame } :: any

	function self:SetValue(value: number, animate: boolean?)
		if countConnection then
			countConnection:Disconnect()
			countConnection = nil
		end

		if not animate or value == shown then
			shown = value
			label.Text = Format.abbreviate(value)
			return
		end

		if value > shown then
			FeedbackController.Pop(frame)
		end

		local from = shown
		local started = os.clock()
		countConnection = RunService.RenderStepped:Connect(function()
			local alpha = math.clamp((os.clock() - started) / COUNT_DURATION, 0, 1)
			alpha = 1 - (1 - alpha) ^ 3 -- schnell starten, sanft enden
			shown = from + (value - from) * alpha
			label.Text = Format.abbreviate(shown)
			if alpha >= 1 and countConnection then
				countConnection:Disconnect()
				countConnection = nil
				shown = value
			end
		end)
	end

	return self :: CurrencyDisplay
end

return CurrencyDisplay
