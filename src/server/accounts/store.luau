local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Lyra = require("../../../modules/Lyra")
local accountStore = require("../stores/accountStore")
local schema = require("./schema")
local types = require("../../shared/types")

type Account = types.Account

local function accountChanged(key: string, account: Account)
	local player = Players:GetPlayerByUserId(tonumber(key) :: number)
	if player then
		accountStore.setAccount(player.Name, account)
	end
end

local function isAccount(value: any): (boolean, string)
	local ok, reason = schema:matches(value)
	return ok, tostring(reason)
end

return Lyra.createPlayerStore({
	name = "PlayerData",
	template = types.accountTemplate,
	schema = isAccount,
	changedCallbacks = { accountChanged } :: never,
	memoryStoreService = if RunService:IsStudio() then Lyra.MockMemoryStoreService.new() else nil,
	dataStoreService = if RunService:IsStudio() then Lyra.MockDataStoreService.new() else nil,
	useDSSLocking = nil,
	migrationSteps = nil,
	importLegacyData = nil,
	logCallback = nil,
})
