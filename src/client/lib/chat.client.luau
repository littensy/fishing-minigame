local TextChatService = game:GetService("TextChatService")

local fishes = require("../../shared/fishes")
local remotes = require("../../shared/remotes")

type Fish = fishes.Fish

local function getChannel(name: string): TextChannel?
	local textChannels = TextChatService:FindFirstChild("TextChannels")
	return textChannels and textChannels:FindFirstChild(name) :: TextChannel?
end

local function displaySystemMessage(message: string)
	local channel = getChannel("RBXSystem")
	if channel then
		channel:DisplaySystemMessage(message)
	end
end

remotes.caughtFish.OnClientEvent:Connect(function(player: Player, fish: Fish, success: boolean)
	local text = fishes.stringifyFish(fish)
	local weight = string.format("%.2f lbs", fishes.getFishWeight(fish))
	local message = if success
		then `<font color='#63d6b2'>{player.DisplayName} caught a {weight} {text}!</font>`
		else `<font color='#ed4e6b'>{player.DisplayName} failed to catch a {weight} {text}!</font>`

	displaySystemMessage(message)
end)
