-- @ScriptType: ModuleScript
-- Creates the game's primary scene with a locked 2D camera and a gameplay layer.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UpsideEngine = require(ReplicatedStorage:WaitForChild("UpsideEngine"))
local PlayerSprite = require(ReplicatedStorage:WaitForChild("Shared")
        :WaitForChild("Entities")
        :WaitForChild("PlayerSprite"))

local MainScene = {}
MainScene.__index = MainScene

local function createGameplayLayer(scene)
        local gameplayLayer = Instance.new("Frame")
        gameplayLayer.Name = "GameplayLayer"
        gameplayLayer.BackgroundTransparency = 1
        gameplayLayer.Size = UDim2.fromScale(1, 1)
        gameplayLayer.Parent = scene.Instance:WaitForChild("GameFrame")

        return gameplayLayer
end

local function configureCamera(scene)
        local camera = scene.Camera
        local viewport = workspace.CurrentCamera.ViewportSize

        camera.FollowSubject = false
        camera.Smoothness = 0
        camera:SetPosition(UDim2.fromOffset(viewport.X / 2, viewport.Y / 2))

        return camera
end

function MainScene.Load(parent)
        local scene = UpsideEngine.new("Scene")
        scene:SetName("MainScene")
        scene.Instance.Parent = parent

        local gameplayLayer = createGameplayLayer(scene)
        local camera = configureCamera(scene)

        local playerSprite = PlayerSprite.spawn(scene, gameplayLayer)

        scene:Enable()

        return {
                Scene = scene,
                GameplayLayer = gameplayLayer,
                Camera = camera,
                PlayerSprite = playerSprite,
        }
end

MainScene.Init = MainScene.Load

return MainScene
