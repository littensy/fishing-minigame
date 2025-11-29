local RunService = game:GetService("RunService")

local Charm = require("../../../modules/Charm")
local fishingStore = require("../../shared/stores/fishingStore")
local mutations = require("../../shared/constants/mutations")
local pools = require("../../shared/constants/pools")
local remotes = require("../../shared/remotes")
local rods = require("../../shared/constants/rods")
local stats = require("../../shared/stats")

type FisherLuring = fishingStore.FisherLuring

local SHAKE_COOLDOWN = 0.2
local SHAKE_REDUCTION = 0.5

local random = Random.new()

Charm.observe(fishingStore.getFishersLuring, function(fisherProxy: FisherLuring, username: string)
	local rod = rods.getRod(fisherProxy.rodId)
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
			fishingStore.setReelingFish(username, {
				fishId = pools.getRandomFishFromPool(fisherProxy.poolId),
				weightMultiplier = random:NextNumber(0.5, 1.5),
				mutations = mutations.selectMutations(),
			})
		end
	end)

	return function()
		shakeRod:Disconnect()
		heartbeat:Disconnect()
	end
end)
