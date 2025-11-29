local stats = require("../stats")
local test = require("../../../tests/test")

test("progress speed should be reversible", function()
	for percentage = -1, 1, 0.1 do
		local speed = stats.getProgressSpeed(percentage)
		local computedPercentage = stats.getProgressSpeedPercentage(speed)

		if math.abs(computedPercentage - percentage) > 0.0001 then
			error(`percentage: {percentage}, speed: {speed}, computedPercentage: {computedPercentage}`)
		end
	end
end)

return {}
