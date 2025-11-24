#!/bin/sh

curl -o roblox.d.luau https://luau-lsp.pages.dev/globalTypes.None.d.luau

rojo sourcemap --output sourcemap.json

luau-lsp analyze --sourcemap="sourcemap.json" --ignore="**/submodules/**" --base-luaurc=".luaurc" --definitions="roblox.d.luau" src
selene src
stylua --check src

rm roblox.d.luau
