local Random = Random

if not Random then
	local RandomPolyfill = {}
	RandomPolyfill.__index = RandomPolyfill

	function RandomPolyfill.new(seed: number?): any
		if seed then
			math.randomseed(seed)
		end
		return setmetatable({}, RandomPolyfill)
	end

	function RandomPolyfill:NextNumber(min: number?, max: number?): number
		return math.lerp(min or 0, max or 1, math.random())
	end

	function RandomPolyfill:NextInteger(min: number, max: number): number
		return math.random(min, max)
	end

	Random = RandomPolyfill :: never
end

return {
	Random = Random,
}
