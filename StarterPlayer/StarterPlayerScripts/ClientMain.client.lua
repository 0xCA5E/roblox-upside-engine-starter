-- @ScriptType: LocalScript
-- Bootstrap Upside Engine and load the default scene.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local currentCamera = workspace.CurrentCamera

-- Upside Engine renders in 2D via ScreenGuis, so the 3D character isn't needed.
local function removeCharacter(character)
        if character then
                character:Destroy()
        end
end

if player.Character then
        removeCharacter(player.Character)
end

player.CharacterAdded:Connect(removeCharacter)

-- Lock the Roblox camera to a 2D-friendly configuration.
currentCamera.CameraType = Enum.CameraType.Scriptable
currentCamera.CameraMode = Enum.CameraMode.Classic
currentCamera.CFrame = CFrame.new()

local UpsideEngine = require(ReplicatedStorage:WaitForChild("UpsideEngine"))

-- Initialize Upside Engine runtime systems.
require(UpsideEngine.Runtime.Runner)
require(UpsideEngine.Runtime.CrossPlatformTracker)
require(UpsideEngine.Runtime.BaseTextTags)
require(UpsideEngine.Runtime.ProximityPromptInput)

-- Create an engine-managed scene and display it for the local player.
local Engine = UpsideEngine.GetService("SceneManager")

local screen = Instance.new("ScreenGui")
screen.Name = "UpsideEngine"
screen.IgnoreGuiInset = true
screen.ResetOnSpawn = false
screen.Parent = playerGui

local scene = UpsideEngine.new("Scene")
scene:SetName("DefaultScene")
scene.Instance.Parent = screen
scene:Enable()
