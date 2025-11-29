local Charm = require("../../../modules/Charm")
local fishingStore = require("../../shared/stores/fishingStore")
local observers = require("../../shared/utils/observers")
local remotes = require("../../shared/remotes")
local rods = require("../../shared/constants/rods")

local function connectRod(player: Player, rodId: string?): (() -> ())?
	if not rodId then
		return nil
	end

	local castRod = remotes.castRod.OnServerEvent:Connect(function(sender, power)
		remotes.assert(remotes.castRod, power)

		if sender == player and not fishingStore.isFishing(player.Name) then
			fishingStore.castRod(player.Name, rodId, power, tick())
		end
	end)

	return function()
		castRod:Disconnect()
		fishingStore.stopFishing(player.Name)
	end
end

observers.observePlayers(function(player)
	return observers.observeCharacter(player, function(character)
		local getRodId, setRodId = Charm.signal(nil :: string?)

		local dispose = Charm.effect(function()
			return connectRod(player, getRodId())
		end)

		local function update(child: Instance)
			if child:IsA("Tool") then
				setRodId(rods.getRodIdFromCharacter(character))
			end
		end

		local childAdded = character.ChildAdded:Connect(update)
		local childRemoved = character.ChildRemoved:Connect(update)

		return function()
			childAdded:Disconnect()
			childRemoved:Disconnect()
			dispose()
		end
	end)
end)
