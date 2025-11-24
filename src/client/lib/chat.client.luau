local TextChatService = game:GetService("TextChatService")

local fishes = require("../../shared/constants/fishes")
local remotes = require("../../shared/remotes")

local CATCH_SUCCESS_MESSAGE = "<font color='#63d6b2'>%s caught a %s!</font>"
local CATCH_FAILURE_MESSAGE = "<font color='#ed4e6b'>%s failed to catch a %s</font>"

local function getChannel(name: string): TextChannel?
	local textChannels = TextChatService:FindFirstChild("TextChannels")
	return textChannels and textChannels:FindFirstChild(name) :: TextChannel?
end

remotes.caughtFish.OnClientEvent:Connect(function(player: Player, fishId: string, success: boolean)
	local fish = fishes.byId[fishId]
	local channel = getChannel("RBXSystem")
	local message = if success
		then string.format(CATCH_SUCCESS_MESSAGE, player.DisplayName, fish.name)
		else string.format(CATCH_FAILURE_MESSAGE, player.DisplayName, fish.name)

	if channel then
		channel:DisplaySystemMessage(message)
	end
end)
