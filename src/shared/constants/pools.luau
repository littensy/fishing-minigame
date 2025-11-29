export type PoolInfo = {
	name: string,
	fishes: { string },
}

local poolsById: { [string]: PoolInfo } = {
	pond = {
		name = "Tranquil Pond",
		fishes = { "salmon", "tuna", "trout", "bullShark" },
	},
}

local function getPool(poolId: string): PoolInfo
	return assert(poolsById[poolId], `Failed to get pool {poolId}`)
end

local function getPoolIdFromInstance(instance: Instance): string?
	local poolId = instance:GetAttribute("PoolId")
	return if type(poolId) == "string" and poolsById[poolId] then poolId else nil
end

local function getRandomFishFromPool(poolId: string): string
	local fishes = poolsById[poolId].fishes
	return fishes[math.random(#fishes)]
end

return {
	poolsById = poolsById,
	getPool = getPool,
	getPoolIdFromInstance = getPoolIdFromInstance,
	getRandomFishFromPool = getRandomFishFromPool,
}
