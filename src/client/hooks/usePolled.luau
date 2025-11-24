local RunService = game:GetService("RunService")

local Vide = require("../../../submodules/Vide")
local useEventListener = require("./useEventListener")

local function usePolled<T>(callback: (elapsed: number, delta: number) -> T): () -> T
	local timer = 0
	local result = Vide.source(callback(0, 0))

	useEventListener(RunService.Heartbeat, function(delta)
		timer += delta
		result(callback(timer, delta))
	end)

	return result
end

return usePolled
