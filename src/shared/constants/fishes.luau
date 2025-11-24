export type Fish = {
	name: string,
	description: string,
	resilience: number,
	progressSpeed: number,
}

local fishes: { [string]: Fish } = {
	salmon = {
		name = "Salmon",
		description = "A common fish found in rivers.",
		resilience = 0,
		progressSpeed = 0,
	},
	tuna = {
		name = "Tuna",
		description = "A strong fish found in the ocean.",
		resilience = -0.3,
		progressSpeed = -0.2,
	},
	trout = {
		name = "Trout",
		description = "A lively fish found in freshwater.",
		resilience = -0.2,
		progressSpeed = -0.1,
	},
	shark = {
		name = "Shark",
		description = "A large and powerful fish found in the ocean.",
		resilience = -0.6,
		progressSpeed = -0.5,
	},
}

local function getRandomFishId(): string
	local ids = {}
	for key in fishes do
		table.insert(ids, key)
	end
	return ids[math.random(#ids)]
end

return {
	byId = fishes,
	getRandomFishId = getRandomFishId,
}
