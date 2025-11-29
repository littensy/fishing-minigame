local constants = require("./constants")
local fishes = require("./fishes")
local numbers = require("./utils/numbers")
local polyfills = require("./utils/polyfills")
local rods = require("./constants/rods")
local stats = require("./stats")

local TICK_RATE = constants.TICK_RATE

local Random = polyfills.Random

export type MinigameState = {
	seed: number,
	random: Random,
	resilience: number,
	range: number,
	speed: number,
	frame: number,
	progress: number,
	barPosition: number,
	barVelocity: number,
	fishPosition: number,
	fishGoal: number,
}

export type MinigameOptions = {
	seed: number,
	rod: rods.RodInfo,
	fish: fishes.FishInfo,
}

local GRAVITY = 3
local BOUNCE_DAMPING = 0.35
local SNAP_THRESHOLD = 0.1
local MAX_FISH_MOVEMENT = 0.3

local function create(options: MinigameOptions): MinigameState
	return {
		seed = options.seed,
		random = Random.new(options.seed),
		resilience = options.rod.resilience + options.fish.resilience,
		range = stats.getBarRange(options.rod.control),
		speed = stats.getProgressSpeed(options.rod.progressSpeed + options.fish.progressSpeed),
		frame = 0,
		input = false,
		progress = 0.2,
		barPosition = 0.5,
		barVelocity = 0,
		fishPosition = 0.5,
		fishGoal = 0.5,
	}
end

local function isReeling(state: MinigameState): boolean
	return math.abs(state.barPosition - state.fishPosition) < state.range
end

local function isSnapped(state: MinigameState, input: boolean): boolean
	return if input
		then state.barPosition + state.range >= 1 and state.barVelocity == 0
		else state.barPosition - state.range <= 0 and state.barVelocity == 0
end

local function update(state: MinigameState, input: boolean)
	state.frame += 1

	-- Do not accelerate while snapped to edge
	if not isSnapped(state, input) then
		state.barVelocity += TICK_RATE * GRAVITY * if input then 1 else -1
		state.barPosition += TICK_RATE * state.barVelocity
	end

	-- Bounce bar off edges
	if state.barPosition + state.range > 1 then
		state.barPosition = 1 - state.range
		state.barVelocity *= if math.abs(state.barVelocity) >= SNAP_THRESHOLD then -BOUNCE_DAMPING else 0
	elseif state.barPosition - state.range < 0 then
		state.barPosition = state.range
		state.barVelocity *= if math.abs(state.barVelocity) >= SNAP_THRESHOLD then -BOUNCE_DAMPING else 0
	end

	-- Compute next fish position on movement frames
	if state.frame % stats.getMovementFrameInterval(state.resilience) == 0 then
		local delta = state.random:NextNumber(-MAX_FISH_MOVEMENT, MAX_FISH_MOVEMENT)
		state.fishGoal = math.clamp(state.fishGoal + delta, 0.05, 0.95)
	end

	-- Move fish towards goal
	state.fishPosition = math.lerp(
		state.fishPosition,
		state.fishGoal,
		numbers.damp(stats.getMovementDamping(state.resilience), TICK_RATE)
	)

	-- Update progress bar
	state.progress += TICK_RATE * if isReeling(state) then state.speed else -stats.getProgressSpeed(0.25)
end

return {
	create = create,
	update = update,
	isReeling = isReeling,
}
