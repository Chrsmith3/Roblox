--!strict
-- Gamepässe und Developer Products.
-- WICHTIG: Hier stehen nur IDs, KEINE Preise. Preise kommen immer live von Roblox
-- (MarketplaceService), damit Managed Pricing / regionale Preise funktionieren.
-- IDs = 0 sind Platzhalter, bis die Produkte im Creator Hub angelegt sind.

export type GamePass = {
	Id: number,
	DisplayName: string,
	Description: string,
}

export type DevProduct = {
	Id: number,
	DisplayName: string,
	Handler: string, -- Name der Funktion in MonetizationService.ProductHandlers
	Amount: number?,
}

local Products = {}

Products.GamePasses = {
	DoubleCoins = {
		Id = 0,
		DisplayName = "2x Coins",
		Description = "Verdopple alle Coins für immer.",
	},
	VIP = {
		Id = 0,
		DisplayName = "VIP",
		Description = "VIP-Tag, VIP-Bereich und +20% Coins.",
	},
} :: { [string]: GamePass }

Products.DevProducts = {
	CoinsSmall = {
		Id = 0,
		DisplayName = "Kleines Coin-Paket",
		Handler = "GrantCurrency",
		Amount = 1000,
	},
	GemsSmall = {
		Id = 0,
		DisplayName = "Kleines Gem-Paket",
		Handler = "GrantGems",
		Amount = 100,
	},
} :: { [string]: DevProduct }

-- Coin-Multiplikatoren durch Gamepässe (wird von MonetizationService genutzt)
Products.PassMultipliers = {
	DoubleCoins = 2,
	VIP = 1.2,
} :: { [string]: number }

return Products
