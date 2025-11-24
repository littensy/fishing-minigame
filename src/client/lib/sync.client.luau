local CharmSync = require("../../../submodules/CharmSync")
local fishingStore = require("../../shared/stores/fishingStore")
local remotes = require("../../shared/remotes")

CharmSync.client.addSignals({
	fishing = fishingStore.state,
})

remotes.patch.OnClientEvent:Connect(function(patches)
	CharmSync.client.patch(patches)
end)
