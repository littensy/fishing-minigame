local types = require("./types")

type FishInfo = types.FishInfo

local fishesById: { [string]: FishInfo } = {
	salmon = {
		name = "Salmon",
		description = "A common fish found in rivers.",
		weight = 8,
		valuePerPound = 5,
		resilience = 0,
		progressSpeed = 0,
	},
	tuna = {
		name = "Tuna",
		description = "A strong fish found in the ocean.",
		weight = 15,
		valuePerPound = 8,
		resilience = -0.3,
		progressSpeed = -0.2,
	},
	trout = {
		name = "Trout",
		description = "A lively fish found in freshwater.",
		weight = 10,
		valuePerPound = 6,
		resilience = -0.2,
		progressSpeed = -0.1,
	},
	bullShark = {
		name = "Bull Shark",
		description = "A large and powerful fish found in the ocean.",
		weight = 290,
		valuePerPound = 15,
		resilience = -0.6,
		progressSpeed = -0.5,
	},
}

local function getFish(fishId: string): FishInfo
	return fishesById[fishId]
end

return {
	fishesById = fishesById,
	getFish = getFish,
}
