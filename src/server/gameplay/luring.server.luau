local RunService = game:GetService("RunService")

local Charm = require("../../../submodules/Charm")
local fishingStore = require("../../shared/stores/fishingStore")
local pools = require("../../shared/constants/pools")
local remotes = require("../../shared/remotes")
local rods = require("../../shared/constants/rods")
local stats = require("../../shared/stats")

type FisherLuring = fishingStore.FisherLuring

local SHAKE_COOLDOWN = 0.2
local SHAKE_REDUCTION = 0.5

Charm.observe(fishingStore.getFishersLuring, function(fisher: FisherLuring, username: string)
	local rod = rods.byId[fisher.rodId]
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
			fishingStore.setReelingFish(username, pools.getRandomFishFromPool(fisher.poolId))
		end
	end)

	return function()
		shakeRod:Disconnect()
		heartbeat:Disconnect()
	end
end)
