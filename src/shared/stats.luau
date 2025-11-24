local constants = require("./constants")

local TICK_RATE = constants.TICK_RATE

local function getMovementInterval(resilience: number): number
	return math.clamp(1 * (1 + resilience), 0.3, 2)
end

local function getMovementFrameInterval(resilience: number): number
	return math.ceil(getMovementInterval(resilience) / TICK_RATE)
end

local function getMovementDamping(resilience: number): number
	return math.map(getMovementInterval(resilience), 0.3, 2, 10, 0.5)
end

local function getLureTime(percentage: number): number
	return 10 * (1 - percentage)
end

local function getBarRange(percentage: number): number
	return math.clamp(0.2 * (1 + percentage), 0.01, 0.49)
end

local function getProgressSpeed(percentage: number): number
	return 0.15 * (1 + percentage)
end

local function getProgressSpeedPercentage(progressSpeed: number): number
	return (progressSpeed / 0.15) - 1
end

return {
	getMovementInterval = getMovementInterval,
	getMovementFrameInterval = getMovementFrameInterval,
	getMovementDamping = getMovementDamping,
	getLureTime = getLureTime,
	getBarRange = getBarRange,
	getProgressSpeed = getProgressSpeed,
	getProgressSpeedPercentage = getProgressSpeedPercentage,
}
