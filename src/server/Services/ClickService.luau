--!strict
-- DEMO-Core-Loop: Spieler klickt -> bekommt Coins.
-- Zeigt das komplette Muster (Remote -> Rate-Limit -> Server-Logik -> Daten -> Client-Update).
-- Wird ersetzt, sobald der echte Core Loop im GDD steht.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameConfig = require(Shared.Config.GameConfig)
local Net = require(Shared.Net)
local RateLimiter = require(script.Parent.Parent.Util.RateLimiter)
local DataService = require(script.Parent.DataService)
local CurrencyService = require(script.Parent.CurrencyService)

local ClickService = {
	Name = "ClickService",
	Priority = 50,
}

local limiter = RateLimiter.new(GameConfig.Demo.MaxClicksPerSecond)

function ClickService:Start()
	Net.event("Click").OnServerEvent:Connect(function(player: Player)
		-- Der Client schickt KEINE Werte mit. Der Server entscheidet alles.
		if not limiter:Check(player) or not DataService.GetData(player) then
			return
		end

		CurrencyService.Add(player, "Coins", GameConfig.Demo.ClickReward, true)
		DataService.Update(player, "Stats", function(stats)
			stats.TotalClicks += 1
			return stats
		end)
	end)
end

return ClickService
