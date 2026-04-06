type Attribute<T> = {
	name: string,
	get: (instance: Instance) -> T,
	set: (instance: Instance, value: T) -> (),
}

local function attribute<T>(name: string, defaultValue: T?): Attribute<T>
	local function getAttribute(instance: Instance): T
		local value = instance:GetAttribute(name)
		return if value ~= nil then value else defaultValue
	end

	local function setAttribute(instance: Instance, value: T)
		instance:SetAttribute(name, value)
	end

	return {
		name = name,
		get = getAttribute,
		set = setAttribute,
	}
end

return attribute
