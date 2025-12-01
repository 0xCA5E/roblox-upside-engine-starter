-- @ScriptType: Script
local replicatedStorage = game:GetService("ReplicatedStorage")

local upsideEngine = require(replicatedStorage:WaitForChild("UpsideEngine"))
print("Upside Engine version: " .. upsideEngine.Version)
