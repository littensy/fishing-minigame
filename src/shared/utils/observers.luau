local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

type Cleanup = () -> ()

export type Observer<T> = {
	add: (instance: T, cleanup: Cleanup?) -> (),
	remove: (instance: T) -> (),
	clear: () -> (),
}

local function noop() end

local function createObserver<T>(setup: (Observer<T>) -> Cleanup): Cleanup
	local cleanups: { [T]: Cleanup } = {}

	local function add(instance: T, cleanup: Cleanup?)
		if cleanups[instance] then
			cleanups[instance]()
		end
		cleanups[instance] = cleanup or noop
	end

	local function remove(instance: T)
		local cleanup = cleanups[instance]
		if cleanup then
			cleanups[instance] = nil
			cleanup()
		end
	end

	local function clear()
		for instance, cleanup in cleanups do
			cleanup()
			cleanups[instance] = nil
		end
	end

	local stop = setup({
		add = add,
		remove = remove,
		clear = clear,
	})

	return function()
		stop()
		clear()
	end
end

local function observeTag<T>(tag: string, callback: (T) -> Cleanup?): Cleanup
	return createObserver(function(observer: Observer<T>)
		local instanceAdded = CollectionService:GetInstanceAddedSignal(tag):Connect(function(instance: any)
			observer.add(instance, callback(instance))
		end)

		local instanceRemoved = CollectionService:GetInstanceRemovedSignal(tag):Connect(function(instance: any)
			observer.remove(instance)
		end)

		for _, instance: any in CollectionService:GetTagged(tag) do
			observer.add(instance, callback(instance))
		end

		return function()
			instanceAdded:Disconnect()
			instanceRemoved:Disconnect()
		end
	end)
end

local function observePlayers(callback: (Player) -> Cleanup?): Cleanup
	return createObserver(function(observer)
		local playerAdded = Players.PlayerAdded:Connect(function(player)
			observer.add(player, callback(player))
		end)

		local playerRemoving = Players.PlayerRemoving:Connect(function(player)
			observer.remove(player)
		end)

		for _, player in Players:GetPlayers() do
			observer.add(player, callback(player))
		end

		return function()
			playerAdded:Disconnect()
			playerRemoving:Disconnect()
		end
	end)
end

local function observeCharacter(player: Player, callback: (Model) -> Cleanup?): Cleanup
	return createObserver(function(observer)
		local characterAdded = player.CharacterAdded:Connect(function(character)
			-- Only one character at a time
			observer.clear()
			observer.add(character, callback(character))
		end)

		local characterRemoving = player.CharacterRemoving:Connect(function(character)
			observer.remove(character)
		end)

		if player.Character then
			observer.add(player.Character, callback(player.Character))
		end

		return function()
			characterAdded:Disconnect()
			characterRemoving:Disconnect()
		end
	end)
end

return {
	createObserver = createObserver,
	observeTag = observeTag,
	observeCharacter = observeCharacter,
	observePlayers = observePlayers,
}
