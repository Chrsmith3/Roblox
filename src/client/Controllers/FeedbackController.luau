--!strict
-- GAME FEEL: Jede Spieler-Aktion bekommt Feedback (Sound, Animation, Zahlen, Shake, Vibration).
-- Andere Controller/UI rufen nur diese Funktionen auf, damit sich alles einheitlich anfühlt.

local HapticService = game:GetService("HapticService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local UIStyle = require(Shared.Config.UIStyle)

local FeedbackController = {
	Name = "FeedbackController",
	Priority = 5,
	SfxEnabled = true,
	IsTouch = false, -- Handy/Tablet ohne Tastatur
}

local sounds: { [string]: Sound } = {}
local shakeIntensity = 0
local shakeUntil = 0

-- Spielt einen Sound aus UIStyle.Sounds (Name z. B. "Click").
function FeedbackController.PlaySound(name: string, pitch: number?)
	if not FeedbackController.SfxEnabled then
		return
	end
	local sound = sounds[name]
	if not sound then
		return
	end
	sound.PlaybackSpeed = pitch or (0.95 + math.random() * 0.1) -- leichte Variation klingt lebendiger
	SoundService:PlayLocalSound(sound)
end

-- Lässt ein UI-Element kurz "aufploppen" (z. B. Währungsanzeige bei Gewinn).
function FeedbackController.Pop(gui: GuiObject)
	local s = gui:FindFirstChildOfClass("UIScale")
	if s == nil then
		local created = Instance.new("UIScale")
		created.Parent = gui
		s = created
	end
	assert(s)
	s.Scale = UIStyle.Scale.Pop
	TweenService:Create(s, UIStyle.Tweens.Pop, { Scale = 1 }):Play()
end

-- Text, der an einer Bildschirmposition nach oben schwebt und verblasst (z. B. "+15").
function FeedbackController.FloatingText(parent: GuiObject | ScreenGui, text: string, position: UDim2, color: Color3?)
	local label = Instance.new("TextLabel")
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = position
	label.Size = UDim2.fromOffset(200, 50)
	label.BackgroundTransparency = 1
	label.Font = UIStyle.Fonts.Title
	label.TextScaled = true
	label.Text = text
	label.TextColor3 = color or UIStyle.Colors.Primary
	label.ZIndex = 50

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = UIStyle.Sizes.StrokeThickness
	stroke.Color = UIStyle.Colors.Stroke
	stroke.Parent = label

	label.Rotation = math.random(-12, 12)
	label.Parent = parent

	local target = position + UDim2.fromOffset(math.random(-30, 30), -90)
	local tween = TweenService:Create(label, UIStyle.Tweens.FloatUp, {
		Position = target,
		TextTransparency = 1,
		Rotation = 0,
	})
	TweenService:Create(stroke, UIStyle.Tweens.FloatUp, { Transparency = 1 }):Play()
	tween.Completed:Once(function()
		label:Destroy()
	end)
	tween:Play()
end

-- Kamera wackeln lassen. intensity ~0.1 (leicht) bis ~1 (stark).
function FeedbackController.CameraShake(intensity: number, duration: number)
	shakeIntensity = math.max(shakeIntensity, intensity)
	shakeUntil = math.max(shakeUntil, os.clock() + duration)
end

-- Kurze Vibration (Controller). Auf Geräten ohne Vibration passiert einfach nichts.
function FeedbackController.Haptic(strength: number?, duration: number?)
	local inputType = Enum.UserInputType.Gamepad1
	local ok, supported = pcall(HapticService.IsVibrationSupported, HapticService, inputType)
	if not ok or not supported then
		return
	end
	local motor = Enum.VibrationMotor.Small
	if not HapticService:IsMotorSupported(inputType, motor) then
		return
	end
	HapticService:SetMotor(inputType, motor, strength or 0.5)
	task.delay(duration or 0.1, function()
		HapticService:SetMotor(inputType, motor, 0)
	end)
end

function FeedbackController:Init()
	-- Auf Touch-Geräten keine Hover-Effekte (Info für UI-Komponenten)
	FeedbackController.IsTouch = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

	for name, id in UIStyle.Sounds do
		if id ~= "rbxassetid://0" then
			local sound = Instance.new("Sound")
			sound.Name = name
			sound.SoundId = id
			sound.Parent = SoundService
			sounds[name] = sound
		end
	end
end

function FeedbackController:Start()
	-- Kamera-Shake läuft nach der Kamera-Aktualisierung
	RunService:BindToRenderStep("CameraShake", Enum.RenderPriority.Camera.Value + 1, function()
		local now = os.clock()
		if now >= shakeUntil then
			shakeIntensity = 0
			return
		end
		local camera = workspace.CurrentCamera
		if not camera then
			return
		end
		local remaining = (shakeUntil - now)
		local strength = shakeIntensity * math.clamp(remaining * 4, 0, 1)
		local offset = Vector3.new(math.random() - 0.5, math.random() - 0.5, 0) * strength
		camera.CFrame *= CFrame.new(offset)
	end)
end

return FeedbackController
