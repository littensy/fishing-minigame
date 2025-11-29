local Vide = require("../../../modules/Vide")

type SpringSettings<T> = ({
	position: T?,
	velocity: T?,
	impulse: T?,
}) -> ()

local function useSpringFrom<T>(
	input: () -> T,
	initialValue: T,
	period: number?,
	dampingRatio: number?
): (() -> T, SpringSettings<T>)
	local initialized = Vide.source(false)

	Vide.cleanup(task.defer(function()
		initialized(true)
	end))

	return Vide.spring(function()
		return if initialized() then input() else initialValue
	end, period, dampingRatio)
end

return useSpringFrom
