local objects = require("../utils/objects")

export type MutationInfo = {
	name: string,
	valueMultipler: number,
}

local mutationsById: { [string]: MutationInfo } = {
	shiny = {
		name = "Shiny",
		valueMultipler = 0.2,
	},
	sparkling = {
		name = "Sparkling",
		valueMultipler = 0.2,
	},
	garbage = {
		name = "Garbage",
		valueMultipler = -0.1,
	},
}

local mutationIds = objects.keys(mutationsById)

local function getMutation(mutationId: string): MutationInfo
	return assert(mutationsById[mutationId], `Failed to get mutation {mutationId}`)
end

local function selectMutations(): { [string]: boolean }
	local results: { [string]: boolean } = {}
	while math.random() > 0.5 do
		results[mutationIds[math.random(#mutationIds)]] = true
	end
	return results
end

return {
	mutationsById = mutationsById,
	getMutation = getMutation,
	selectMutations = selectMutations,
}
