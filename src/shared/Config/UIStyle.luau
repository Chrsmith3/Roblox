--!strict
-- UI-Styleguide im Code. Alle UI-Elemente nutzen NUR diese Werte,
-- damit das Spiel einheitlich aussieht. Änderungen hier wirken überall.

local UIStyle = {}

UIStyle.Colors = {
	Primary = Color3.fromRGB(255, 196, 0), -- Haupt-Akzent (Kauf-Buttons, Coins)
	PrimaryDark = Color3.fromRGB(204, 140, 0),
	Secondary = Color3.fromRGB(0, 170, 255),
	Success = Color3.fromRGB(85, 220, 95),
	Danger = Color3.fromRGB(255, 75, 75),
	Background = Color3.fromRGB(30, 30, 40),
	Panel = Color3.fromRGB(45, 45, 60),
	Text = Color3.fromRGB(255, 255, 255),
	TextMuted = Color3.fromRGB(190, 190, 205),
	Stroke = Color3.fromRGB(0, 0, 0),
}

UIStyle.Fonts = {
	Title = Enum.Font.FredokaOne,
	Body = Enum.Font.GothamBold,
}

UIStyle.Sizes = {
	CornerRadius = UDim.new(0, 12),
	StrokeThickness = 3,
	MinTouchTarget = 56, -- Pixel, Mindestgröße für Buttons auf dem Handy
	ReferenceResolution = Vector2.new(1280, 720), -- Basis für UIScale
}

-- Animations-Timings (Game Feel). Einheitlich halten!
UIStyle.Tweens = {
	Press = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Release = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	Hover = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Pop = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	Fade = TweenInfo.new(0.2, Enum.EasingStyle.Linear),
	FloatUp = TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
}

UIStyle.Scale = {
	Hover = 1.06,
	Press = 0.9,
	Pop = 1.15,
}

-- Sound-IDs (0 = Platzhalter, später aus dem Creator Store eintragen)
UIStyle.Sounds = {
	Click = "rbxassetid://0",
	Purchase = "rbxassetid://0",
	Reward = "rbxassetid://0",
	Error = "rbxassetid://0",
} :: { [string]: string }

return UIStyle
