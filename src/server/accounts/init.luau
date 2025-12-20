local HttpService = game:GetService("HttpService")

local fishes = require("../shared/fishes")
local fishingStore = require("../shared/stores/fishingStore")
local objects = require("../shared/utils/objects")
local store = require("@self/store")
local types = require("../shared/types")

type Account = types.Account

local function sellFish(player: Player, uniqueId: string)
	return store:updateImmutable(player, function(account)
		local fish = account.fishes[uniqueId]

		if not fish then
			return false
		end

		return objects.join(account, {
			fishes = objects.delete(account.fishes, uniqueId),
			gold = account.gold + fishes.getFishValue(fish),
		})
	end)
end

local function addReeledFish(player: Player)
	return store:updateImmutable(player, function(account)
		local fisher = fishingStore.getFisher(player.Name)

		if not fisher or not fisher.fish then
			return false
		end

		return objects.join(account, {
			fishes = objects.set(account.fishes, HttpService:GenerateGUID(false), fisher.fish),
		})
	end)
end

return {
	sellFish = sellFish,
	addReeledFish = addReeledFish,
}
