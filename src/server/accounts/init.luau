local HttpService = game:GetService("HttpService")

local fishes = require("../shared/fishes")
local objects = require("../shared/utils/objects")
local store = require("@self/store")
local types = require("../shared/types")

type Fish = fishes.Fish
type Account = types.Account

local function sellFish(player: Player, guid: string)
	return store:updateImmutable(player, function(account: Account)
		local fish = account.fishes[guid]

		if not fish then
			return false
		end

		return objects.join(account, {
			fishes = objects.delete(account.fishes, guid),
			gold = account.gold + fishes.getFishValue(fish),
		})
	end)
end

local function addFish(player: Player, fish: Fish)
	return store:updateImmutable(player, function(account: Account)
		return objects.join(account, {
			fishes = objects.set(account.fishes, HttpService:GenerateGUID(false), fish),
		})
	end)
end

return {
	sellFish = sellFish,
	addFish = addFish,
}
