--[[
	Reparent the server's files to a non-replicated instance to prevent clients 
	from accessing server-only scripts.
]]

local destination = Instance.new("Camera")
local source: Instance = script

destination.Name = source.Name
destination.Parent = source.Parent

for _, child in source:GetChildren() do
	child.Parent = destination
end

source.Parent = nil
