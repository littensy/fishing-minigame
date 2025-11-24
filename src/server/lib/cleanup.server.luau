local Players = game:GetService("Players")

local bobberStore = require("../stores/bobberStore")
local fishingStore = require("../../shared/stores/fishingStore")

Players.PlayerRemoving:Connect(function(player)
	bobberStore.removeBobber(player.Name)
	fishingStore.removePlayer(player.Name)
end)
