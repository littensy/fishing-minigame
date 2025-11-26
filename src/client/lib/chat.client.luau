local TextChatService = game:GetService("TextChatService")

local fishes = require("../../shared/constants/fishes")
local remotes = require("../../shared/remotes")

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

remotes.caughtFish.OnClientEvent:Connect(function(player: Player, fishId: string, success: boolean)
	local fish = fishes.byId[fishId]
	local message = if success
		then `<font color='#63d6b2'>{player.Name} caught a {fish.name}!</font>`
		else `<font color='#ed4e6b'>{player.Name} failed to catch a {fish.name}!</font>`

	displaySystemMessage(message)
end)
