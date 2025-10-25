-- @ScriptType: Script
local replicatedStorage = game:GetService("ReplicatedStorage")
local packages = replicatedStorage.packages

local upsideEngine = require(packages.UpsideEngine)
print("Upside Engine version: " .. upsideEngine.Version)
