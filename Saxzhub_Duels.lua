--[[ 
    Saxzhub Duels Script + Advanced Functions
    Owner: alexiz139
]]

--[[
========================================

╔════════════════════════╗
║          Saxzhub        ║ Owner          ║
╚════════════════════════╝

Script Edited for Saxzhub
Version: 1.0 + Intro

Owner: Saxzhub
Creadores:
- Creador: ForceDev
- Dev: Saxzhub

========================================

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
local C3   = Color3.fromRGB

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
    for k, v in pairs(props or {}) do
        o[k] = v
    end
    return o
end

local function Cor(obj, r)
    New("UICorner", {
        CornerRadius = UDim.new(0, r or 8),
        Parent = obj
    })
end

local function TW(obj, t, props)
    local anim = TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    anim:Play()
    return anim
end

-- GUI PRINCIPAL
local GUI = New("ScreenGui", {
    Name = "Saxzhub_GUI",
    ResetOnSpawn = false,
    DisplayOrder = 10,
    IgnoreGuiInset = true,
    Parent = (gethui and gethui() or game:GetService("CoreGui"))
})

-- PANTALLA DE CARGA (INTRO)
local IntroFrame = New("Frame", {
    Name = "Intro",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0),
    ZIndex = 100,
    Parent = GUI
})

local IntroBackground = New("ImageLabel", {
    Size = UDim2.fromScale(1, 1),
    Image = "rbxassetid://94303726339504",
    ScaleType = Enum.ScaleType.Crop,
    BackgroundTransparency = 1,
    ZIndex = 101,
    Parent = IntroFrame
})

local IntroLogo = New("ImageLabel", {
    Size = UDim2.new(0, 150, 0, 150),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.4),
    Image = "rbxassetid://106977920570768",
    BackgroundTransparency = 1,
    ZIndex = 102,
    Parent = IntroFrame
})
Cor(IntroLogo, 75)

local IntroName = New("TextLabel", {
    Size = UDim2.new(0, 200, 0, 50),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.55),
    Text = "Saxzhub",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 35,
    BackgroundTransparency = 1,
    ZIndex = 102,
    Parent = IntroFrame
})

local LoadingBarContainer = New("Frame", {
    Size = UDim2.new(0, 300, 0, 15),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.65),
    BackgroundColor3 = Color3.new(0, 0, 0),
    ZIndex = 102,
    Parent = IntroFrame
})
Cor(LoadingBarContainer, 5)
local LoadingStroke = New("UIStroke", {
    Color = Color3.new(1, 1, 1),
    Thickness = 2,
    Parent = LoadingBarContainer
})

local LoadingBarFill = New("Frame", {
    Size = UDim2.fromScale(0, 1),
    BackgroundColor3 = Color3.new(1, 1, 1),
    ZIndex = 103,
    Parent = LoadingBarContainer
})
Cor(LoadingBarFill, 5)

-- FUNCIONES DE LA INTERFAZ PRINCIPAL (DENTRO DE WINMAIN)
local winMain = New("Frame", {
    Name = "Window",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.new(0, 600, 0, 320),
    BackgroundColor3 = T.bg,
    BackgroundTransparency = T.bgTrans,
    Visible = false, -- SE OCULTA AL INICIO
    Parent = GUI
})
Cor(winMain, 10)
New("UIStroke", {
    Color = Color3.new(0, 0, 0),
    Thickness = 3,
    Parent = winMain
})

local titleBar = New("Frame", {
    Position = UDim2.new(0, 8, 0, 8),
    Size = UDim2.new(1, -16, 0, 42),
    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
    BackgroundTransparency = 0.15,
    Parent = winMain
})
Cor(titleBar, 12)
New("UIStroke", { Color = T.darkRed, Thickness = 2.2, Parent = titleBar })

New("TextLabel", {
    Position = UDim2.new(0, 15, 0, 0),
    Size = UDim2.new(0, 300, 1, 0),
    BackgroundTransparency = 1,
    Text = "Saxzhub | Versión 1 | Duels: Asesinos vs Sheriffs",
    TextColor3 = T.text,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = titleBar
})

local closeX = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -10, 0.5, 0),
    Size = UDim2.new(0, 32, 0, 32),
    BackgroundColor3 = T.red,
    Text = "-",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    Parent = titleBar
})
Cor(closeX, 8)
New("UIStroke", { Color = Color3.new(0, 0, 0), Thickness = 1.5, Parent = closeX })

local sidebar = New("ScrollingFrame", {
    Position = UDim2.new(0, 10, 0, 58),
    Size = UDim2.new(0, T.tabSize, 1, -66),
    BackgroundTransparency = 1,
    ScrollBarThickness = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = winMain
})
New("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 18), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sidebar })
New("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), Parent = sidebar })

local contentArea = New("Frame", {
    Position = UDim2.new(0, T.tabSize + 25, 0, 58),
    Size = UDim2.new(1, -(T.tabSize + 25), 1, -66),
    BackgroundTransparency = 1,
    Parent = winMain
})

local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://4590657391"
clickSound.Volume = 1
clickSound.Parent = GUI

local function playClick() clickSound:Play() end

GUI.DescendantAdded:Connect(function(obj)
    if obj:IsA("TextButton") or obj:IsA("ImageButton") then
        obj.MouseButton1Click:Connect(playClick)
    end
end)


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

-- CREACIÓN DE PÁGINAS AVANZADAS
local pgCombat = newPage("Combat")
local pgHitbox = newPage("Hitbox")
local pgVisual = newPage("Visual")
local pgCamera = newPage("Camera")
local pgSkins = newPage("Skins")
local pgInfo = newPage("Info")

-- SECCIÓN COMBAT
local sCombat = Sec(pgCombat, "Silent Aim 360°")
Tog(sCombat, "Activar Silent Aim", false, function(v) S.saEn = v end)
Tog(sCombat, "Solo con Arma", false, function(v) S.saOnlyGun = v end)
Tog(sCombat, "Wall Check", false, function(v) S.wallCheck = v end)
Tog(sCombat, "Ocultar FOV", false, function(v) S.hideFovCircle = v end)
Sli(sCombat, "Radio de FOV", 30, 800, 150, function(v) S.saFOV = v end)
Sli(sCombat, "Fuerza Máxima", 50, 1000, 300, function(v) S.saDist = v end)
LineSlider(sCombat, "Predicción", 0, 100, 100, function(v) S.saPrediction = v end)

local sAuto = Sec(pgCombat, "Auto Combat")
Tog(sAuto, "Auto Shoot", false, function(v) S.autoShoot = v end)
Sli(sAuto, "Distancia de Disparo", 10, 1000, 250, function(v) S.shootDist = v end)

-- SECCIÓN HITBOX
local sHB = Sec(pgHitbox, "Hitbox Expander Pro")
Tog(sHB, "Activar Hitbox", false, function(v) S.hbEn = v end)
Sli(sHB, "Tamaño de Hitbox", 2, 60, 10, function(v) S.hbSize = v end)

-- SECCIÓN VISUAL
local sVisual = Sec(pgVisual, "Visuales")
Tog(sVisual, "Highlight Brillo", false, function(v) S.eP = v end)
Tog(sVisual, "ESP Líneas", false, function(v) S.espLines = v end)
Tog(sVisual, "ESP Cajas", false, function(v) S.espBoxes = v end)

-- SECCIÓN SKINS (KORBLOX & HEADLESS)
local function ApplyKorblox()
    pcall(function()
        local char = LP.Character
        if char:FindFirstChild('RightUpperLeg') then char.RightUpperLeg:Destroy() end
        if char:FindFirstChild('RightLowerLeg') then char.RightLowerLeg:Destroy() end
        if char:FindFirstChild('RightFoot') then char.RightFoot:Destroy() end
    end)
end

local function ApplyHeadless()
    pcall(function()
        local char = LP.Character
        if char:FindFirstChild('Head') then
            char.Head.Transparency = 1
            if char.Head:FindFirstChild('face') then char.Head.face.Transparency = 1 end
        end
    end)
end

local sSkins = Sec(pgSkins, "Visuales Pro")
Btn(sSkins, "Activar Korblox (Derecha)", ApplyKorblox)
Btn(sSkins, "Activar Headless", ApplyHeadless)

-- SECCIÓN INFO
local sInfo = Sec(pgInfo, "Información")
New("TextLabel", {
    Size = UDim2.new(1, 0, 0, 80),
    BackgroundTransparency = 1,
    Text = "Bienvenido a Saxzhub\nOwner: alexiz139\nScript mejorado con funciones Pro.",
    TextColor3 = T.text,
    Font = Enum.Font.GothamMedium,
    TextSize = 14,
    Parent = sInfo
})

-- SIDEBAR BUTTONS
local function addSidebarBtn(name, pageName)
    local btn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = T.panel,
        Text = name,
        TextColor3 = T.text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = sidebar
    })
    Cor(btn, 8)
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        pages[pageName].Visible = true
    end)
    return btn
end

addSidebarBtn("INFO", "Info")
addSidebarBtn("COMBAT", "Combat")
addSidebarBtn("HITBOX", "Hitbox")
addSidebarBtn("VISUAL", "Visual")
addSidebarBtn("SKINS", "Skins")




-- LOGICA DE LA INTRO
task.spawn(function()
    local loadTime = 4 -- Duración de la intro
    local startTick = tick()
    
    while tick() - startTick < loadTime do
        local progress = (tick() - startTick) / loadTime
        LoadingBarFill.Size = UDim2.fromScale(progress, 1)
        task.wait()
    end
    
    LoadingBarFill.Size = UDim2.fromScale(1, 1)
    task.wait(0.5)
    
    -- Desvanecer Intro
    TW(IntroFrame, 0.8, {BackgroundTransparency = 1})
    TW(IntroBackground, 0.8, {ImageTransparency = 1})
    TW(IntroLogo, 0.8, {ImageTransparency = 1})
    TW(IntroName, 0.8, {TextTransparency = 1})
    TW(LoadingBarContainer, 0.8, {BackgroundTransparency = 1})
    TW(LoadingBarFill, 0.8, {BackgroundTransparency = 1})
    TW(LoadingStroke, 0.8, {Transparency = 1})
    
    task.wait(0.8)
    IntroFrame:Destroy()
    
    -- Mostrar Interfaz
    pages["Info"].Visible = true
    floatIcon.Visible = true
    toggle()
end)
