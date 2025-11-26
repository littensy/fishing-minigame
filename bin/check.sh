#!/bin/sh

curl -o roblox.d.luau https://luau-lsp.pages.dev/globalTypes.None.d.luau

rojo sourcemap --output sourcemap.json

# NOTE: LuauNoScopeShallNotSubsumeAll is required for the analyzer to work with
# the new solver.
echo "Running luau-lsp analyze"
luau-lsp analyze \
	--sourcemap="sourcemap.json" \
	--ignore="**/submodules/**" \
	--base-luaurc=".luaurc" \
	--definitions="roblox.d.luau" \
	--no-flags-enabled \
	--flag:"LuauSolverV2=true" \
	--flag:"LuauNoScopeShallNotSubsumeAll=true" \
	src

echo "Running selene"
selene src

echo "Running stylua"
stylua --check src

rm roblox.d.luau
