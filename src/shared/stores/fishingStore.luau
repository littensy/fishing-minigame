local Charm = require("../../../modules/Charm")
local fishes = require("../fishes")
local objects = require("../utils/objects")

type Fish = fishes.Fish

export type Fisher = {
	seed: number,
	rodId: string,
	castPower: number,
	poolId: string?,
	fish: Fish?,
}

export type FisherLuring = Fisher & {
	poolId: string,
}

export type FisherReeling = Fisher & {
	poolId: string,
	fish: Fish,
}

local state = Charm.reactive({
	fishing = {} :: { [string]: Fisher },
})

local function getFishers()
	return state.fishing
end

local getFishersLuring = Charm.computed(function()
	return objects.map(state.fishing, function(fisher: Fisher): FisherLuring?
		return if fisher.poolId ~= nil and fisher.fish == nil then fisher else nil
	end)
end)

local getFishersReeling = Charm.computed(function()
	return objects.map(state.fishing, function(fisher: Fisher): FisherReeling?
		return if fisher.poolId ~= nil and fisher.fish ~= nil then fisher else nil
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
	return fisher ~= nil and fisher.poolId ~= nil and fisher.fish == nil
end

local function isReeling(username: string): boolean
	local fisher = state.fishing[username]
	return fisher ~= nil and fisher.poolId ~= nil and fisher.fish ~= nil
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

local function setReelingFish(username: string, fish: Fish)
	local fisher = state.fishing[username]
	if fisher then
		fisher.fish = fish
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
