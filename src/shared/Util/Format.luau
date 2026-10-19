--!strict
-- Zahlen- und Zeitformatierung für die UI (1.2K, 3.45M, 1h 05m ...).

local Format = {}

local SUFFIXES = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc" }

-- 1234 -> "1.23K", 1500000 -> "1.5M"
function Format.abbreviate(value: number, decimals: number?): string
	local places = decimals or 2
	local sign = if value < 0 then "-" else ""
	local n = math.abs(value)

	if n < 1000 then
		return sign .. tostring(math.floor(n))
	end

	local index = math.min(math.floor(math.log10(n) / 3), #SUFFIXES - 1)
	local scaled = n / (1000 ^ index)
	local factor = 10 ^ places
	scaled = math.floor(scaled * factor) / factor

	local text = string.format("%." .. places .. "f", scaled)
	if places > 0 then
		text = string.gsub(text, "%.?0+$", "")
	end
	return sign .. text .. SUFFIXES[index + 1]
end

-- 1234567 -> "1,234,567"
function Format.commas(value: number): string
	local text = tostring(math.floor(value))
	local formatted = text
	local count: number
	repeat
		formatted, count = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
	until count == 0
	return formatted
end

-- 3725 -> "1h 02m", 125 -> "2m 05s", 9 -> "9s"
function Format.duration(seconds: number): string
	local s = math.max(0, math.floor(seconds))
	local h = s // 3600
	local m = (s % 3600) // 60
	local sec = s % 60
	if h > 0 then
		return string.format("%dh %02dm", h, m)
	elseif m > 0 then
		return string.format("%dm %02ds", m, sec)
	end
	return string.format("%ds", sec)
end

return Format
