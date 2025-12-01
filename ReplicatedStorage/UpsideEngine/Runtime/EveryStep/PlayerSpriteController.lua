-- @ScriptType: ModuleScript
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerSprite = require(ReplicatedStorage:WaitForChild("Shared")
        :WaitForChild("Entities")
        :WaitForChild("PlayerSprite"))

return function(scene, deltaTime)
        for _, object in scene.Objects do
                if object.Instance.Name ~= "PlayerSprite" or not object.Update then
                        continue
                end

                object:Update(deltaTime)
        end
end
