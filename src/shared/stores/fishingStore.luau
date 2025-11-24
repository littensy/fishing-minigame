local Charm = require("../../../submodules/Charm")

export type FishingData = {
	seed: number,
	rodId: string,
	fishId: string?,
}

export type CatchingData = {
	seed: number,
	rodId: string,
	fishId: string,
}

export type FishingStore = {
	fishing: { [string]: FishingData },
}

local state: FishingStore = Charm.reactive({ fishing = {} })

local getLuringFishers = Charm.computed(function()
	local result = {}
	for username, entry in state.fishing do
		result[username] = if not entry.fishId then entry else nil
	end
	return result :: { [string]: FishingData }
end)

local getCatchingFishers = Charm.computed(function()
	local result = {}
	for username, entry in state.fishing do
		result[username] = if entry.fishId then entry else nil
	end
	return result :: { [string]: CatchingData }
end)

local function getCatchingState(username: string): CatchingData?
	local data = state.fishing[username]
	return if data and data.fishId then data :: CatchingData else nil
end

local function isFishing(username: string): boolean
	return state.fishing[username] ~= nil
end

local function isLuring(username: string): boolean
	local data = state.fishing[username]
	return data ~= nil and data.fishId == nil
end

local function isCatching(username: string): boolean
	local data = state.fishing[username]
	return data ~= nil and data.fishId ~= nil
end

local function setFishBitingRod(username: string, fishId: string)
	if state.fishing[username] then
		state.fishing[username].fishId = fishId
	end
end

local function setFishing(username: string, entry: FishingData?)
	state.fishing[username] = entry :: FishingData
end

local function removePlayer(username: string)
	setFishing(username, nil)
end

return {
	state = state,
	getLuringFishers = getLuringFishers,
	getCatchingFishers = getCatchingFishers,
	getCatchingState = getCatchingState,
	isFishing = isFishing,
	isLuring = isLuring,
	isCatching = isCatching,
	setFishBitingRod = setFishBitingRod,
	setFishing = setFishing,
	removePlayer = removePlayer,
}
