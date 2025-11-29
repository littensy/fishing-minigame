local fishes = require("../fishes")
local minigame = require("../minigame")
local polyfills = require("../utils/polyfills")
local rods = require("../constants/rods")
local test = require("../../../tests/test")

local Random = polyfills.Random

local function play(seed: number)
	local random = Random.new(seed)
	local state = minigame.create({
		seed = seed,
		rod = rods.getRod("basic"),
		fish = fishes.getFish("salmon"),
	})
	for _ = 1, 100 do
		minigame.update(state, random:NextInteger(0, 1) == 0)
	end
	return state :: { [string]: any }
end

test("should be deterministic given the same seed and inputs", function()
	local seed = 12345
	local state1 = play(seed)
	local state2 = play(seed)

	for key, value in state1 do
		local isPrimitive = type(value) ~= "table" and type(value) ~= "userdata"
		if isPrimitive then
			assert(state2[key] == value, `Entry {key} does not match: {state2[key]} ~= {value}`)
		end
	end
end)

return {}
