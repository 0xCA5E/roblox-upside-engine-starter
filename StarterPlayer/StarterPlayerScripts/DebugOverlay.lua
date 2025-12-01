-- @ScriptType: ModuleScript
-- Creates a lightweight overlay that surfaces FPS and player position.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local DebugOverlay = {}
DebugOverlay.__index = DebugOverlay

local LABEL_HEIGHT = 20
local PADDING = 8
local BACKGROUND_COLOR = Color3.fromRGB(10, 10, 10)
local TEXT_COLOR = Color3.new(1, 1, 1)
local UPDATE_INTERVAL = 0.5

local function createLabel(parent, order, initialText)
        local label = Instance.new("TextLabel")
        label.Name = initialText:gsub("%s+", "")
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.SourceSans
        label.Text = initialText
        label.TextColor3 = TEXT_COLOR
        label.TextSize = 18
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.AutomaticSize = Enum.AutomaticSize.Y
        label.Size = UDim2.new(1, 0, 0, LABEL_HEIGHT)
        label.LayoutOrder = order
        label.Parent = parent

        return label
end

local function createContainer(parent)
        local container = Instance.new("Frame")
        container.Name = "DebugOverlay"
        container.AnchorPoint = Vector2.new(1, 1)
        container.Position = UDim2.fromScale(1, 1)
        container.Size = UDim2.fromOffset(220, PADDING * 2 + LABEL_HEIGHT * 2)
        container.BackgroundColor3 = BACKGROUND_COLOR
        container.BackgroundTransparency = 0.35
        container.BorderSizePixel = 0
        container.Parent = parent

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, PADDING)
        padding.PaddingBottom = UDim.new(0, PADDING)
        padding.PaddingLeft = UDim.new(0, PADDING)
        padding.PaddingRight = UDim.new(0, PADDING)
        padding.Parent = container

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        layout.VerticalAlignment = Enum.VerticalAlignment.Top
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = container

        return container
end

function DebugOverlay.new(parentGui)
        local overlay = setmetatable({}, DebugOverlay)

        overlay.Gui = createContainer(parentGui)
        overlay.FpsLabel = createLabel(overlay.Gui, 1, "FPS: --")
        overlay.PositionLabel = createLabel(overlay.Gui, 2, "Player: --, --")
        overlay._frameCount = 0
        overlay._accumulatedTime = 0

        overlay._connection = RunService.RenderStepped:Connect(function(deltaTime)
                overlay:_update(deltaTime)
        end)

        local player = Players.LocalPlayer
        overlay.Player = player

        return overlay
end

function DebugOverlay:SetPlayerSprite(playerSprite)
        self.PlayerSprite = playerSprite
end

function DebugOverlay:_update(deltaTime)
        self._frameCount += 1
        self._accumulatedTime += deltaTime

        if self._accumulatedTime >= UPDATE_INTERVAL then
                local fps = math.floor((self._frameCount / self._accumulatedTime) + 0.5)
                self.FpsLabel.Text = string.format("FPS: %d", fps)
                self._frameCount = 0
                self._accumulatedTime = 0
        end

        local positionText = "Player: --, --"
        local playerSprite = self.PlayerSprite

        if playerSprite and playerSprite.Instance then
                local position = playerSprite.Instance.Position
                positionText = string.format(
                        "Player: %.1f, %.1f",
                        position.X.Offset,
                        position.Y.Offset
                )
        end

        self.PositionLabel.Text = positionText
end

function DebugOverlay:Destroy()
        if self._connection then
                self._connection:Disconnect()
                self._connection = nil
        end

        if self.Gui then
                self.Gui:Destroy()
                self.Gui = nil
        end
end

return DebugOverlay
