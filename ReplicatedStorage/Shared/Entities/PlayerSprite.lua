-- @ScriptType: ModuleScript
-- Creates a simple player sprite backed by Upside Engine.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UpsideEngine = require(ReplicatedStorage:WaitForChild("UpsideEngine"))
local AssetService = require(ReplicatedStorage:WaitForChild("Shared")
        :WaitForChild("Services")
        :WaitForChild("AssetService"))

local PlayerSprite = {}
PlayerSprite.__index = PlayerSprite

local DEFAULT_SPRITE_NAME = "SampleSprite"
local DEFAULT_ANIMATION_NAME = "Idle"

local function applySpriteMetadata(sprite, metadata)
        sprite.Instance.Size = UDim2.fromOffset(metadata.Size.X, metadata.Size.Y)
        sprite:SetSpriteSheet(DEFAULT_ANIMATION_NAME, metadata.ImageId, metadata.Frames or Vector2.new(1, 1))
        sprite:Play(DEFAULT_ANIMATION_NAME)
end

function PlayerSprite.spawn(scene, parent)
        local metadata = AssetService.GetSprite(DEFAULT_SPRITE_NAME)
        if not metadata then
                warn(string.format("Sprite metadata '%s' not found", DEFAULT_SPRITE_NAME))
                return nil
        end

        local sprite = UpsideEngine.new("Sprite")
        sprite.Instance.Name = "PlayerSprite"
        sprite.Instance.AnchorPoint = Vector2.new(0.5, 0.5)
        sprite.Instance.Position = UDim2.fromScale(0.5, 0.5)

        applySpriteMetadata(sprite, metadata)

        sprite:SetScene(scene)
        sprite.Instance.Parent = parent or sprite.Instance.Parent

        return sprite
end

return PlayerSprite
