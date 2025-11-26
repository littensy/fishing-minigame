local Charm = require("../../../submodules/Charm")
local objects = require("../utils/objects")

export type Fisher = {
	seed: number,
	rodId: string,
	castPower: number,
	poolId: string?,
	fishId: string?,
}

export type FisherLuring = Fisher & {
	poolId: string,
}

export type FisherReeling = Fisher & {
	poolId: string,
	fishId: string,
}

local state = Charm.reactive({
	fishing = {} :: { [string]: Fisher },
})

local function getFishers()
	return state.fishing
end

local getFishersLuring = Charm.computed(function()
	return objects.map(state.fishing, function(fisher: Fisher): FisherLuring?
		return if fisher.poolId ~= nil and fisher.fishId == nil then fisher else nil
	end)
end)

local getFishersReeling = Charm.computed(function()
	return objects.map(state.fishing, function(fisher: Fisher): FisherReeling?
		return if fisher.poolId ~= nil and fisher.fishId ~= nil then fisher else nil
	end)
end)

local function getFisher(username: string): Fisher?
	return state.fishing[username]
end

local function isFishing(username: string): boolean
	return state.fishing[username] ~= nil
end

local function isLuring(username: string): boolean
	local fisher = state.fishing[username]
	return fisher ~= nil and fisher.poolId ~= nil and fisher.fishId == nil
end

local function isReeling(username: string): boolean
	local fisher = state.fishing[username]
	return fisher ~= nil and fisher.poolId ~= nil and fisher.fishId ~= nil
end

local function castRod(username: string, rodId: string, power: number, seed: number)
	state.fishing[username] = state.fishing[username] or {
		rodId = rodId,
		castPower = power,
		seed = seed,
	}
end

local function setLuringPool(username: string, poolId: string)
	local fisher = state.fishing[username]
	if fisher then
		fisher.poolId = poolId
	end
end

local function setReelingFish(username: string, fishId: string)
	local fisher = state.fishing[username]
	if fisher then
		fisher.fishId = fishId
	end
end

local function stopFishing(username: string)
	state.fishing[username] = nil
end

return {
	state = state,
	getFishers = getFishers,
	getFishersLuring = getFishersLuring,
	getFishersReeling = getFishersReeling,
	getFisher = getFisher,
	isFishing = isFishing,
	isLuring = isLuring,
	isReeling = isReeling,
	castRod = castRod,
	setLuringPool = setLuringPool,
	setReelingFish = setReelingFish,
	stopFishing = stopFishing,
}
