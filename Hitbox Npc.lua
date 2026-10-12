-- NPC Hitbox v5 Adaptive FINAL

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local enabled = false
local hitboxSize = 6

local originals = {}

local priorityParts = {
	"Head",
	"HumanoidRootPart",
	"UpperTorso",
	"Torso"
}

-- NPC check

local function isNPC(model)

	if Players:GetPlayerFromCharacter(model) then
		return false
	end

	if model:FindFirstChildOfClass("Humanoid") then
		return true
	end

	if model:FindFirstChild("AnimationController") then
		return true
	end

	return false

end

-- store original

local function store(part)

	if not originals[part] then
		originals[part] = part.Size
	end

end

-- expand part

local function expand(part)

	store(part)

	part.Size = Vector3.new(hitboxSize,hitboxSize,hitboxSize)
	part.Transparency = 0.35
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(255,70,70)
	part.CanCollide = false

end

-- adaptive expand

local function expandNPC(model)

	local found = false

	for _,name in ipairs(priorityParts) do

		local part = model:FindFirstChild(name)

		if part and part:IsA("BasePart") then
			expand(part)
			found = true
		end

	end

	if model.PrimaryPart then
		expand(model.PrimaryPart)
		found = true
	end

	if not found then

		for _,v in pairs(model:GetDescendants()) do
			if v:IsA("BasePart") then
				expand(v)
			end
		end

	end

end

-- restore

local function restoreNPC(model)

	for _,v in pairs(model:GetDescendants()) do

		if v:IsA("BasePart") and originals[v] then

			v.Size = originals[v]
			v.Transparency = 0
			v.Material = Enum.Material.Plastic

			originals[v] = nil

		end

	end

end

-- apply

local function applyAll()

	for _,v in pairs(workspace:GetDescendants()) do

		if v:IsA("Model") and isNPC(v) then
			expandNPC(v)
		end

	end

end

local function removeAll()

	for _,v in pairs(workspace:GetDescendants()) do

		if v:IsA("Model") and isNPC(v) then
			restoreNPC(v)
		end

	end

end

workspace.DescendantAdded:Connect(function(obj)

	if not enabled then return end

	if obj:IsA("Model") and isNPC(obj) then

		task.wait(0.2)
		expandNPC(obj)

	end

end)

-- GUI

local gui = Instance.new("ScreenGui")
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,180,0,120)
frame.Position = UDim2.new(0,50,0,160)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-60,0,28)
title.Position = UDim2.new(0,10,0,0)
title.Text = "NPC Hitbox v5"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- close

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,22,0,22)
close.Position = UDim2.new(1,-26,0,4)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,60,60)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.Parent = frame

Instance.new("UICorner",close)

-- minimize

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,22,0,22)
minimize.Position = UDim2.new(1,-52,0,4)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(80,80,80)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Parent = frame

Instance.new("UICorner",minimize)

-- size label

local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(1,0,0,20)
sizeLabel.Position = UDim2.new(0,0,0,32)
sizeLabel.Text = "Size "..hitboxSize
sizeLabel.BackgroundTransparency = 1
sizeLabel.TextColor3 = Color3.new(1,1,1)
sizeLabel.Font = Enum.Font.Gotham
sizeLabel.TextSize = 13
sizeLabel.Parent = frame

-- minus

local minus = Instance.new("TextButton")
minus.Size = UDim2.new(0,36,0,28)
minus.Position = UDim2.new(0,20,0,55)
minus.Text = "-"
minus.BackgroundColor3 = Color3.fromRGB(70,70,70)
minus.TextColor3 = Color3.new(1,1,1)
minus.Font = Enum.Font.GothamBold
minus.Parent = frame

Instance.new("UICorner",minus)

-- plus

local plus = Instance.new("TextButton")
plus.Size = UDim2.new(0,36,0,28)
plus.Position = UDim2.new(0,124,0,55)
plus.Text = "+"
plus.BackgroundColor3 = Color3.fromRGB(70,70,70)
plus.TextColor3 = Color3.new(1,1,1)
plus.Font = Enum.Font.GothamBold
plus.Parent = frame

Instance.new("UICorner",plus)

-- toggle

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,130,0,28)
toggle.Position = UDim2.new(0,25,0,85)
toggle.Text = "Enable"
toggle.BackgroundColor3 = Color3.fromRGB(180,60,60)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame

Instance.new("UICorner",toggle)

-- open button

local open = Instance.new("TextButton")
open.Size = UDim2.new(0,120,0,32)
open.Position = frame.Position
open.Visible = false
open.Text = "Open Hitbox"
open.BackgroundColor3 = Color3.fromRGB(30,30,30)
open.TextColor3 = Color3.new(1,1,1)
open.Font = Enum.Font.GothamBold
open.TextSize = 14
open.Parent = gui

Instance.new("UICorner",open)

-- logic

toggle.MouseButton1Click:Connect(function()

	enabled = not enabled

	if enabled then
		applyAll()
		toggle.Text = "Disable"
		toggle.BackgroundColor3 = Color3.fromRGB(60,180,90)
	else
		removeAll()
		toggle.Text = "Enable"
		toggle.BackgroundColor3 = Color3.fromRGB(180,60,60)
	end

end)

plus.MouseButton1Click:Connect(function()

	if hitboxSize < 25 then
		hitboxSize += 1
	end

	sizeLabel.Text = "Size "..hitboxSize

	if enabled then
		applyAll()
	end

end)

minus.MouseButton1Click:Connect(function()

	if hitboxSize > 3 then
		hitboxSize -= 1
	end

	sizeLabel.Text = "Size "..hitboxSize

	if enabled then
		applyAll()
	end

end)

minimize.MouseButton1Click:Connect(function()

	frame.Visible = false
	open.Visible = true

end)

open.MouseButton1Click:Connect(function()

	frame.Visible = true
	open.Visible = false

end)

close.MouseButton1Click:Connect(function()

	removeAll()
	gui:Destroy()

end)

-- drag system

local function draggable(obj)

	local dragging
	local dragStart
	local startPos

	obj.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

			dragging = true
			dragStart = input.Position
			startPos = obj.Position

		end

	end)

	obj.InputEnded:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end

	end)

	UserInputService.InputChanged:Connect(function(input)

		if dragging and (input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseMovement) then

			local delta = input.Position - dragStart

			obj.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)

		end

	end)

end

draggable(frame)
draggable(open)
