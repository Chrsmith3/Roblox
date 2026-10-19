--!strict
-- Standard-Button mit Game Feel (Hover, Drücken, Sound, Vibration).
-- IMMER diesen Button verwenden statt eigene TextButtons zu bauen.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local UIStyle = require(Shared.Config.UIStyle)

local Controllers = script.Parent.Parent.Parent:WaitForChild("Controllers")
local FeedbackController = require(Controllers:WaitForChild("FeedbackController"))

export type ButtonProps = {
	Text: string,
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	Color: Color3?,
	TextColor: Color3?,
	Sound: string?, -- Name aus UIStyle.Sounds, Standard "Click"
	LayoutOrder: number?,
	Parent: Instance?,
	OnClick: (() -> ())?,
}

local Button = {}

local function darken(color: Color3, amount: number): Color3
	local h, s, v = color:ToHSV()
	return Color3.fromHSV(h, s, math.max(0, v - amount))
end

function Button.new(props: ButtonProps): TextButton
	local color = props.Color or UIStyle.Colors.Primary
	local minSize = UIStyle.Sizes.MinTouchTarget

	local button = Instance.new("TextButton")
	button.Name = props.Text
	button.AutoButtonColor = false
	button.Size = props.Size or UDim2.fromOffset(200, minSize)
	button.Position = props.Position or UDim2.new()
	button.AnchorPoint = props.AnchorPoint or Vector2.zero
	button.LayoutOrder = props.LayoutOrder or 0
	button.BackgroundColor3 = color
	button.Font = UIStyle.Fonts.Title
	button.Text = props.Text
	button.TextColor3 = props.TextColor or UIStyle.Colors.Text
	button.TextScaled = true

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0.18, 0)
	padding.PaddingBottom = UDim.new(0.18, 0)
	padding.PaddingLeft = UDim.new(0.08, 0)
	padding.PaddingRight = UDim.new(0.08, 0)
	padding.Parent = button

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UIStyle.Sizes.CornerRadius
	corner.Parent = button

	-- Rahmen um den Button (ApplyStrokeMode Border, damit er nicht am Text klebt)
	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Thickness = UIStyle.Sizes.StrokeThickness
	stroke.Color = darken(color, 0.35)
	stroke.Parent = button

	-- Text-Umrandung für Lesbarkeit
	local textStroke = Instance.new("UIStroke")
	textStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	textStroke.Thickness = 2
	textStroke.Color = UIStyle.Colors.Stroke
	textStroke.Parent = button

	local gradient = Instance.new("UIGradient")
	gradient.Rotation = 90
	gradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(200, 200, 200))
	gradient.Parent = button

	local scale = Instance.new("UIScale")
	scale.Parent = button

	local hovering = false

	local function tweenScale(target: number, info: TweenInfo)
		TweenService:Create(scale, info, { Scale = target }):Play()
	end

	button.MouseEnter:Connect(function()
		if FeedbackController.IsTouch then
			return
		end
		hovering = true
		tweenScale(UIStyle.Scale.Hover, UIStyle.Tweens.Hover)
	end)

	button.MouseLeave:Connect(function()
		hovering = false
		tweenScale(1, UIStyle.Tweens.Hover)
	end)

	button.MouseButton1Down:Connect(function()
		tweenScale(UIStyle.Scale.Press, UIStyle.Tweens.Press)
	end)

	button.MouseButton1Up:Connect(function()
		tweenScale(if hovering then UIStyle.Scale.Hover else 1, UIStyle.Tweens.Release)
	end)

	button.Activated:Connect(function()
		FeedbackController.PlaySound(props.Sound or "Click")
		FeedbackController.Haptic(0.3, 0.05)
		if props.OnClick then
			props.OnClick()
		end
	end)

	button.Parent = props.Parent
	return button
end

return Button
