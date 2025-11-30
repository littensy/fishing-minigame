local HttpService = game:GetService("HttpService")

local fishes = require("../shared/fishes")
local fishingStore = require("../shared/stores/fishingStore")
local store = require("@self/store")
local types = require("../shared/types")

type Account = types.Account
type Writable<T> = types.Writable<T>

local function sellFish(player: Player, uniqueId: string)
	return store:update(player, function(account: Writable<Account>)
		local fish = account.fishes[uniqueId]

		if fish then
			account.fishes[uniqueId] = nil
			account.gold += fishes.getFishValue(fish)
			return true
		else
			return false
		end
	end)
end

local function addReeledFish(player: Player)
	return store:update(player, function(account: Writable<Account>)
		local fisher = fishingStore.getFisher(player.Name)

		if fisher and fisher.fish then
			local uniqueId = HttpService:GenerateGUID(false)
			account.fishes[uniqueId] = fisher.fish
			return true
		else
			return false
		end
	end)
end

return {
	sellFish = sellFish,
	addReeledFish = addReeledFish,
}
