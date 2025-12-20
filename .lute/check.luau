local fs = require("@std/fs")
local net = require("@lute/net")
local process = require("@lute/process")

process.run({ "rojo", "sourcemap", "--output=sourcemap.json" }, { stdio = "inherit" })

fs.writestringtofile(
	"roblox.d.luau",
	net.request("https://luau-lsp.pages.dev/globalTypes.None.d.luau", { method = "GET" }).body
)

local analyze = process.run({
	"luau-lsp",
	"analyze",
	"--sourcemap=sourcemap.json",
	"--ignore=**/submodules/**",
	-- FIXME: Fix for luau-lsp analyzing files outside of the project root
	"--ignore=../../../../..",
	"--base-luaurc=.luaurc",
	"--definitions=roblox.d.luau",
	"--flag:LuauSolverV2=true",
	"src",
}, { stdio = "inherit" })

fs.remove("roblox.d.luau")

local selene = process.run({ "selene", "src" }, { stdio = "inherit" })

local stylua = process.run({ "stylua", "--check", "src" }, { stdio = "inherit" })

if not (analyze.ok and selene.ok and stylua.ok) then
	process.exit(1)
end
