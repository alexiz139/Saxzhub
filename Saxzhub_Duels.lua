--[[ 
    Saxzhub Duels Script + Advanced Functions (Final Fix)
    Owner: alexiz139
]]


local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP   = Players.LocalPlayer
local Cam  = Workspace.CurrentCamera
local Mouse = LP:GetMouse()

local T = {
    bg      = Color3.fromRGB(5, 5, 5),     
    panel   = Color3.fromRGB(15, 15, 15), 
    panel2  = Color3.fromRGB(22, 22, 22),  
    border  = Color3.fromRGB(45, 45, 45),  
    acc     = Color3.fromRGB(255, 255, 255), 
    text    = Color3.fromRGB(250, 250, 250),
    muted   = Color3.fromRGB(100, 100, 100),
    darkRed = Color3.fromRGB(30, 30, 30), 
    red     = Color3.fromRGB(200, 30, 30),
    green   = Color3.fromRGB(34, 197, 94),
    bgTrans = 0.1,
    tabSize = 160,
    iconSize = 24,
}

local S = {
    saEn     = false,
    saFOV    = 150,
    saPart   = "Head",
    saDist   = 300,
    hbEn     = false,
    hbSize   = 10,
    autoKill = false,
    eP       = false,
    fovEn    = false,
    fovVal   = 70,
    ncEn     = false,
    spdEn    = false,
    spdVal   = 200,
    espLines = false,
    espBoxes = false,
    autoShoot = false,
    shootDist = 250,
    wallCheck = false,
    hideFovCircle = false,
    espR = 220,
    espG = 20,
    espB = 20,
    espColor = Color3.fromRGB(220, 20, 20),
    saOnlyGun = false,
    saPrediction = 100
}

local function New(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do o[k] = v end
    return o
end

local function Cor(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
end

local function TW(obj, t, props)
    local anim = TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    anim:Play()
    return anim
end

local GlobalGameInfo = { AlivePlayersFolder = nil, PlayerTeamName = nil, CurrentGameFolder = nil, LastCheckTime = 0, MyTeam = nil, EnemyTeam = nil }

local function SanitizeName(str)
    return tostring(str):gsub('%s+', '')
end

local function UpdateGlobalGameInfo()
    local runningGames = workspace:FindFirstChild("RunningGames")
    if not runningGames then return end
    local foundGame = nil
    local foundAliveParams = nil
    local foundTeam = nil
    for _, gameFolder in ipairs(runningGames:GetChildren()) do
        local aliveParams = gameFolder:FindFirstChild("AlivePlayers")
        if aliveParams and aliveParams:IsA("Folder") then
            if aliveParams:FindFirstChild("TeamBlue") and aliveParams.TeamBlue:FindFirstChild(SanitizeName(LP.Name)) then
                foundGame = gameFolder
                foundAliveParams = aliveParams
                foundTeam = "TeamBlue"
                break
            elseif aliveParams:FindFirstChild("TeamRed") and aliveParams.TeamRed:FindFirstChild(SanitizeName(LP.Name)) then
                foundGame = gameFolder
                foundAliveParams = aliveParams
                foundTeam = "TeamRed"
                break
            end
        end
    end
    if foundGame and foundAliveParams then
        GlobalGameInfo.AlivePlayersFolder = foundAliveParams
        GlobalGameInfo.PlayerTeamName = foundTeam
        GlobalGameInfo.CurrentGameFolder = foundGame
        GlobalGameInfo.MyTeam = foundTeam
        GlobalGameInfo.EnemyTeam = (foundTeam == "TeamBlue") and "TeamRed" or "TeamBlue"
    else
        GlobalGameInfo.AlivePlayersFolder = nil
        GlobalGameInfo.PlayerTeamName = nil
        GlobalGameInfo.CurrentGameFolder = nil
        GlobalGameInfo.MyTeam = nil
        GlobalGameInfo.EnemyTeam = nil
    end
end

local function isEnemy(p)
    if p == LP then return false end

local pages = {}
local sidebar

local function newPage(name)
    local pg = New("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = nil -- Will be set later
    })
    New("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 16), SortOrder = Enum.SortOrder.LayoutOrder, Parent = pg })
    New("UIPadding", { PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), Parent = pg })
    pages[name] = pg
    return pg
end

local function Sec(par, ttl)
    local container = New("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = par })
    New("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = container })
    local titleBox = New("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = T.panel2, Parent = container })
    Cor(titleBox, 8)
    New("UIStroke", { Color = Color3.fromRGB(0,0,0), Thickness = 2, Parent = titleBox })
    New("TextLabel", { Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = ttl:upper(), TextColor3 = T.acc, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = titleBox })
    return container
end

local function styleButton(btn)
    Cor(btn, 6)
    New("UIStroke", { Color = Color3.fromRGB(0,0,0), Thickness = 2, Parent = btn })
    New("UIStroke", { Color = T.acc, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = btn })
    btn.MouseEnter:Connect(function() TW(btn, 0.15, {BackgroundColor3 = T.acc}); TW(btn, 0.15, {TextColor3 = Color3.new(1,1,1)}) end)
    btn.MouseLeave:Connect(function() TW(btn, 0.15, {BackgroundColor3 = T.panel}); TW(btn, 0.15, {TextColor3 = T.text}) end)
end

local function Btn(par, lbl, cb)
    local b = New("TextButton", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = T.panel, Text = lbl, TextColor3 = T.text, Font = Enum.Font.GothamBold, Parent = par })
    styleButton(b)
    b.MouseButton1Click:Connect(cb)
    return b
end

local function Tog(par, lbl, def, cb)
    local row = New("Frame", { Size = UDim2.new(1, 0, 0, 55), BackgroundColor3 = T.panel2, Parent = par })
    Cor(row, 10)
    New("UIStroke", { Color = Color3.fromRGB(0,0,0), Thickness = 2, Parent = row })
    New("TextLabel", { Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -70, 1, 0), BackgroundTransparency = 1, Text = lbl, TextColor3 = T.text, Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = row })
    local switchBg = New("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0, 50, 0, 26), BackgroundColor3 = def and Color3.fromRGB(34,197,94) or T.red, Parent = row })
    Cor(switchBg, 6)
    New("UIStroke", { Color = Color3.new(0,0,0), Thickness = 1.5, Parent = switchBg })
    local squareSlider = New("Frame", { Size = UDim2.new(0, 18, 0, 18), Position = def and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9), BackgroundColor3 = Color3.new(1,1,1), Parent = switchBg })
    Cor(squareSlider, 4)
    local click = New("TextButton", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "", Parent = row })
    click.MouseButton1Click:Connect(function()
        def = not def
        TW(switchBg, 0.2, { BackgroundColor3 = def and Color3.fromRGB(34,197,94) or T.red })
        TW(squareSlider, 0.2, { Position = def and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9) })
        cb(def)
    end)
end

local function Sli(par, lbl, mn, mx, def, cb)
    local row = New("Frame", { Size = UDim2.new(1, 0, 0, 65), BackgroundColor3 = T.panel2, Parent = par })
    Cor(row, 8)
    New("UIStroke", { Color = Color3.fromRGB(0,0,0), Thickness = 2, Parent = row })
    New("TextLabel", { Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 12, 0, 6), BackgroundTransparency = 1, Text = lbl, TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = row })
    local btnMinus = New("TextButton", { Position = UDim2.new(0, 12, 0, 28), Size = UDim2.new(0, 26, 0, 26), BackgroundColor3 = T.panel, Text = "-", TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 18, Parent = row })
    styleButton(btnMinus)
    local valueBox = New("Frame", { Position = UDim2.new(0, 46, 0, 28), Size = UDim2.new(0, 80, 0, 26), BackgroundColor3 = T.panel, Parent = row })
    Cor(valueBox, 6)
    New("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 2, Parent = valueBox })
    local valText = New("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = tostring(def), TextColor3 = T.acc, Font = Enum.Font.GothamBold, TextSize = 13, Parent = valueBox })
    local btnPlus = New("TextButton", { Position = UDim2.new(0, 134, 0, 28), Size = UDim2.new(0, 26, 0, 26), BackgroundColor3 = T.panel, Text = "+", TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 18, Parent = row })
    styleButton(btnPlus)
    local dragging = false
    local startX, startVal = 0, def
    local function update(input)
        local delta = input.Position.X - startX
        local speed = (mx - mn) / 300
        local newVal = math.clamp(math.floor(startVal + (delta * speed)), mn, mx)
        if tonumber(valText.Text) ~= newVal then valText.Text = tostring(newVal); cb(newVal) end
    end
    local function changeValue(delta)
        local newVal = math.clamp(tonumber(valText.Text) + delta, mn, mx)
        if newVal ~= tonumber(valText.Text) then valText.Text = tostring(newVal); cb(newVal) end
    end
    btnMinus.MouseButton1Click:Connect(function() changeValue(-1) end)
    btnPlus.MouseButton1Click:Connect(function() changeValue(1) end)
    valueBox.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; startX = i.Position.X; startVal = tonumber(valText.Text) end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update(i) end end)
    UserInputService.InputEnded:Connect(function() dragging = false end)
end

local function LineSlider(par, lbl, mn, mx, def, cb)
    local row = New("Frame", { Size = UDim2.new(1, 0, 0, 65), BackgroundColor3 = T.panel2, Parent = par })
    Cor(row, 8)
    New("UIStroke", { Color = Color3.fromRGB(0,0,0), Thickness = 2, Parent = row })
    New("TextLabel", { Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 12, 0, 6), BackgroundTransparency = 1, Text = lbl, TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = row })
    local track = New("Frame", { Position = UDim2.new(0, 12, 0, 36), Size = UDim2.new(1, -170, 0, 4), BackgroundColor3 = T.panel, Parent = row })
    Cor(track, 4)
    local fill = New("Frame", { BackgroundColor3 = T.acc, Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0), Parent = track })
    Cor(fill, 4)
    local thumb = New("TextButton", { Position = UDim2.new((def - mn) / (mx - mn), -10, 0.5, -10), Size = UDim2.new(0, 20, 0, 20), BackgroundColor3 = T.acc, Text = "", Parent = track })
    Cor(thumb, 10)
    local btnMinus = New("TextButton", { Position = UDim2.new(1, -145, 0, 25), Size = UDim2.new(0, 26, 0, 26), BackgroundColor3 = T.panel, Text = "-", TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 18, Parent = row })
    styleButton(btnMinus)
    local valueBox = New("Frame", { Position = UDim2.new(1, -112, 0, 25), Size = UDim2.new(0, 50, 0, 26), BackgroundColor3 = T.panel, Parent = row })
    Cor(valueBox, 6)
    New("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 2, Parent = valueBox })
    local valueLabel = New("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = tostring(def), TextColor3 = T.acc, Font = Enum.Font.GothamBold, TextSize = 13, Parent = valueBox })
    local btnPlus = New("TextButton", { Position = UDim2.new(1, -55, 0, 25), Size = UDim2.new(0, 26, 0, 26), BackgroundColor3 = T.panel, Text = "+", TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 18, Parent = row })
    styleButton(btnPlus)
    local dragging = false
    local function update(posX)
        local trackPos = track.AbsolutePosition.X
        local trackWidth = track.AbsoluteSize.X
        local t = math.clamp((posX - trackPos) / trackWidth, 0, 1)
        local newVal = math.floor(mn + t * (mx - mn))
        if tonumber(valueLabel.Text) ~= newVal then
            valueLabel.Text = tostring(newVal)
            fill.Size = UDim2.new(t, 0, 1, 0)
            thumb.Position = UDim2.new(t, -10, 0.5, -10)
            cb(newVal)
        end
    end
    thumb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update(i.Position.X) end end)
    UserInputService.InputEnded:Connect(function() dragging = false end)
end

local GUI = New("ScreenGui", { Name = "Saxzhub_GUI", ResetOnSpawn = false, Parent = (gethui and gethui() or game:GetService("CoreGui")) })

local IntroFrame = New("Frame", { Name = "Intro", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 100, Parent = GUI })
local IntroLogo = New("ImageLabel", { Size = UDim2.new(0, 150, 0, 150), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.4), Image = "rbxassetid://106977920570768", BackgroundTransparency = 1, ZIndex = 102, Parent = IntroFrame })
Cor(IntroLogo, 75)
local IntroName = New("TextLabel", { Size = UDim2.new(0, 200, 0, 50), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.55), Text = "Saxzhub", TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold, TextSize = 35, BackgroundTransparency = 1, ZIndex = 102, Parent = IntroFrame })

local LoadingBarContainer = New("Frame", { Size = UDim2.new(0, 300, 0, 15), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.65), BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 102, Parent = IntroFrame })
Cor(LoadingBarContainer, 5)
local LoadingBarFill = New("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 103, Parent = LoadingBarContainer })
Cor(LoadingBarFill, 5)

local winMain = New("Frame", { Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(0, 600, 0, 320), BackgroundColor3 = T.bg, Visible = false, Parent = GUI })
Cor(winMain, 10)
local titleBar = New("Frame", { Position = UDim2.new(0, 8, 0, 8), Size = UDim2.new(1, -16, 0, 42), BackgroundColor3 = Color3.fromRGB(25, 25, 25), Parent = winMain })
Cor(titleBar, 12)
local closeX = New("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.new(0, 32, 0, 32), BackgroundColor3 = T.red, Text = "-", TextColor3 = Color3.new(1, 1, 1), Parent = titleBar })
Cor(closeX, 8)

sidebar = New("ScrollingFrame", { Position = UDim2.new(0, 10, 0, 58), Size = UDim2.new(0, T.tabSize, 1, -66), BackgroundTransparency = 1, ScrollBarThickness = 0, Parent = winMain })
New("UIListLayout", { Padding = UDim.new(0, 10), Parent = sidebar })

local contentArea = New("Frame", { Position = UDim2.new(0, T.tabSize + 25, 0, 58), Size = UDim2.new(1, -(T.tabSize + 25), 1, -66), BackgroundTransparency = 1, Parent = winMain })

local floatIcon = New("ImageButton", { Name = "FloatIcon", Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 10, 0.5, -25), Image = "rbxassetid://106977920570768", BackgroundColor3 = T.bg, Visible = false, ZIndex = 50, Parent = GUI })
Cor(floatIcon, 25)

local function toggle() winMain.Visible = not winMain.Visible end
floatIcon.MouseButton1Click:Connect(toggle)
closeX.MouseButton1Click:Connect(toggle)

local function addSidebarBtn(name, pageName)
    local btn = New("TextButton", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = T.panel, Text = name, TextColor3 = T.text, Font = Enum.Font.GothamBold, Parent = sidebar })
    Cor(btn, 8)
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        pages[pageName].Visible = true
    end)
end

-- INFO
local pgInfo = newPage("Info")
pgInfo.Parent = contentArea
local sInfo = Sec(pgInfo, "Información")
New("TextLabel", { Size = UDim2.new(1, 0, 0, 80), BackgroundTransparency = 1, Text = "Bienvenido a Saxzhub\nOwner: alexiz139", TextColor3 = T.text, Parent = sInfo })
addSidebarBtn("INFO", "Info")

-- COMBAT
local pgCombat = newPage("Combat")
pgCombat.Parent = contentArea
local sCombat = Sec(pgCombat, "Silent Aim 360°")
Tog(sCombat, "Activar Silent Aim", false, function(v) S.saEn = v end)
Sli(sCombat, "Radio de FOV", 30, 800, 150, function(v) S.saFOV = v end)
Tog(sCombat, "Auto Shoot", false, function(v) S.autoShoot = v end)
addSidebarBtn("COMBAT", "Combat")

-- SKINS
local pgSkins = newPage("Skins")
pgSkins.Parent = contentArea
local function ApplyKorblox() pcall(function() local char = LP.Character; char.RightUpperLeg:Destroy(); char.RightLowerLeg:Destroy(); char.RightFoot:Destroy() end) end
local function ApplyHeadless() pcall(function() local char = LP.Character; char.Head.Transparency = 1; char.Head.face.Transparency = 1 end) end
local sSkins = Sec(pgSkins, "Visuales Pro")
Btn(sSkins, "Activar Korblox", ApplyKorblox)
Btn(sSkins, "Activar Headless", ApplyHeadless)
addSidebarBtn("SKINS", "Skins")

pages["Info"].Visible = true

-- LOGICA DE LA INTRO
task.spawn(function()
    local loadTime = 4
    local startTick = tick()
    while tick() - startTick < loadTime do
        local progress = (tick() - startTick) / loadTime
        LoadingBarFill.Size = UDim2.fromScale(progress, 1)
        task.wait()
    end
    LoadingBarFill.Size = UDim2.fromScale(1, 1)
    task.wait(0.5)
    TW(IntroFrame, 0.8, {BackgroundTransparency = 1})
    TW(IntroLogo, 0.8, {ImageTransparency = 1})
    TW(IntroName, 0.8, {TextTransparency = 1})
    task.wait(0.8)
    IntroFrame:Destroy()
    floatIcon.Visible = true
end)
