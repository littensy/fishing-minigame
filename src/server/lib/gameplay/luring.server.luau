local RunService = game:GetService("RunService")

local Charm = require("../../../../submodules/Charm")
local fishes = require("../../../shared/constants/fishes")
local fishingStore = require("../../../shared/stores/fishingStore")
local remotes = require("../../../shared/remotes")
local rods = require("../../../shared/constants/rods")
local stats = require("../../../shared/stats")

local SHAKE_COOLDOWN = 0.2
local SHAKE_REDUCTION = 0.5

Charm.observe(fishingStore.getLuringFishers, function(data, username)
	local rod = rods.byId[data.rodId]
	local timer = stats.getLureTime(rod.lureSpeed)
	local cooldown = os.clock() + SHAKE_COOLDOWN

	local shakeRod = remotes.shakeRod.OnServerEvent:Connect(function(sender)
		if sender.Name == username and os.clock() >= cooldown then
			cooldown = os.clock() + SHAKE_COOLDOWN
			timer -= SHAKE_REDUCTION
		end
	end)

	local heartbeat = RunService.Heartbeat:Connect(function(delta)
		timer -= delta
		if timer <= 0 then
			fishingStore.setFishBitingRod(username, fishes.getRandomFishId())
		end
	end)

	return function()
		shakeRod:Disconnect()
		heartbeat:Disconnect()
	end
end)
