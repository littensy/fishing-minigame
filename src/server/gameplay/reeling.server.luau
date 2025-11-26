local Players = game:GetService("Players")

local Charm = require("../../../submodules/Charm")
local fishes = require("../../shared/constants/fishes")
local fishingStore = require("../../shared/stores/fishingStore")
local remotes = require("../../shared/remotes")
local replay = require("../../shared/replay")
local rods = require("../../shared/constants/rods")

type FisherReeling = fishingStore.FisherReeling
type MinigameOptions = replay.MinigameOptions
type SimulationResult = replay.SimulationResult

local TIME_LENIENCY = 1
local MAX_PLAY_TIME = 60 * 5

type FishingResult = SimulationResult | "cancelled"

local function validateCatch(options: MinigameOptions, replayData: buffer): SimulationResult
	local frames, inputs = replay.decodeReplay(replayData)
	return replay.simulate(frames, inputs, options)
end

Charm.observe(fishingStore.getFishersReeling, function(fisher: FisherReeling, username: string): (() -> ())?
	local player = Players:FindFirstChild(username)

	if not player or not player:IsA("Player") then
		return nil
	end

	local options: MinigameOptions = {
		seed = fisher.seed,
		rod = rods.byId[fisher.rodId],
		fish = fishes.byId[fisher.fishId],
	}

	local bestResult, minimumTime = replay.simulatePerfectGame(options)
	local startTime = os.clock()
	local caught = false

	local function shouldCheckSuccess()
		return bestResult == "success" and (os.clock() - startTime + TIME_LENIENCY) >= minimumTime
	end

	local function onCatch(result: FishingResult)
		if not caught then
			caught = true
			fishingStore.stopFishing(username)
			remotes.caughtFish:FireAllClients(player, fisher.fishId, result == "success")
		end
	end

	local catchFish = remotes.catchFish.OnServerEvent:Connect(function(sender, replayData)
		remotes.assert(remotes.catchFish, replayData)

		if player == sender then
			onCatch(if shouldCheckSuccess() then validateCatch(options, replayData) else "fail")
		end
	end)

	local thread = task.delay(MAX_PLAY_TIME, function()
		onCatch("timeout")
	end)

	return function()
		onCatch("cancelled")
		catchFish:Disconnect()
		if coroutine.status(thread) == "suspended" then
			task.cancel(thread)
		end
	end
end)
