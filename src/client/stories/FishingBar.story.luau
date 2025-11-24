local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local FishingBar = require("../components/FishingBar")
local Vide = require("../../../submodules/Vide")
local fishes = require("../../shared/constants/fishes")
local fishingStore = require("../../shared/stores/fishingStore")
local inputStore = require("../stores/inputStore")
local px = require("../utils/px")
local useInterval = require("../hooks/useInterval")

return function(target: Instance)
	return Vide.mount(function()
		fishingStore.setFishing(Players.LocalPlayer.Name, {
			seed = tick(),
			rodId = if math.random() > 0.5 then "basic" else "advanced",
			fishId = fishes.getRandomFishId(),
		})

		useInterval(function()
			inputStore.holdRod(UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1))
		end, 0)

		px.setScale(2)

		return FishingBar()
	end, target)
end
