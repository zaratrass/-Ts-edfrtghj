-- Script 1: ESP - Label each player with a green tag above their head and update location every 5 seconds
local Players = game:GetService("Players")
local updateInterval = 5 -- Time interval to update positions (in seconds)

-- Function to add or update a label to a player
local function addOrUpdateLabelToPlayer(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")
    
    -- Check if the player already has a label
    local billboardGui = head:FindFirstChild("PlayerLabel")
    if not billboardGui then
        -- Create the BillboardGui if it doesn't exist
        billboardGui = Instance.new("BillboardGui")
        billboardGui.Size = UDim2.new(1, 0, 1, 0)
        billboardGui.Adornee = head
        billboardGui.AlwaysOnTop = true
        billboardGui.Name = "PlayerLabel"
        
        -- Create the text label
        local textLabel = Instance.new("TextLabel", billboardGui)
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = player.Name
        textLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green color
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextSize = 20
        
        -- Parent the BillboardGui to the player's head
        billboardGui.Parent = head
    end
end

-- Function to label all players that are already in the game
local function labelAllPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            addOrUpdateLabelToPlayer(player)
        end
    end
end

-- Add label when a new player joins
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        addOrUpdateLabelToPlayer(player)
    end)
end)

-- Periodically update labels for all players every 5 seconds
while true do
    labelAllPlayers()
    wait(updateInterval) -- Wait 5 seconds before the next update
end


-- Script 2: Teleport 15 studs forward when leftalt is pressed
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local teleportDistance = 15 -- Distance to teleport

-- Function to teleport 15 studs forward
local function teleportForward()
    local lookVector = humanoidRootPart.CFrame.LookVector
    local newPosition = humanoidRootPart.Position + (lookVector * teleportDistance)
    humanoidRootPart.CFrame = CFrame.new(newPosition)
end

-- Detect when Q is pressed
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- Ignore if it's already processed
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        teleportForward()
    end
end)


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local userInputService = game:GetService("UserInputService")

-- Variables to store the original position and target position
local heightOffset = Vector3.new(0, 100, 0)
local targetPosition = humanoidRootPart.Position + heightOffset
local isTeleporting = false -- Toggle state to track if teleporting is active

-- Function to teleport the player up 100 studs and keep them there
local function startTeleport()
    humanoidRootPart.Velocity = Vector3.new(0, 0, 0) -- Stop any velocity
    humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position + heightOffset) -- Teleport 100 studs up
end

-- Function to stop keeping the player in place, allowing them to fall
local function stopTeleport()
    humanoidRootPart.Velocity = Vector3.new(0, 0, 0) -- Stop any velocity, but let gravity act naturally after
end

-- Toggles teleportation when Left Alt is pressed
local function onKeyPress(input)
    if input.KeyCode == Enum.KeyCode.RightAlt then
        isTeleporting = not isTeleporting -- Toggle the teleporting state
        if isTeleporting then
            startTeleport()
            print("Teleporting 100 studs up.")
        else
            stopTeleport()
            print("Teleport stopped.")
        end
    end
end

-- Continuously keep the player in place if teleporting
game:GetService("RunService").RenderStepped:Connect(function()
    if isTeleporting then
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0) -- Stop any velocity
        humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, targetPosition.Y, humanoidRootPart.Position.Z) -- Keep the player 100 studs up
    end
end)

-- Detect Left Alt press to toggle teleportation
userInputService.InputBegan:Connect(onKeyPress)

