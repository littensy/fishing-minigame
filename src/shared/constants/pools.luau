export type PoolInfo = {
	name: string,
	fishes: { string },
}

local pools: { [string]: PoolInfo } = {
	pond = {
		name = "Tranquil Pond",
		fishes = { "salmon", "tuna", "trout", "bullShark" },
	},
}

local function getPoolIdFromInstance(instance: Instance): string?
	local poolId = instance:GetAttribute("PoolId")
	return if type(poolId) == "string" and pools[poolId] then poolId else nil
end

local function getRandomFishFromPool(poolId: string): string
	local fishes = pools[poolId].fishes
	return fishes[math.random(#fishes)]
end

return {
	byId = pools,
	getPoolIdFromInstance = getPoolIdFromInstance,
	getRandomFishFromPool = getRandomFishFromPool,
}
