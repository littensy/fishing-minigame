local Players = game:GetService("Players")

local Charm = require("../../../submodules/Charm")
local fishingStore = require("../../shared/stores/fishingStore")

type CatchingData = fishingStore.CatchingData

local isFishing = Charm.computed(function()
	return fishingStore.isFishing(Players.LocalPlayer.Name)
end)

local isLuring = Charm.computed(function()
	return fishingStore.isLuring(Players.LocalPlayer.Name)
end)

local isCatching = Charm.computed(function()
	return fishingStore.isCatching(Players.LocalPlayer.Name)
end)

local getCatchingState = Charm.computed(function()
	return fishingStore.getCatchingState(Players.LocalPlayer.Name)
end)

return {
	isFishing = isFishing,
	isLuring = isLuring,
	isCatching = isCatching,
	getCatchingState = getCatchingState,
}
