local function damp(lambda: number, dt: number): number
	return 1 - math.exp(-lambda * dt)
end

local function displaySignedPercentage(value: number): string
	local sign = if value >= 0 then "+" else "-"
	return `{sign}{math.round(math.abs(value) * 100)}%`
end

return {
	damp = damp,
	displaySignedPercentage = displaySignedPercentage,
}
