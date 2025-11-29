local Vide = require("../../../modules/Vide")

type function GetSignalListener(signal: type)
	local connect = signal:readproperty(types.singleton("Connect"))
	assert(connect, "signal must have Connect method")
	local parameters = connect:parameters()
	assert(parameters.head, "Connect must have parameters")
	return parameters.head[2]
end

local function useEventListener<T>(event: T & RBXScriptSignal, callback: GetSignalListener<T>): ()
	Vide.cleanup(event:Connect(callback))
end

return useEventListener
