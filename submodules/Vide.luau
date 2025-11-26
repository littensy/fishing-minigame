local Vide = require(script.Parent.vendor.Vide)

export type Source<T> = Vide.Source<T>
export type Context<T> = Vide.Context<T>

-- FIXME: Remove when Luau issue #1853 or #2073 is resolved
local create: (class: string, props: { [any]: any }) -> any = (Vide :: any).create

return setmetatable({
	version = Vide.version,
	root = Vide.root,
	mount = Vide.mount,
	create = create,
	source = Vide.source,
	effect = Vide.effect,
	derive = Vide.derive,
	switch = Vide.switch,
	show = Vide.show,
	indexes = Vide.indexes,
	values = Vide.values,
	cleanup = Vide.cleanup,
	untrack = Vide.untrack,
	read = Vide.read,
	batch = Vide.batch,
	context = Vide.context,
	spring = Vide.spring,
	action = Vide.action,
	changed = Vide.changed,
	strict = Vide.strict,
	defaults = Vide.defaults,
	defer_nested_properties = Vide.defer_nested_properties,
	apply = Vide.apply,
	step = Vide.step,
}, getmetatable(Vide))
