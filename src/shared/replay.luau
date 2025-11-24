local constants = require("./constants")
local minigame = require("./minigame")

export type MinigameState = minigame.MinigameState
export type MinigameOptions = minigame.MinigameOptions

export type SimulationResult = "fail" | "success" | "timeout"

local TICK_RATE = constants.TICK_RATE

type InputList = { number }

type InputRecorder = {
	inputs: InputList,
	record: (input: boolean) -> (),
}

local TIMEOUT = 0.5 -- 500 ms

local function estimateSize(inputCount: number)
	return 2 -- frame count (uint16)
		+ 2 -- input count (uint16)
		+ 1 -- initial input (uint8)
		+ 2 * inputCount -- frame delta until input changes (uint16 each)
end

local function encodeReplay(frames: number, inputs: InputList): buffer
	local inputCount = #inputs
	local stream = buffer.create(estimateSize(inputCount))
	local offset = 0
	local lastFrame = 0

	buffer.writeu16(stream, offset, frames)
	offset += 2
	buffer.writeu16(stream, offset, inputCount)
	offset += 2

	for _, frame in inputs do
		buffer.writeu16(stream, offset, frame - lastFrame)
		offset += 2
		lastFrame = frame
	end

	return stream
end

local function decodeReplay(stream: buffer): (number, InputList)
	local inputs: InputList = {}
	local offset = 0
	local frame = 0

	local frames = buffer.readu16(stream, offset)
	offset += 2
	local inputCount = buffer.readu16(stream, offset)
	offset += 2

	for _ = 1, inputCount do
		frame += buffer.readu16(stream, offset)
		offset += 2
		table.insert(inputs, frame)
	end

	return frames, inputs
end

local function createRecorder(state: MinigameState): InputRecorder
	local inputs: InputList = {}
	local lastInput = false

	local function record(input: boolean)
		if input ~= lastInput then
			table.insert(inputs, state.frame)
			lastInput = input
		end
	end

	return {
		inputs = inputs,
		record = record,
	}
end

local function simulate(frames: number, inputs: InputList, options: MinigameOptions): SimulationResult
	local state = minigame.create(options)
	local inputCounter = 1
	local input = false

	for frame = 1, frames do
		if inputs[inputCounter] == frame then
			input = not input
			inputCounter += 1
		end

		minigame.update(state, input)

		if state.progress >= 1 or state.progress <= 0 then
			break
		end
	end

	return if state.progress >= 1 then "success" elseif state.progress <= 0 then "fail" else "timeout"
end

local function simulatePerfectGame(options: MinigameOptions): (SimulationResult, number)
	local state = minigame.create(options)
	local frames = 0
	local startTime = os.clock()

	while true do
		state.barPosition = state.fishPosition
		state.barVelocity = 0
		minigame.update(state, true)
		frames += 1

		if os.clock() - startTime > TIMEOUT then
			return "timeout", frames * TICK_RATE
		elseif state.progress >= 1 then
			return "success", frames * TICK_RATE
		elseif state.progress <= 0 then
			return "fail", frames * TICK_RATE
		end
	end
end

return {
	encodeReplay = encodeReplay,
	decodeReplay = decodeReplay,
	createRecorder = createRecorder,
	simulate = simulate,
	simulatePerfectGame = simulatePerfectGame,
}
