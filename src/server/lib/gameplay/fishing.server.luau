local Players = game:GetService("Players")

local Charm = require("../../../../submodules/Charm")
local fishes = require("../../../shared/constants/fishes")
local fishingStore = require("../../../shared/stores/fishingStore")
local remotes = require("../../../shared/remotes")
local replay = require("../../../shared/replay")
local rods = require("../../../shared/constants/rods")

type CatchingData = fishingStore.CatchingData
type MinigameOptions = replay.MinigameOptions
type SimulationResult = replay.SimulationResult

local TIME_LENIENCY = 1
local MAX_PLAY_TIME = 60 * 5

type FishingResult = SimulationResult | "cancelled"

local function validateCatch(options: MinigameOptions, replayData: buffer): SimulationResult
	local frames, inputs = replay.decodeReplay(replayData)
	return replay.simulate(frames, inputs, options)
end

Charm.observe(fishingStore.getCatchingFishers, function(data, username)
	local player = Players:FindFirstChild(username)

	if not player or not player:IsA("Player") then
		return
	end

	local options: MinigameOptions = {
		seed = data.seed,
		rod = rods.byId[data.rodId],
		fish = fishes.byId[data.fishId],
	}

	local bestResult, minimumTime = replay.simulatePerfectGame(options)
	local startTime = os.clock()
	local processed = false

	local function shouldCheckSuccess()
		return bestResult == "success" and (os.clock() - startTime + TIME_LENIENCY) >= minimumTime
	end

	local function processCatch(result: FishingResult)
		if not processed then
			processed = true
			fishingStore.removePlayer(username)
			remotes.caughtFish:FireAllClients(player, data.fishId, result == "success")
		end
	end

	local catchFish = remotes.catchFish.OnServerEvent:Connect(function(sender, replayData)
		remotes.assert(remotes.catchFish, replayData)

		if player == sender then
			processCatch(if shouldCheckSuccess() then validateCatch(options, replayData) else "fail")
		end
	end)

	local thread = task.delay(MAX_PLAY_TIME, function()
		processCatch("timeout")
	end)

	return function()
		processCatch("cancelled")
		catchFish:Disconnect()
		if coroutine.status(thread) == "suspended" then
			task.cancel(thread)
		end
	end
end)
