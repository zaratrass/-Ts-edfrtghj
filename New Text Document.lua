-- Combined Script

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variables for the ESP system
local updateInterval = 5 -- Time interval to update positions (in seconds)

-- Variables for the teleport forward
local teleportDistance = 15 -- Distance to teleport

-- Variables for teleporting up 100 studs
local heightOffset = Vector3.new(0, 100, 0)
local isTeleporting = false -- Toggle state to track if teleporting is active
local targetPosition

-- Get the local player and its character
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- ESP Functions
local function addOrUpdateLabelToPlayer(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")
    
    local billboardGui = head:FindFirstChild("PlayerLabel")
    if not billboardGui then
        billboardGui = Instance.new("BillboardGui")
        billboardGui.Size = UDim2.new(1, 0, 1, 0)
        billboardGui.Adornee = head
        billboardGui.AlwaysOnTop = true
        billboardGui.Name = "PlayerLabel"
        
        local textLabel = Instance.new("TextLabel", billboardGui)
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = player.Name
        textLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green color
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextSize = 20
        
        billboardGui.Parent = head
    end
end

local function labelAllPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            addOrUpdateLabelToPlayer(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        addOrUpdateLabelToPlayer(player)
    end)
end)

-- Teleport Forward Function
local function teleportForward()
    local lookVector = humanoidRootPart.CFrame.LookVector
    local newPosition = humanoidRootPart.Position + (lookVector * teleportDistance)
    humanoidRootPart.CFrame = CFrame.new(newPosition)
end

-- Teleport Up 100 Studs Functions
local function startTeleport()
    humanoidRootPart.Velocity = Vector3.new(0, 0, 0) -- Stop any velocity
    humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position + heightOffset) -- Teleport 100 studs up
end

local function stopTeleport()
    humanoidRootPart.Velocity = Vector3.new(0, 0, 0) -- Stop any velocity, but let gravity act naturally after
end

-- Key Press Handler
local function onKeyPress(input, gameProcessed)
    if gameProcessed then return end
    
    -- Check if Left Alt is pressed for teleport forward
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        teleportForward()
    end
    
    -- Check if Right Alt is pressed for teleport up 100 studs
    if input.KeyCode == Enum.KeyCode.RightAlt then
        isTeleporting = not isTeleporting
        if isTeleporting then
            startTeleport()
            targetPosition = humanoidRootPart.Position + heightOffset
            print("Teleporting 100 studs up.")
        else
            stopTeleport()
            print("Teleport stopped.")
        end
    end
end

-- Continuously keep the player 100 studs up if teleporting
RunService.RenderStepped:Connect(function()
    if isTeleporting then
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0) -- Stop any velocity
        humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, targetPosition.Y, humanoidRootPart.Position.Z) -- Keep the player 100 studs up
    end
end)

-- Bind key press events
UserInputService.InputBegan:Connect(onKeyPress)

-- Periodically update ESP labels for all players every 5 seconds
while true do
    labelAllPlayers()
    wait(updateInterval)
end
