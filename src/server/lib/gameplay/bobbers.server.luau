local Players = game:GetService("Players")

local Charm = require("../../../../submodules/Charm")
local bobberStore = require("../../stores/bobberStore")
local fishingStore = require("../../../shared/stores/fishingStore")

type BobberInstance = Model & {
	Part: Part & {
		Attachment: Attachment,
	},
	AlignOrientation: AlignOrientation,
}

local bobberContainer = Instance.new("Folder")
bobberContainer.Name = "Bobbers"
bobberContainer.Parent = workspace

local function shootBobberFromCharacter(bobber: BobberInstance, character: Model, power: number)
	local direction = character:GetPivot() * CFrame.Angles(math.rad(60), 0, 0)
	local velocity = math.lerp(10, 50, power)

	bobber.Parent = bobberContainer
	bobber.Part.AssemblyLinearVelocity = direction.LookVector * velocity
	bobber.Part:SetNetworkOwner(Players:GetPlayerFromCharacter(character))
end

local function createBobber(props: bobberStore.BobberEntry): BobberInstance
	local bobber = Instance.new("Model")
	bobber.Name = "Bobber"

	local part = Instance.new("Part")
	part.Shape = Enum.PartType.Ball
	part.Size = Vector3.new(0.5, 0.5, 0.5)
	part.CFrame = props.character:GetPivot() * CFrame.new(0, 0, -2)
	part.CustomPhysicalProperties = PhysicalProperties.new(1, 1, 0, 1, 1)
	part.Parent = bobber

	local attachment = Instance.new("Attachment")
	attachment.Name = "BobberAttachment"
	attachment.Parent = part

	local alignOrientation = Instance.new("AlignOrientation")
	alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	alignOrientation.Attachment0 = attachment
	alignOrientation.CFrame = props.character:GetPivot()
	alignOrientation.RigidityEnabled = true
	alignOrientation.Parent = part

	return bobber :: BobberInstance
end

Charm.observe(bobberStore.getBobbers, function(props, username)
	local getSubmerged, setSubmerged = Charm.signal(false)
	local bobber = createBobber(props)

	shootBobberFromCharacter(bobber, props.character, props.power)

	bobber.Part.Touched:Connect(function(touching)
		if touching:HasTag("Water") and not getSubmerged() then
			setSubmerged(true)
			fishingStore.setFishing(username, {
				seed = tick(),
				rodId = props.rodId,
			})
		end
	end)

	Charm.effect(function()
		bobber.Part.Anchored = getSubmerged()
	end)

	return function()
		bobber:Destroy()
	end
end)

-- Remove bobbers when players catch a fish or snap the line
Charm.observe(fishingStore.getCatchingFishers, function(_, username)
	return function()
		bobberStore.removeBobber(username)
	end
end)
