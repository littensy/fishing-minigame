local Vide = require(script.Parent.submodules.Vide)

export type Source<T> = Vide.Source<T>
export type Context<T> = Vide.Context<T>

-- TODO: Remove custom types when Vide updates with these types included

type Instances = {
	Folder: Folder,
	BillboardGui: BillboardGui,
	CanvasGroup: CanvasGroup,
	Frame: Frame,
	ImageButton: ImageButton,
	ImageLabel: ImageLabel,
	ScreenGui: ScreenGui,
	ScrollingFrame: ScrollingFrame,
	SurfaceGui: SurfaceGui,
	TextBox: TextBox,
	TextButton: TextButton,
	TextLabel: TextLabel,
	UIAspectRatioConstraint: UIAspectRatioConstraint,
	UICorner: UICorner,
	UIGradient: UIGradient,
	UIGridLayout: UIGridLayout,
	UIListLayout: UIListLayout,
}

type function Properties(instance: type?)
	local properties = types.newtable()

	while instance do
		for i, v in instance:properties() do
			local connector = v.read and v.read.tag == "table" and v.read:readproperty(types.singleton("Connect"))
			if connector then
				if not connector then
					continue
				end
				local params = connector:parameters().head
				if not params then
					continue
				end
				local listener = params[2]
				if not listener then
					continue
				end
				properties:setproperty(i, types.optional(listener))
			elseif v.write then
				properties:setproperty(
					i,
					types.optional(types.unionof(v.write, types.newfunction({}, { head = { v.write } })))
				)
			end
		end

		instance = instance:readparent()
	end

	properties:setindexer(types.number, types.any)

	return properties
end

type AnyInstance = Instance

type AnyProps = { [any]: any }

type function CreateResult(name: type, props: type)
	local instance = Instances:readproperty(name)
	if props and props:is("table") then
		return instance or AnyInstance
	elseif instance then
		return types.newfunction({ head = { Properties(instance) } }, { head = { instance } })
	else
		return types.newfunction({ head = { AnyProps } }, { head = { AnyInstance } })
	end
end

type Create = <Name, Props>(
	Name | keyof<Instances>,
	...(Props & Properties<index<Instances, Name>>)
) -> CreateResult<Name, Props>

local create = Vide.create :: Create

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
