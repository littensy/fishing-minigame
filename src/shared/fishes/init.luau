local constants = require("@self/constants")
local mutations = require("./constants/mutations")
local types = require("@self/types")

export type Fish = types.Fish
export type FishInfo = types.FishInfo

local function getFishWeight(fish: Fish): number
	local info = constants.getFish(fish.fishId)
	return info.weight * fish.weightMultiplier
end

local function getFishValue(fish: Fish): number
	local info = constants.getFish(fish.fishId)
	return math.ceil(info.valuePerPound * getFishWeight(fish))
end

local function stringifyFish(fish: Fish): string
	local tokens: { string } = {}

	for mutationId in fish.mutations do
		table.insert(tokens, mutations.getMutation(mutationId).name)
	end

	table.insert(tokens, constants.getFish(fish.fishId).name)

	return table.concat(tokens, " ")
end

return {
	fishesById = constants.fishesById,
	getFish = constants.getFish,
	stringifyFish = stringifyFish,
	getFishValue = getFishValue,
	getFishWeight = getFishWeight,
}
