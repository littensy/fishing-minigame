local fishes = require("../fishes")
local minigame = require("../minigame")
local replay = require("../replay")
local rods = require("../constants/rods")
local test = require("../../../tests/test")

test("should encode and decode replay", function()
	local frames = 120
	local inputs = table.create(frames // 10, 10)

	local data = replay.encodeReplay(frames, inputs)
	local decodedFrames, decodedInputs = replay.decodeReplay(data)

	assert(decodedFrames == frames, `frames: {decodedFrames} != {frames}`)
	assert(#decodedInputs == #inputs, `input count: {#decodedInputs} != {#inputs}`)

	for i = 1, #inputs do
		assert(decodedInputs[i] == inputs[i], `input[{i}]: {decodedInputs[i]} != {inputs[i]}`)
	end
end)

test("should record inputs", function()
	local state = minigame.create({
		seed = 0,
		rod = rods.getRod("basic"),
		fish = fishes.getFish("salmon"),
	})
	local recorder = replay.createRecorder(state)
	local totalFrames = 100

	for frame = 1, totalFrames do
		local input = (frame % 15) < 7
		minigame.update(state, input)
		recorder.record(input)
	end

	local data = replay.encodeReplay(totalFrames, recorder.inputs)
	local decodedFrames, decodedInputs = replay.decodeReplay(data)

	assert(decodedFrames == totalFrames, `frames: {decodedFrames} != {totalFrames}`)
	assert(#decodedInputs == #recorder.inputs, `input count: {#decodedInputs} != {#recorder.inputs}`)

	for i = 1, #recorder.inputs do
		assert(decodedInputs[i] == recorder.inputs[i], `input[{i}]: {decodedInputs[i]} != {recorder.inputs[i]}`)
	end
end)

return {}
