local Players = game:GetService("Players")

local CharmSync = require("../../../modules/CharmSync")
local appStore = require("../stores/appStore")
local fishingStore = require("../../shared/stores/fishingStore")
local remotes = require("../../shared/remotes")

CharmSync.client.addSignals({
	fishing = fishingStore.setFishers,
	[`account-{Players.LocalPlayer}`] = appStore.setAccount,
} :: any)

remotes.patch.OnClientEvent:Connect(function(patches)
	CharmSync.client.patch(patches)
end)
