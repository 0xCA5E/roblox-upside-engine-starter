-- @ScriptType: Script
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Prevent default character spawning to avoid conflicts with the 2D engine setup.
Players.CharacterAutoLoads = false

local upsideEngine = require(ReplicatedStorage:WaitForChild("UpsideEngine"))
print("Upside Engine version: " .. upsideEngine.Version)
