local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local FishingBar = require("../components/FishingBar")
local Vide = require("../../../modules/Vide")
local fishingStore = require("../../shared/stores/fishingStore")
local inputStore = require("../stores/inputStore")
local pools = require("../../shared/constants/pools")
local px = require("../utils/px")
local useInterval = require("../hooks/useInterval")

return function(target: Instance)
	return Vide.mount(function()
		local username = Players.LocalPlayer.Name
		local rodId = if math.random() > 0.5 then "basic" else "advanced"

		fishingStore.castRod(username, rodId, 1, tick())
		fishingStore.setLuringPool(username, "pond")
		fishingStore.setReelingFish(username, {
			fishId = pools.getRandomFishFromPool("pond"),
			weightMultiplier = 1,
			mutations = {},
		})

		useInterval(function()
			inputStore.holdRod(UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1))
		end, 0)

		px.setScale(2)

		return FishingBar()
	end, target)
end
