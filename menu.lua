local MENU_NAME = "PurpleConsoleMenu"
local THEME_COLOR = Color3.fromRGB(170, 0, 255)
local BG_COLOR = Color3.fromRGB(20, 20, 20)
local LIGHT_BG_COLOR = Color3.fromRGB(30, 30, 30)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local SUBTEXT_COLOR = Color3.fromRGB(150, 150, 150)
local FONT = Enum.Font.SourceSansPro
local ROUNDNESS = UDim.new(0, 8)
local ANIMATION_TIME = 0.2

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if LocalPlayer:FindFirstChild(MENU_NAME) then
    LocalPlayer[MENU_NAME]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = MENU_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 800, 0, 500)
MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = ROUNDNESS
UICorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = LIGHT_BG_COLOR
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundColor3 = LIGHT_BG_COLOR
Title.BackgroundTransparency = 1
Title.Text = "INTELLECT EXTERNAL"
Title.TextColor3 = THEME_COLOR
Title.TextSize = 24
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 25, 1, 0)
MinimizeButton.Position = UDim2.new(1, -55, 0, 0)
MinimizeButton.BackgroundColor3 = BG_COLOR
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = TEXT_COLOR
MinimizeButton.TextSize = 20
MinimizeButton.Font = FONT
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 1, 0)
CloseButton.Position = UDim2.new(1, -25, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = TEXT_COLOR
CloseButton.TextSize = 20
CloseButton.Font = FONT
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

local ContentWrapper = Instance.new("Frame")
ContentWrapper.Size = UDim2.new(1, 0, 1, -50)
ContentWrapper.Position = UDim2.new(0, 0, 0, 50)
ContentWrapper.BackgroundTransparency = 1
ContentWrapper.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 0)
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.Parent = ContentWrapper

local NavPanel = Instance.new("Frame")
NavPanel.Size = UDim2.new(0, 200, 1, 0)
NavPanel.BackgroundColor3 = LIGHT_BG_COLOR
NavPanel.BorderSizePixel = 0
NavPanel.Parent = ContentWrapper

local NavLayout = Instance.new("UIListLayout")
NavLayout.Padding = UDim.new(0, 5)
NavLayout.FillDirection = Enum.FillDirection.Vertical
NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
NavLayout.Parent = NavPanel

local NavPadding = Instance.new("UIPadding")
NavPadding.PaddingTop = UDim.new(0, 10)
NavPadding.PaddingLeft = UDim.new(0, 10)
NavPadding.PaddingRight = UDim.new(0, 10)
NavPadding.Parent = NavPanel

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -200, 1, 0)
ContentArea.Position = UDim2.new(0, 200, 0, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = ContentWrapper

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 10)
ContentPadding.PaddingLeft = UDim.new(0, 10)
ContentPadding.PaddingRight = UDim.new(0, 10)
ContentPadding.PaddingBottom = UDim.new(0, 10)
ContentPadding.Parent = ContentArea

local EnabledMods = Instance.new("TextLabel")
EnabledMods.Name = "EnabledModsDisplay"
EnabledMods.Size = UDim2.new(0.2, 0, 0.2, 0)
EnabledMods.Position = UDim2.new(0.98, 0, 0.02, 0)
EnabledMods.AnchorPoint = Vector2.new(1, 0)
EnabledMods.BackgroundTransparency = 1
EnabledMods.Text = ""
EnabledMods.TextColor3 = THEME_COLOR
EnabledMods.TextSize = 14
EnabledMods.Font = FONT
EnabledMods.TextXAlignment = Enum.TextXAlignment.Right
EnabledMods.TextYAlignment = Enum.TextYAlignment.Top
EnabledMods.Parent = ScreenGui

local activeMods = {}
local toggleFunctions = {}

local function updateEnabledModsDisplay()
    local displayText = ""
    for _, modName in pairs(activeMods) do
        displayText = displayText .. modName .. "\n"
    end
    EnabledMods.Text = displayText
end

local currentActiveButton = nil
local function CreateNavHeader(name)
    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.BackgroundTransparency = 1
    Header.Text = name
    Header.TextColor3 = SUBTEXT_COLOR
    Header.TextSize = 12
    Header.Font = FONT
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Parent = NavPanel
end

local function CreateNavButton(name, icon, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundTransparency = 1
    Button.Text = "  " .. name
    Button.TextColor3 = SUBTEXT_COLOR
    Button.TextSize = 16
    Button.Font = FONT
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = NavPanel

    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 30, 1, 0)
    Icon.BackgroundTransparency = 1
    Icon.TextColor3 = SUBTEXT_COLOR
    Icon.Text = icon
    Icon.TextSize = 18
    Icon.Font = Enum.Font.Code
    Icon.Parent = Button

    local Highlight = Instance.new("Frame")
    Highlight.Size = UDim2.new(0, 3, 1, 0)
    Highlight.BackgroundColor3 = THEME_COLOR
    Highlight.Position = UDim2.new(0, 0, 0, 0)
    Highlight.BackgroundTransparency = 1
    Highlight.Parent = Button

    local function setActive()
        if currentActiveButton then
            currentActiveButton.TextColor3 = SUBTEXT_COLOR
            currentActiveButton.Icon.TextColor3 = SUBTEXT_COLOR
            currentActiveButton.Highlight.BackgroundTransparency = 1
        end
        currentActiveButton = Button
        Button.TextColor3 = TEXT_COLOR
        Button.Icon.TextColor3 = THEME_COLOR
        Button.Highlight.BackgroundTransparency = 0
    end

    Button.MouseButton1Click:Connect(function()
        for _, child in pairs(ContentArea:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = false
            end
        end
        setActive()
        callback()
    end)

    Button.MouseEnter:Connect(function()
        if Button ~= currentActiveButton then
            Button.TextColor3 = TEXT_COLOR
            Button.Icon.TextColor3 = THEME_COLOR
        end
    end)

    Button.MouseLeave:Connect(function()
        if Button ~= currentActiveButton then
            Button.TextColor3 = SUBTEXT_COLOR
            Button.Icon.TextColor3 = SUBTEXT_COLOR
        end
    end)
end

local function CreatePage(name)
    local Page = Instance.new("Frame")
    Page.Name = name
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Parent = ContentArea
    Page.Visible = false
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.FillDirection = Enum.FillDirection.Vertical
    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    ListLayout.Parent = Page
    
    return Page
end

local function CreateSectionHeader(parent, name)
    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, 0, 0, 20)
    Header.BackgroundTransparency = 1
    Header.Text = name
    Header.TextColor3 = TEXT_COLOR
    Header.TextSize = 18
    Header.Font = FONT
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Parent = parent
    
    local Underline = Instance.new("Frame")
    Underline.Size = UDim2.new(1, 0, 0, 1)
    Underline.BackgroundColor3 = SUBTEXT_COLOR
    Underline.Parent = Header
end

local function CreateToggle(parent, name, subtext, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 50)
    Container.BackgroundTransparency = 1
    Container.Parent = parent

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 5)
    Layout.FillDirection = Enum.FillDirection.Vertical
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    Layout.Parent = Container

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.BackgroundTransparency = 1
    Title.Text = name
    Title.TextColor3 = TEXT_COLOR
    Title.TextSize = 16
    Title.Font = FONT
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Container

    local Subtext = Instance.new("TextLabel")
    Subtext.Size = UDim2.new(1, 0, 0, 15)
    Subtext.BackgroundTransparency = 1
    Subtext.Text = subtext
    Subtext.TextColor3 = SUBTEXT_COLOR
    Subtext.TextSize = 12
    Subtext.Font = FONT
    Subtext.TextXAlignment = Enum.TextXAlignment.Left
    Subtext.Parent = Container

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 20, 0, 20)
    Checkbox.Position = UDim2.new(1, -20, 0.5, 0)
    Checkbox.AnchorPoint = Vector2.new(1, 0.5)
    Checkbox.BackgroundColor3 = LIGHT_BG_COLOR
    Checkbox.BorderSizePixel = 1
    Checkbox.BorderColor3 = SUBTEXT_COLOR
    Checkbox.Text = ""
    Checkbox.TextColor3 = THEME_COLOR
    Checkbox.TextSize = 16
    Checkbox.Font = Enum.Font.Code
    Checkbox.Parent = Container

    local isEnabled = false

    local function toggle(state)
        isEnabled = state
        if isEnabled then
            Checkbox.Text = "✓"
            table.insert(activeMods, name)
        else
            Checkbox.Text = ""
            for i, modName in ipairs(activeMods) do
                if modName == name then
                    table.remove(activeMods, i)
                    break
                end
            end
        end
        updateEnabledModsDisplay()
        callback(isEnabled)
    end
    
    toggleFunctions[name] = function()
        toggle(false)
    end

    Checkbox.MouseButton1Click:Connect(function()
        toggle(not isEnabled)
    end)
end

local function CreateSlider(parent, name, callback, min, max, initialValue)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 40)
    Container.BackgroundTransparency = 1
    Container.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -25, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = TEXT_COLOR
    Label.TextSize = 16
    Label.Font = FONT
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 25, 0, 20)
    ValueLabel.Position = UDim2.new(1, -25, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.TextColor3 = SUBTEXT_COLOR
    ValueLabel.TextSize = 14
    ValueLabel.Font = FONT
    ValueLabel.Parent = Container

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -25, 0, 5)
    SliderFrame.Position = UDim2.new(0, 0, 1, -10)
    SliderFrame.BackgroundColor3 = SUBTEXT_COLOR
    SliderFrame.Parent = Container

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = THEME_COLOR
    SliderFill.Parent = SliderFrame
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1,0)
    SliderCorner.Parent = SliderFill
    
    local SliderCorner2 = Instance.new("UICorner")
    SliderCorner2.CornerRadius = UDim.new(1,0)
    SliderCorner2.Parent = SliderFrame

    local sliderValue = initialValue or min
    local isDragging = false

    local function updateSlider(x)
        local frameWidth = SliderFrame.AbsoluteSize.X
        local newX = math.clamp(x, 0, frameWidth)
        local ratio = newX / frameWidth
        local value = math.floor(min + (max - min) * ratio)
        
        SliderFill.Size = UDim2.new(0, newX, 1, 0)
        ValueLabel.Text = tostring(value)
        
        if sliderValue ~= value then
            sliderValue = value
            callback(sliderValue)
        end
    end

    SliderFrame.MouseButton1Down:Connect(function()
        isDragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = input.Position.X - SliderFrame.AbsolutePosition.X
            updateSlider(relativeX)
        end
    end)
    
    updateSlider(((initialValue - min) / (max - min)) * SliderFrame.AbsoluteSize.X)
end

local function CreateDropdown(parent, name, options, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 50)
    Container.BackgroundTransparency = 1
    Container.Parent = parent

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.BackgroundTransparency = 1
    Title.Text = name
    Title.TextColor3 = TEXT_COLOR
    Title.TextSize = 16
    Title.Font = FONT
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Container

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 25)
    DropdownButton.Position = UDim2.new(0, 0, 1, -25)
    DropdownButton.BackgroundColor3 = LIGHT_BG_COLOR
    DropdownButton.BorderSizePixel = 1
    DropdownButton.BorderColor3 = SUBTEXT_COLOR
    DropdownButton.Text = "  " .. (options[1] or "Select...")
    DropdownButton.TextColor3 = TEXT_COLOR
    DropdownButton.TextSize = 14
    DropdownButton.Font = FONT
    DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    DropdownButton.Parent = Container

    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 5)
    dropdownCorner.Parent = DropdownButton

    local DropdownArrow = Instance.new("TextLabel")
    DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
    DropdownArrow.Position = UDim2.new(1, -20, 0, 0)
    DropdownArrow.BackgroundTransparency = 1
    DropdownArrow.Text = "▼"
    DropdownArrow.TextColor3 = SUBTEXT_COLOR
    DropdownArrow.TextSize = 12
    DropdownArrow.Font = FONT
    DropdownArrow.Parent = DropdownButton

    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(1, 0, 0, #options * 25)
    DropdownList.Position = UDim2.new(0, 0, 1, 0)
    DropdownList.BackgroundColor3 = LIGHT_BG_COLOR
    DropdownList.BorderSizePixel = 1
    DropdownList.BorderColor3 = SUBTEXT_COLOR
    DropdownList.ZIndex = 2
    DropdownList.Visible = false
    DropdownList.Parent = Container

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 0)
    ListLayout.FillDirection = Enum.FillDirection.Vertical
    ListLayout.Parent = DropdownList
    
    for i, opt in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 25)
        OptionButton.BackgroundTransparency = 1
        OptionButton.Text = "  " .. opt
        OptionButton.TextColor3 = TEXT_COLOR
        OptionButton.TextSize = 14
        OptionButton.Font = FONT
        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
        OptionButton.Parent = DropdownList
        
        OptionButton.MouseButton1Click:Connect(function()
            DropdownButton.Text = "  " .. opt
            DropdownList.Visible = false
            callback(opt)
        end)
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
    end)
end

local isMinimized = false
local MINIMIZED_SIZE = UDim2.new(0, 150, 0, 30)
local FULL_SIZE = UDim2.new(0, 800, 0, 500)

local minimizedFrame = Instance.new("TextButton")
minimizedFrame.Size = MINIMIZED_SIZE
minimizedFrame.Position = UDim2.new(0.5, -75, 1, -40)
minimizedFrame.AnchorPoint = Vector2.new(0.5, 0.5)
minimizedFrame.BackgroundColor3 = BG_COLOR
minimizedFrame.BorderSizePixel = 0
minimizedFrame.Text = " MOD MENU"
minimizedFrame.TextColor3 = TEXT_COLOR
minimizedFrame.TextSize = 18
minimizedFrame.Font = FONT
minimizedFrame.TextXAlignment = Enum.TextXAlignment.Left
minimizedFrame.Active = true
minimizedFrame.Draggable = true
minimizedFrame.Visible = false
minimizedFrame.Parent = ScreenGui

local minimizedCorner = Instance.new("UICorner")
minimizedCorner.CornerRadius = ROUNDNESS
minimizedCorner.Parent = minimizedFrame

MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = true
    local tweenInfo = TweenInfo.new(ANIMATION_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {Size = MINIMIZED_SIZE, Position = UDim2.new(0.5, -75, 1, -40)}
    local tween = TweenService:Create(MainFrame, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
    MainFrame.Visible = false
    minimizedFrame.Visible = true
end)

minimizedFrame.MouseButton1Click:Connect(function()
    isMinimized = false
    MainFrame.Position = minimizedFrame.Position
    MainFrame.Size = MINIMIZED_SIZE
    MainFrame.Visible = true
    minimizedFrame.Visible = false
    local tweenInfo = TweenInfo.new(ANIMATION_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {Size = FULL_SIZE, Position = UDim2.new(0.5, -400, 0.5, -250)}
    local tween = TweenService:Create(MainFrame, tweenInfo, goal)
    tween:Play()
end)

local function disableAllMods()
    for modName, func in pairs(toggleFunctions) do
        func()
    end
end

CloseButton.MouseButton1Click:Connect(function()
    local confirmationFrame = Instance.new("Frame")
    confirmationFrame.Size = UDim2.new(0, 250, 0, 120)
    confirmationFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
    confirmationFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    confirmationFrame.BackgroundColor3 = BG_COLOR
    confirmationFrame.BorderSizePixel = 1
    confirmationFrame.Parent = ScreenGui

    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = ROUNDNESS
    confirmCorner.Parent = confirmationFrame

    local confirmLabel = Instance.new("TextLabel")
    confirmLabel.Size = UDim2.new(1, -20, 0, 60)
    confirmLabel.Position = UDim2.new(0.5, 0, 0, 10)
    confirmLabel.AnchorPoint = Vector2.new(0.5, 0)
    confirmLabel.BackgroundTransparency = 1
    confirmLabel.Text = "Are you sure you want to close the menu? This will disable all active mods."
    confirmLabel.TextColor3 = TEXT_COLOR
    confirmLabel.TextSize = 14
    confirmLabel.Font = FONT
    confirmLabel.TextWrapped = true
    confirmLabel.Parent = confirmationFrame

    local yesButton = Instance.new("TextButton")
    yesButton.Size = UDim2.new(0, 80, 0, 30)
    yesButton.Position = UDim2.new(0.5, -45, 1, -40)
    yesButton.AnchorPoint = Vector2.new(1, 1)
    yesButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    yesButton.Text = "Yes"
    yesButton.TextColor3 = TEXT_COLOR
    yesButton.TextSize = 16
    yesButton.Font = FONT
    yesButton.BorderSizePixel = 0
    yesButton.Parent = confirmationFrame

    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 5)
    yesCorner.Parent = yesButton

    local noButton = Instance.new("TextButton")
    noButton.Size = UDim2.new(0, 80, 0, 30)
    noButton.Position = UDim2.new(0.5, 45, 1, -40)
    noButton.AnchorPoint = Vector2.new(0, 1)
    noButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    noButton.Text = "No"
    noButton.TextColor3 = TEXT_COLOR
    noButton.TextSize = 16
    noButton.Font = FONT
    noButton.BorderSizePixel = 0
    noButton.Parent = confirmationFrame

    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 5)
    noCorner.Parent = noButton

    yesButton.MouseButton1Click:Connect(function()
        disableAllMods()
        ScreenGui:Destroy()
    end)

    noButton.MouseButton1Click:Connect(function()
        confirmationFrame:Destroy()
    end)
end)

local ESPPage = CreatePage("ESP")
local PlayerPage = CreatePage("Players")
local YouPage = CreatePage("You")
local LegitPage = CreatePage("Legit")
local BlatantPage = CreatePage("Blatant")
local MiscPage = CreatePage("Misc")
local IntellectPage = CreatePage("Intellect")
local SpooferPage = CreatePage("Spoofer")
local TheBeyondPage = CreatePage("The Beyond")
local SettingsPage = CreatePage("Settings")
local ConfigPage = CreatePage("Config")
local HomePage = CreatePage("Home")


CreateNavHeader("MOVEMENT")
CreateNavButton("Legit", "↑", function()
    LegitPage.Visible = true
end)
CreateNavButton("Blatant", "◎", function()
    BlatantPage.Visible = true
end)
CreateNavButton("Misc", "…", function()
    MiscPage.Visible = true
end)

CreateNavHeader("VISUALS")
CreateNavButton("Players", "◎", function()
    PlayerPage.Visible = true
end)
CreateNavButton("You", "👤", function()
    YouPage.Visible = true
end)

CreateNavHeader("STEALTH")
CreateNavButton("Intellect", "☐", function()
    IntellectPage.Visible = true
end)
CreateNavButton("Spoofer", "♺", function()
    SpooferPage.Visible = true
end)
CreateNavButton("The Beyond", "💻", function()
    TheBeyondPage.Visible = true
end)

CreateNavHeader("SETTINGS")
CreateNavButton("Settings", "⚙", function()
    SettingsPage.Visible = true
end)
CreateNavButton("Config", "🗃", function()
    ConfigPage.Visible = true
end)
CreateNavButton("Home", "🏠", function()
    HomePage.Visible = true
end)


local PlayerVisualsPage = CreatePage("Player Visuals")
local TaggingPage = CreatePage("Tagging")

CreateSectionHeader(PlayerVisualsPage, "ESP")
CreateToggle(PlayerVisualsPage, "Player Outlines", "Draw outlines on players", function(enabled)
    if enabled then
        -- Your code to enable ESP outlines
    else
        -- Your code to disable ESP outlines
    end
end)
CreateToggle(PlayerVisualsPage, "Player Names", "Show names above players", function(enabled)
    if enabled then
        -- Your code to show player names
    else
        -- Your code to hide player names
    end
end)
CreateToggle(PlayerVisualsPage, "Player Distance", "Show distance to players", function(enabled)
    if enabled then
        -- Your code to show player distance
    else
        -- Your code to hide player distance
    end
end)

CreateSectionHeader(PlayerPage, "Wall Assist")
CreateToggle(PlayerPage, "Wall Walk", "Climb Walls With Base", function(enabled) end)
CreateToggle(PlayerPage, "Include Tree Scale", "Combo Wallwalk for tree scaling", function(enabled) end)
CreateToggle(PlayerPage, "Speed Boost", "Run Faster than anyone", function(enabled) end)
CreateToggle(PlayerPage, "No Slip", "Remove all Slippery Walls", function(enabled) end)
CreateToggle(PlayerPage, "No Finger Movement", "Disable Finger Movement", function(enabled) end)

CreateSectionHeader(PlayerPage, "Sliders")
CreateSlider(PlayerPage, "Boost Power", function(value) end, 0, 100, 9)
CreateSlider(PlayerPage, "Wall Power", function(value) end, 0, 100, 51)
CreateSectionHeader(PlayerPage, "Players")
CreateToggle(PlayerPage, "Players Oversync", "give time to react easily and tag.", function(enabled) end)

CreateSectionHeader(TaggingPage, "Tagging")
CreateToggle(TaggingPage, "Hand Tag Expander", "expands the hitboxes on your tag hand", function(enabled) end)
CreateToggle(TaggingPage, "Visualise Expander", "visualises the hitbox size", function(enabled) end)
CreateDropdown(TaggingPage, "Visualiser Shape", {"(Tag Desyneer N Expander)"}, function(option) end)
CreateSlider(TaggingPage, "Visualiser Opacity", function(value) end, 0, 100, 10)
CreateSlider(TaggingPage, "Expander Distance", function(value) end, 0, 100, 10)
CreateSectionHeader(TaggingPage, "Tagging V2")
CreateToggle(TaggingPage, "Dc Flick Tag", "Fake controller disconnect, tag nearest", function(enabled) end)
CreateDropdown(TaggingPage, "Dominant Hand", {"Left", "Right"}, function(option) end)
CreateDropdown(TaggingPage, "Hand Behaviour", {"Normal"}, function(option) end)
CreateSlider(TaggingPage, "DcFlickTag Distance", function(value) end, 0, 100, 5)

local function openPage(pageName)
    for _, page in pairs(ContentArea:GetChildren()) do
        if page:IsA("Frame") then
            page.Visible = false
        end
    end
    local targetPage = ContentArea:FindFirstChild(pageName)
    if targetPage then
        targetPage.Visible = true
    end
end

CreateNavButton("Wall Assist", "◎", function()
    openPage("Wall Assist")
end)

CreateNavButton("Tagging", "✔", function()
    openPage("Tagging")
end)

local firstButton = NavPanel:FindFirstChildOfClass("TextButton")
if firstButton then
    firstButton.MouseButton1Click:Fire()
end
