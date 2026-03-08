local Players = game:GetService("Players")

local Charm = require("../../../modules/Charm")
local accounts = require("../accounts")
local fishes = require("../../shared/fishes")
local fishingStore = require("../../shared/stores/fishingStore")
local remotes = require("../../shared/remotes")
local replay = require("../../shared/replay")
local rods = require("../../shared/constants/rods")

type FisherReeling = fishingStore.FisherReeling
type MinigameOptions = replay.MinigameOptions
type SimulationResult = replay.SimulationResult

local TIME_LENIENCY = 1
local MAX_PLAY_TIME = 60 * 5

type GameOutcome = SimulationResult | "cancelled"

Charm.observe(fishingStore.getFishersReeling, function(fisher: FisherReeling, username: string)
	local player = Players:FindFirstChild(username)

	if not player or not player:IsA("Player") then
		return
	end

	local options: MinigameOptions = {
		seed = fisher.seed,
		rod = rods.getRod(fisher.rodId),
		fish = fishes.getFish(fisher.fish.fishId),
	}

	local startTime = os.clock()
	local bestResult, minimumTime = replay.simulatePerfectGame(options)
	local outcome: GameOutcome = "cancelled"

	local function shouldReplayCatch()
		return bestResult == "success" and (os.clock() - startTime + TIME_LENIENCY) >= minimumTime
	end

	local function endGame(reason: GameOutcome)
		outcome = reason
		fishingStore.stopFishing(username)
	end

	local catchFish = remotes.catchFish.OnServerEvent:Connect(function(sender, replayData)
		if player ~= sender then
			return
		end

		remotes.assert(remotes.catchFish, replayData)

		if shouldReplayCatch() then
			local frames, inputs = replay.decodeReplay(replayData)
			endGame(replay.simulate(frames, inputs, options))
		else
			endGame("fail")
		end
	end)

	local timeoutThread = task.delay(MAX_PLAY_TIME, function()
		endGame("timeout")
	end)

	return function()
		catchFish:Disconnect()

		if coroutine.status(timeoutThread) == "suspended" then
			task.cancel(timeoutThread)
		end

		if outcome == "success" then
			accounts.addFish(player, fisher.fish)
		end

		remotes.caughtFish:FireAllClients(player, fisher.fish, outcome == "success")
	end
end)
