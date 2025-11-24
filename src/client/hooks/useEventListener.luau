local Vide = require("../../../submodules/Vide")

local function useEventListener<T...>(event: RBXScriptSignal<T...>, callback: (T...) -> ()): ()
	Vide.cleanup(event:Connect(callback))
end

return useEventListener
