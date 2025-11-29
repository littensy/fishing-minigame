local Vide = require("../../../modules/Vide")
local constants = require("../../shared/constants")
local fishes = require("../../shared/fishes")
local inputStore = require("../stores/inputStore")
local minigame = require("../../shared/minigame")
local replay = require("../../shared/replay")
local rods = require("../../shared/constants/rods")
local useInterval = require("./useInterval")
local usePolled = require("./usePolled")

type Source<T> = Vide.Source<T>

local TICK_RATE = constants.TICK_RATE

local derive = Vide.derive
local source = Vide.source

type MinigameStatus = "idle" | "playing" | "complete"

type MinigameController = {
	state: minigame.MinigameState,
	start: () -> (),
	getStatus: () -> MinigameStatus,
	getBarPosition: () -> number,
	getFishPosition: () -> number,
	getProgress: () -> number,
	export: () -> buffer,
}

local function createKeyframe(state: minigame.MinigameState)
	return {
		timestamp = os.clock(),
		barPosition = state.barPosition,
		fishPosition = state.fishPosition,
		progress = state.progress,
	}
end

local function useMinigame(seed: number, rod: rods.RodInfo, fish: fishes.FishInfo): MinigameController
	local status = source("idle") :: Source<MinigameStatus>
	local state = minigame.create({ seed = seed, rod = rod, fish = fish })
	local recorder = replay.createRecorder(state)
	local keyframe = createKeyframe(state)

	local getInterpolation = usePolled(function()
		local delta = os.clock() - keyframe.timestamp
		return math.clamp(delta / TICK_RATE, 0, 1)
	end)

	local getBarPosition = derive(function()
		return math.lerp(keyframe.barPosition, state.barPosition, getInterpolation())
	end)

	local getFishPosition = derive(function()
		return math.lerp(keyframe.fishPosition, state.fishPosition, getInterpolation())
	end)

	local getProgress = derive(function()
		return math.clamp(math.lerp(keyframe.progress, state.progress, getInterpolation()), 0, 1)
	end)

	local function start()
		status("playing")
	end

	local function export()
		return replay.encodeReplay(state.frame, recorder.inputs)
	end

	useInterval(function()
		if status() ~= "playing" then
			return
		end

		local input = inputStore.holdRod()

		keyframe = createKeyframe(state)
		minigame.update(state, input)
		recorder.record(input)

		if state.progress >= 1 or state.progress <= 0 then
			status("complete")
		end
	end, TICK_RATE)

	return {
		state = state,
		start = start,
		getStatus = status,
		getBarPosition = getBarPosition,
		getFishPosition = getFishPosition,
		getProgress = getProgress,
		export = export,
	}
end

return useMinigame
