local Players = game:GetService("Players")

local CharmSync = require("../../../submodules/CharmSync")
local accountStore = require("../stores/accountStore")
local fishingStore = require("../../shared/stores/fishingStore")
local remotes = require("../../shared/remotes")

local function onPlayerAdded(player: Player)
	CharmSync.server.addSignalsToClient(player, {
		fishing = fishingStore.state,
		[player.Name] = accountStore.selectAccount(player.Name),
	})
end

local function onPlayerRemoving(player: Player)
	CharmSync.server.removeClient(player)
end

CharmSync.server.connect(function(player, patches)
	remotes.patch:FireClient(player, patches)
end)

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end
