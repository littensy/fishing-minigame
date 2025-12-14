local Players = game:GetService("Players")

local Charm = require("../../../modules/Charm")
local CharmSync = require("../../../modules/CharmSync")
local accountStore = require(".././stores/accountStore")
local fishingStore = require("../../shared/stores/fishingStore")
local remotes = require("../../shared/remotes")

local function onPlayerAdded(player: Player)
	CharmSync.server.addSignalsToClient(player, {
		fishing = fishingStore.getFishers,
		[`account-{player.Name}`] = Charm.computed(function()
			return accountStore.getAccount(player.Name)
		end),
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
