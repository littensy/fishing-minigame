local Players = game:GetService("Players")

local Charm = require("../../../modules/Charm")
local fishingStore = require("../../shared/stores/fishingStore")
local types = require("../../shared/types")

export type FisherReeling = fishingStore.FisherReeling

local getAccount, setAccount = Charm.signal(types.accountTemplate)

local getFisherStatus = Charm.computed(function()
	return fishingStore.getFisherStatus(Players.LocalPlayer.Name)
end)

local isFishing = Charm.computed(function()
	return getFisherStatus() ~= nil
end)

local isLuring = Charm.computed(function()
	return getFisherStatus() == "luring"
end)

local isReeling = Charm.computed(function()
	return getFisherStatus() == "reeling"
end)

local function getFisher()
	return fishingStore.getFisher(Players.LocalPlayer.Name)
end

return {
	getAccount = getAccount,
	setAccount = setAccount,
	isFishing = isFishing,
	isLuring = isLuring,
	isReeling = isReeling,
	getFisher = getFisher,
}
