local fishes = require("./fishes")

type Fish = fishes.Fish

export type Account = {
	gold: number,
	fishes: { [string]: Fish },
}

local accountTemplate: Account = {
	gold = 0,
	fishes = {},
}

return {
	accountTemplate = accountTemplate,
}
