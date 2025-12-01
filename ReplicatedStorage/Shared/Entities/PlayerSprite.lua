-- @ScriptType: ModuleScript
-- Creates a simple player sprite backed by Upside Engine.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UpsideEngine = require(ReplicatedStorage:WaitForChild("UpsideEngine"))
local CrossPlatformService = require(ReplicatedStorage:WaitForChild("UpsideEngine")
        :WaitForChild("Services")).CrossPlatformService
local AssetService = require(ReplicatedStorage:WaitForChild("Shared")
        :WaitForChild("Services")
        :WaitForChild("AssetService"))

local PlayerSprite = {}
PlayerSprite.__index = PlayerSprite

local DEFAULT_SPRITE_NAME = "SampleSprite"
local DEFAULT_ANIMATION_NAME = "Idle"
local KEYBOARD_CONTROLS = {
        W = "MoveUp",
        A = "MoveLeft",
        S = "MoveDown",
        D = "MoveRight",
        Up = "MoveUp",
        Left = "MoveLeft",
        Down = "MoveDown",
        Right = "MoveRight",
        Space = "Jump",
}
local SUPPORTED_ACTIONS = {
        MoveUp = true,
        MoveDown = true,
        MoveLeft = true,
        MoveRight = true,
        Jump = true,
}

local function configureInputBindings()
        CrossPlatformService.DefaultControllersEnabled = false
        CrossPlatformService:SetDeviceConfig("Keyboard", KEYBOARD_CONTROLS)
end

local function handleInputState(sprite, input, isActive)
        local action = input.Action
        if not SUPPORTED_ACTIONS[action] then
                return
        end

        sprite._inputState[action] = isActive
        if action == "Jump" then
                sprite._pendingJump = isActive
        end
end

local function connectInputs(sprite)
        local onBegin = CrossPlatformService:On("InputBegin", function(input)
                handleInputState(sprite, input, true)
        end)

        local onEnd = CrossPlatformService:On("InputEnd", function(input)
                handleInputState(sprite, input, false)
        end)

        sprite:On("Destroy", function()
                onBegin:Disconnect()
                onEnd:Disconnect()
        end)
end

local function applySpriteMetadata(sprite, metadata)
        sprite.Instance.Size = UDim2.fromOffset(metadata.Size.X, metadata.Size.Y)
        sprite:SetSpriteSheet(DEFAULT_ANIMATION_NAME, metadata.ImageId, metadata.Frames or Vector2.new(1, 1))
        sprite:Play(DEFAULT_ANIMATION_NAME)
end

local function clampToGround(sprite, velocity)
        local instance = sprite.Instance
        local parent = instance.Parent

        if not parent then
                return velocity
        end

        local bottom = instance.AbsolutePosition.Y + instance.AbsoluteSize.Y
        local floor = parent.AbsolutePosition.Y + parent.AbsoluteSize.Y

        if bottom <= floor then
                sprite.IsGrounded = false
                return velocity
        end

        local correction = bottom - floor
        instance.Position -= UDim2.fromOffset(0, correction)

        sprite.IsGrounded = true
        return Vector2.new(velocity.X, 0)
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

        sprite.Velocity = Vector2.zero
        sprite.Gravity = Vector2.new(0, 900)
        sprite.MoveSpeed = 250
        sprite.JumpVelocity = 350
        sprite._inputState = {
                MoveUp = false,
                MoveDown = false,
                MoveLeft = false,
                MoveRight = false,
                Jump = false,
        }
        sprite._pendingJump = false

        applySpriteMetadata(sprite, metadata)

        configureInputBindings()
        connectInputs(sprite)

        sprite:SetScene(scene)
        sprite.Instance.Parent = parent or sprite.Instance.Parent

        return sprite
end

function PlayerSprite:Update(deltaTime)
        local inputVector = Vector2.zero
        if self._inputState.MoveLeft then
                inputVector += Vector2.new(-1, 0)
        end
        if self._inputState.MoveRight then
                inputVector += Vector2.new(1, 0)
        end
        if self._inputState.MoveUp then
                inputVector += Vector2.new(0, -1)
        end
        if self._inputState.MoveDown then
                inputVector += Vector2.new(0, 1)
        end

        if inputVector ~= Vector2.zero then
                inputVector = inputVector.Unit
        end

        local velocity = self.Velocity
        local movement = inputVector * self.MoveSpeed
        velocity = Vector2.new(movement.X, velocity.Y)

        if inputVector.Y ~= 0 then
                velocity = Vector2.new(velocity.X, movement.Y)
        end

        if self._pendingJump and self.IsGrounded then
                velocity = Vector2.new(velocity.X, -self.JumpVelocity)
                self._pendingJump = false
                self.IsGrounded = false
        end

        velocity += self.Gravity * deltaTime

        local displacement = velocity * deltaTime
        self.Instance.Position += UDim2.fromOffset(displacement.X, displacement.Y)

        velocity = clampToGround(self, velocity)
        self.Velocity = velocity
end

return PlayerSprite
