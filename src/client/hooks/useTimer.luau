local RunService = game:GetService("RunService")

local Vide = require("../../../modules/Vide")
local useEventListener = require("./useEventListener")

type Timer = {
	time: () -> number,
	start: () -> (),
	stop: () -> (),
	reset: () -> (),
}

local function useTimer(): Timer
	local currentTime = Vide.source(0)
	local isRunning = Vide.source(false)

	Vide.effect(function()
		if isRunning() then
			useEventListener(RunService.Heartbeat, function(delta: number)
				currentTime(currentTime() + delta)
			end)
		end
	end)

	local function start()
		isRunning(true)
	end

	local function stop()
		isRunning(false)
	end

	local function reset()
		currentTime(0)
	end

	return {
		time = currentTime,
		start = start,
		stop = stop,
		reset = reset,
	}
end

return useTimer
