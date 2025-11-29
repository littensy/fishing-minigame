--[[
	Thin RemoteEvent and RemoteFunction wrapper for type safety.
	Use `assert` to ensure the arguments match the expected types.
]]

local RunService = game:GetService("RunService")

local gt = require("../../../modules/gt")

export type Event<Args...> = {
	FireServer: (self: Event<Args...>, Args...) -> (),
	FireClient: (self: Event<Args...>, player: Player, Args...) -> (),
	FireAllClients: (self: Event<Args...>, Args...) -> (),
	OnServerEvent: RBXScriptSignal<(Player, Args...)>,
	OnClientEvent: RBXScriptSignal<Args...>,
}

export type Callback<Args..., Results...> = {
	InvokeServer: (self: Callback<Args..., Results...>, Args...) -> Results...,
	OnServerInvoke: (player: Player, Args...) -> Results...,
}

type EventConstructor = <Args...>(Args...) -> Event<Args...>

type CallbackConstructor = <Args...>(Args...) -> {
	returns: <Results...>() -> Callback<Args..., Results...>,
}

local IS_CLIENT = RunService:IsClient()
local IS_SERVER = RunService:IsServer()
local IS_TEST = RunService:IsStudio() and not RunService:IsRunning()

local counter = 0
local schemas: { [any]: gt.Type } = {}

local event: EventConstructor
local callback: CallbackConstructor

local function nextId(): string
	counter += 1
	return `{counter}`
end

if IS_TEST then
	function event()
		return Instance.new("RemoteEvent")
	end

	function callback()
		return {
			returns = function()
				return Instance.new("RemoteFunction")
			end,
		}
	end
elseif IS_CLIENT then
	function event(...: any)
		local instance = script:WaitForChild(nextId())
		assert(instance:IsA("RemoteEvent"), `Expected RemoteEvent, got {instance.ClassName}`)
		schemas[instance] = gt.build(...)
		return instance
	end

	function callback(...: any)
		local instance = script:WaitForChild(nextId())
		assert(instance:IsA("RemoteFunction"), `Expected RemoteFunction, got {instance.ClassName}`)
		schemas[instance] = gt.build(...)
		return {
			returns = function()
				return instance
			end,
		}
	end
elseif IS_SERVER then
	function event(...: any)
		local instance = Instance.new("RemoteEvent")
		instance.Name = nextId()
		instance.Parent = script
		schemas[instance] = gt.build(...)
		return instance
	end

	function callback(...: any)
		local instance = Instance.new("RemoteFunction")
		instance.Name = nextId()
		instance.Parent = script
		schemas[instance] = gt.build(...)
		return {
			returns = function()
				return instance
			end,
		}
	end
end

local function assert<T...>(remote: Event<T...> | Callback<T..., ...any>, ...: T...): T...
	return schemas[remote]:assert(...)
end

return {
	assert = assert,
	event = event :: EventConstructor,
	callback = callback :: CallbackConstructor,
}
