-- @ScriptType: LocalScript
-- Bootstrap Upside Engine and load the default scene.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local currentCamera = Workspace.CurrentCamera

-- Ensure the player character is not automatically spawned when entering the 2D experience.
Players.CharacterAutoLoads = false

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

-- Lock the Roblox camera to a 2D-friendly configuration and guard against overrides.
local function lockCamera(camera)
  local desiredType = Enum.CameraType.Scriptable
  local desiredMode = Enum.CameraMode.Classic

  local function apply()
    if camera.CameraType ~= desiredType then
      camera.CameraType = desiredType
    end

    if player.CameraMode ~= desiredMode then
      player.CameraMode = desiredMode
    end

    if camera.CFrame ~= CFrame.new() then
      camera.CFrame = CFrame.new()
    end
  end

  apply()

  camera:GetPropertyChangedSignal("CameraType"):Connect(function()
    if camera.CameraType ~= desiredType then
      camera.CameraType = desiredType
    end
  end)

  player:GetPropertyChangedSignal("CameraMode"):Connect(function()
    if player.CameraMode ~= desiredMode then
      player.CameraMode = desiredMode
    end
  end)
end

lockCamera(currentCamera)

local UpsideEngine = require(ReplicatedStorage:WaitForChild("UpsideEngine")
  :WaitForChild("UpsideEngine"))
local MainScene = require(ReplicatedStorage:WaitForChild("Shared")
  :WaitForChild("Scenes")
  :WaitForChild("MainScene"))
local DebugOverlay = require(script.Parent:WaitForChild("DebugOverlay"))

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

local sceneInfo = MainScene.Load(screen)
local scene = sceneInfo.Scene

local overlay = DebugOverlay.new(screen)
overlay:SetPlayerSprite(sceneInfo.PlayerSprite)
