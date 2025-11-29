local Players = game:GetService("Players")

local accountStore = require("../stores/accountStore")
local store = require("./store")

Players.PlayerAdded:Connect(function(player)
	store:load(player)
end)

Players.PlayerRemoving:Connect(function(player)
	store:unload(player)
	accountStore.removeAccount(player.Name)
end)
