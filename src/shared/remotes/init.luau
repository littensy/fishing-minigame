local gt = require("../../submodules/gt")
local lib = require("@self/lib")

return {
	assert = lib.assert,
	patch = lib.event(gt.array(gt.anyTable())),
	shakeRod = lib.event(),
	castRod = lib.event(gt.number({ range = { min = 0, max = 100 } })),
	catchFish = lib.event(gt.buffer()),
	caughtFish = lib.event(gt.isA.Player(), gt.string(), gt.boolean()),
}
