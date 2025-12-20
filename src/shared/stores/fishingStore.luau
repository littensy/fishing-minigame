local Charm = require("../../../modules/Charm")
local fishes = require("../fishes")
local objects = require("../utils/objects")

type Fish = fishes.Fish

export type Fisher = {
	read seed: number,
	read castPower: number,
	read rodId: string,
	read poolId: string?,
	read fish: Fish?,
}

export type FisherLuring = Fisher & {
	read poolId: string,
}

export type FisherReeling = Fisher & {
	read poolId: string,
	read fish: Fish,
}

type Fishers = {
	[string]: Fisher,
}

local getFishers, setFishers = Charm.signal({} :: Fishers)

local getFishersLuring = Charm.computed(function()
	return objects.map(getFishers(), function(fisher: Fisher): FisherLuring?
		return if fisher.poolId ~= nil and fisher.fish == nil then fisher else nil
	end)
end)

local getFishersReeling = Charm.computed(function()
	return objects.map(getFishers(), function(fisher: Fisher): FisherReeling?
		return if fisher.poolId ~= nil and fisher.fish ~= nil then fisher else nil
	end)
end)

local function getFisher(username: string): Fisher?
	return getFishers()[username]
end

local function isFishing(username: string): boolean
	return getFishers()[username] ~= nil
end

local function isLuring(username: string): boolean
	local fisher = getFisher(username)
	return fisher ~= nil and fisher.poolId ~= nil and fisher.fish == nil
end

local function isReeling(username: string): boolean
	local fisher = getFisher(username)
	return fisher ~= nil and fisher.poolId ~= nil and fisher.fish ~= nil
end

local function castRod(username: string, rodId: string, power: number, seed: number)
	setFishers(function(state: Fishers)
		return objects.set(state, username, {
			seed = seed,
			castPower = power,
			rodId = rodId,
			poolId = nil,
			fish = nil,
		})
	end)
end

local function setLuringPool(username: string, poolId: string)
	setFishers(function(state: Fishers)
		return objects.update(state, username, function(fisher: Fisher)
			return objects.set(fisher, "poolId", poolId)
		end)
	end)
end

local function setReelingFish(username: string, fish: Fish)
	setFishers(function(state: Fishers)
		return objects.update(state, username, function(fisher: Fisher)
			return objects.set(fisher, "fish", fish)
		end)
	end)
end

local function stopFishing(username: string)
	setFishers(function(state: Fishers)
		return objects.delete(state, username)
	end)
end

return {
	getFishers = getFishers,
	setFishers = setFishers,
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
