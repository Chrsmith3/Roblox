--!strict
-- Begrenzt, wie oft ein Spieler eine Aktion pro Sekunde ausführen darf (Token Bucket).
-- Schützt Remotes vor Spam und Exploits.

local Players = game:GetService("Players")

export type RateLimiter = {
	Check: (self: RateLimiter, player: Player) -> boolean,
}

local RateLimiter = {}

function RateLimiter.new(maxPerSecond: number, burst: number?): RateLimiter
	local capacity = burst or maxPerSecond
	local buckets: { [Player]: { tokens: number, last: number } } = {}

	Players.PlayerRemoving:Connect(function(player)
		buckets[player] = nil
	end)

	local self = {} :: any

	function self:Check(player: Player): boolean
		local now = os.clock()
		local bucket = buckets[player]
		if not bucket then
			bucket = { tokens = capacity, last = now }
			buckets[player] = bucket
		end
		bucket.tokens = math.min(capacity, bucket.tokens + (now - bucket.last) * maxPerSecond)
		bucket.last = now
		if bucket.tokens >= 1 then
			bucket.tokens -= 1
			return true
		end
		return false
	end

	return self :: RateLimiter
end

return RateLimiter
