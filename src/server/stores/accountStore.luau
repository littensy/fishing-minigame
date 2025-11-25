local Charm = require("../../../submodules/Charm")
local types = require("../../shared/types")

export type Account = types.Account

local state = Charm.reactive({
	accounts = {} :: { [string]: Account },
})

local function getAccounts()
	return state.accounts
end

local function getAccount(username: string): Account?
	return state.accounts[username]
end

local function selectAccount(username: string)
	return function()
		return state.accounts[username]
	end
end

local function setAccount(username: string, account: Account)
	state.accounts[username] = account
end

return {
	state = state,
	getAccounts = getAccounts,
	getAccount = getAccount,
	selectAccount = selectAccount,
	setAccount = setAccount,
}
