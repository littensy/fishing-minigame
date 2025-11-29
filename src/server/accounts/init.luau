local HttpService = game:GetService("HttpService")

local fishes = require("../shared/fishes")
local fishingStore = require("../shared/stores/fishingStore")
local store = require("@self/store")
local types = require("../shared/types")

type Account = types.Account

local function sellFish(player: Player, uniqueId: string)
	return store:update(player, function(account: Account)
		local fish = account.fishes[uniqueId]
		if not fish then
			return false
		end
		account.fishes[uniqueId] = nil
		account.gold += fishes.getFishValue(fish)
		return true
	end)
end

local function addReeledFish(player: Player)
	return store:update(player, function(account: Account)
		local fisher = fishingStore.getFisher(player.Name)
		if not fisher or not fisher.fish then
			return false
		end
		account.fishes[HttpService:GenerateGUID(false)] = {
			fishId = fisher.fish.fishId,
			weightMultiplier = fisher.fish.weightMultiplier,
			mutations = fisher.fish.mutations,
		}
		return true
	end)
end

local function removeFish(player: Player, uniqueId: string)
	return store:update(player, function(account: Account)
		account.fishes[uniqueId] = nil
		return true
	end)
end

return {
	sellFish = sellFish,
	addReeledFish = addReeledFish,
	removeFish = removeFish,
}
