local test = require("../../tests/test")

test.describe("minigame", function()
	require("@self/minigame.test")
end)

test.describe("replay", function()
	require("@self/replay.test")
end)

test.describe("stats", function()
	require("@self/stats.test")
end)

return {}
