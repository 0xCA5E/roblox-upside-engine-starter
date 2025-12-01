-- @ScriptType: ModuleScript
-- Provides access to sprite asset metadata.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assetsFolder = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Assets")
local spritesFolder = assetsFolder:WaitForChild("Sprites")

local AssetService = {}
AssetService.__index = AssetService

local function cloneTable(value)
        if typeof(value) ~= "table" then
                return value
        end

        local clone = {}
        for key, child in value do
                clone[key] = cloneTable(child)
        end

        return clone
end

function AssetService.GetSprite(name: string)
        local spriteModule = spritesFolder:FindFirstChild(name)

        if not spriteModule or not spriteModule:IsA("ModuleScript") then
                return nil
        end

        local metadata = require(spriteModule)
        if not metadata then
                return nil
        end

        return cloneTable(metadata)
end

return AssetService
