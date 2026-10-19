--!strict
-- Standard-Spielstand für neue Spieler.
-- Neue Felder einfach hinzufügen: bestehende Spieler bekommen sie automatisch (Reconcile).
-- Felder NIE umbenennen nach Release (sonst gehen Daten verloren) - lieber neues Feld + Migration.

export type PlayerData = {
	Currencies: { [string]: number },
	Stats: {
		TotalClicks: number,
		Rebirths: number,
		PlayTime: number,
	},
	Inventory: { [string]: any },
	Settings: {
		Music: boolean,
		Sfx: boolean,
	},
	PurchaseIdCache: { string },
	FirstJoin: number,
	LastJoin: number,
}

local DataTemplate: PlayerData = {
	Currencies = {
		Coins = 0,
		Gems = 0,
	},
	Stats = {
		TotalClicks = 0,
		Rebirths = 0,
		PlayTime = 0,
	},
	Inventory = {},
	Settings = {
		Music = true,
		Sfx = true,
	},
	PurchaseIdCache = {},
	FirstJoin = 0,
	LastJoin = 0,
}

return DataTemplate
