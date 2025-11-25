local gt = require("../../submodules/gt")

export type Account = {
	gold: number,
}

local accountSchema = gt.build(gt.table({
	gold = gt.number(),
}))

local accountTemplate: Account = {
	gold = 0,
}

return {
	accountSchema = accountSchema,
	accountTemplate = accountTemplate,
}
