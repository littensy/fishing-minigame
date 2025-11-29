local fishes = require("../../shared/fishes")
local gt = require("../../../modules/gt")
local types = require("../../shared/types")

type Fish = fishes.Fish
type Account = types.Account

local fishSchema: Fish = gt.table({
	fishId = gt.string(),
	weightMultiplier = gt.number(),
	mutations = { [gt.string()] = gt.boolean() },
})

local accountSchema: Account = gt.table({
	gold = gt.number(),
	fishes = { [gt.string()] = fishSchema },
})

return gt.build(accountSchema)
