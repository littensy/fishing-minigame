local RunService = game:GetService("RunService")

local useEventListener = require("./useEventListener")

local function useInterval(callback: () -> (), interval: number)
	local timer = os.clock()

	useEventListener(RunService.Heartbeat, function()
		local now = os.clock()
		if now >= timer then
			timer += interval
			callback()
		end
	end)
end

return useInterval
