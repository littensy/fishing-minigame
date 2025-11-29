local Charm = require("../../../modules/Charm")
local objects = require("../../shared/utils/objects")
local types = require("../../shared/types")

export type Account = types.Account

local state, setState = Charm.reactive({
	accounts = {} :: { [string]: Account },
})

local function getAccounts()
	return state.accounts
end

local function getAccount(username: string): Account?
	return state.accounts[username]
end

local function addAccount(username: string, account: Account)
	state.accounts[username] = account
end

local function reconcileAccount(username: string, source: Account)
	setState(function(state)
		local target = state.accounts[username]
		if target then
			objects.reconcile(target, source)
		else
			state.accounts[username] = table.clone(source)
		end
	end)
end

local function removeAccount(username: string)
	state.accounts[username] = nil
end

return {
	state = state,
	getAccounts = getAccounts,
	getAccount = getAccount,
	addAccount = addAccount,
	reconcileAccount = reconcileAccount,
	removeAccount = removeAccount,
}
