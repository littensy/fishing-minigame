local fs = require("@std/fs")
local json = require("@std/json")
local net = require("@lute/net")
local process = require("@lute/process")

local CURRENT_FFLAGS = "https://clientsettingscdn.roblox.com/v1/settings/application?applicationName=PCStudioApp"
local FFLAG_KINDS = { "FFlag", "FInt" }

local function analyze()
	local args = {
		"luau-lsp",
		"analyze",
		"--sourcemap=sourcemap.json",
		"--ignore=**/submodules/**",
		-- FIXME: Temporary workaround for luau-lsp analyzing non-existent
		-- files outside of the project root
		"--ignore=../../../../..",
		"--base-luaurc=.luaurc",
		"--definitions=roblox.d.luau",
		"--no-flags-enabled",
		"--flag:LuauSolverV2=true",
	}

	local response = net.request(CURRENT_FFLAGS, { method = "GET" })
	local data: any = json.deserialize(response.body)

	for name, value in data.applicationSettings do
		if type(name) ~= "string" then
			continue
		end

		for _, kind in FFLAG_KINDS do
			if string.find(name, `^{kind}Luau`) then
				table.insert(args, `--flag:{string.sub(name, #kind + 1)}={value}`)
			end
		end
	end

	table.insert(args, "src")

	fs.writestringtofile(
		"roblox.d.luau",
		net.request("https://luau-lsp.pages.dev/globalTypes.None.d.luau", { method = "GET" }).body
	)

	local result = process.run(args)
	local stderr = string.gsub(result.stderr, "Unknown FFlag[^\n]+\n", "")

	fs.remove("roblox.d.luau")

	print(stderr)

	if result.exitcode == 1 then
		process.exit(1)
	end
end

process.run({ "rojo", "sourcemap", "--output=sourcemap.json" }, { stdio = "inherit" })

analyze()

process.run({ "selene", "src" }, { stdio = "inherit" })

process.run({ "stylua", "--check", "src" }, { stdio = "inherit" })
