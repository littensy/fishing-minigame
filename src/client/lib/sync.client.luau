local Players = game:GetService("Players")

local CharmSync = require("../../../submodules/CharmSync")
local appStore = require("../stores/appStore")
local fishingStore = require("../../shared/stores/fishingStore")
local remotes = require("../../shared/remotes")

CharmSync.client.addSignals({
	fishing = fishingStore.state,
	[Players.LocalPlayer.Name] = appStore.account,
})

remotes.patch.OnClientEvent:Connect(function(patches)
	CharmSync.client.patch(patches)
end)
