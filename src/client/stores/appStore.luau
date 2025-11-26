local Players = game:GetService("Players")

local Charm = require("../../../submodules/Charm")
local fishingStore = require("../../shared/stores/fishingStore")
local types = require("../../shared/types")

export type FisherReeling = fishingStore.FisherReeling

local account = Charm.reactive(types.accountTemplate)

local isFishing = Charm.computed(function()
	return fishingStore.isFishing(Players.LocalPlayer.Name)
end)

local isLuring = Charm.computed(function()
	return fishingStore.isLuring(Players.LocalPlayer.Name)
end)

local isReeling = Charm.computed(function()
	return fishingStore.isReeling(Players.LocalPlayer.Name)
end)

local function getFisher()
	return fishingStore.getFisher(Players.LocalPlayer.Name)
end

return {
	account = account,
	isFishing = isFishing,
	isLuring = isLuring,
	isReeling = isReeling,
	getFisher = getFisher,
}
