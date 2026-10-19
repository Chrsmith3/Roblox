--!strict
-- Zentrale Spiel-Einstellungen. Balancing-Werte gehören HIERHER, nicht verstreut in den Code.

export type CurrencyInfo = {
	DisplayName: string,
	Icon: string,
	ShowInLeaderstats: boolean,
}

local GameConfig = {}

GameConfig.GameName = "SimulatorGame" -- Platzhalter, wird ersetzt sobald das Thema steht

-- Währungen: Name -> Anzeige-Infos. Neue Währung = hier eintragen + in DataTemplate.
GameConfig.Currencies = {
	Coins = { DisplayName = "Coins", Icon = "rbxassetid://0", ShowInLeaderstats = true },
	Gems = { DisplayName = "Gems", Icon = "rbxassetid://0", ShowInLeaderstats = false },
} :: { [string]: CurrencyInfo }

-- Daten / Speichern
GameConfig.Data = {
	StoreName = "PlayerData_v1", -- NIE ändern nach Release, sonst sind alle Spielstände weg
	PurchaseIdCacheSize = 100,
}

-- Demo-Core-Loop (Klicken -> Coins). Wird durch den echten Core Loop ersetzt.
GameConfig.Demo = {
	ClickReward = 1,
	MaxClicksPerSecond = 12, -- Anti-Autoclicker / Anti-Exploit
}

return GameConfig
