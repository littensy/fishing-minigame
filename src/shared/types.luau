local gt = require("../../submodules/gt")

local fishItemSchema = gt.table({
	id = gt.string(),
	weightMultiplier = gt.number(),
	mutation = gt.optional(gt.string()),
})

export type FishItem = typeof(fishItemSchema)

local accountSchema = gt.table({
	gold = gt.number(),
	fishes = gt.array(fishItemSchema),
})

export type Account = typeof(accountSchema)

local accountTemplate: Account = {
	gold = 0,
	fishes = {},
}

return {
	fishItemSchema = fishItemSchema,
	accountSchema = accountSchema,
	accountTemplate = accountTemplate,
}
