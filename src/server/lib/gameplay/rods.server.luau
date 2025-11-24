local Charm = require("../../../../submodules/Charm")
local bobberStore = require("../../stores/bobberStore")
local fishingStore = require("../../../shared/stores/fishingStore")
local observers = require("../../../shared/utils/observers")
local remotes = require("../../../shared/remotes")
local rods = require("../../../shared/constants/rods")

local function connectRod(player: Player, character: Model, rodId: string?)
	if not rodId then
		return
	end

	local castRod = remotes.castRod.OnServerEvent:Connect(function(sender, power)
		remotes.assert(remotes.castRod, power)

		if sender == player and not fishingStore.isFishing(player.Name) then
			bobberStore.addBobber(player.Name, character, power, rodId)
		end
	end)

	return function()
		castRod:Disconnect()
		bobberStore.removeBobber(player.Name)
		fishingStore.removePlayer(player.Name)
	end
end

observers.observePlayers(function(player)
	return observers.observeCharacter(player, function(character)
		local getRodId, setRodId = Charm.signal(nil :: string?)

		local stopEffect = Charm.effect(function()
			return connectRod(player, character, getRodId())
		end)

		local childAdded = character.ChildAdded:Connect(function()
			setRodId(rods.getRodIdFromCharacter(character))
		end)

		local childRemoved = character.ChildRemoved:Connect(function()
			setRodId(rods.getRodIdFromCharacter(character))
		end)

		return function()
			childAdded:Disconnect()
			childRemoved:Disconnect()
			stopEffect()
		end
	end)
end)
