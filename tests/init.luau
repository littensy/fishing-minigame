local test = require("@self/test")

test.describe("shared", function()
	require("./src/shared/tests")
end)

test.finish()

return {}
