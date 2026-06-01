--[[ 
    Saxzhub Duels Script + Skins (Failsafe Debug)
    Owner: alexiz139
]]

print('Saxzhub: Iniciando Script...')

local Players          = game:GetService('Players')
local TweenService     = game:GetService('TweenService')
local RunService       = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local Workspace        = game:GetService('Workspace')
local LP               = Players.LocalPlayer
local Cam              = Workspace.CurrentCamera

local T = {
    bg      = Color3.fromRGB(5, 5, 5),     
    panel   = Color3.fromRGB(15, 15, 15), 
    panel2  = Color3.fromRGB(22, 22, 22),  
    acc     = Color3.fromRGB(255, 255, 255), 
    text    = Color3.fromRGB(250, 250, 250),
    red     = Color3.fromRGB(200, 30, 30),
    darkRed = Color3.fromRGB(30, 30, 30),
    tabSize = 160
}

local S = { saEn = false, saFOV = 150, saPart = 'Head', hbEn = false, hbSize = 10, eP = false, espBoxes = false, espLines = false, espColor = Color3.fromRGB(220, 20, 20) }

local function New(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do o[k] = v end
    return o
end

local function Cor(obj, r)
    local c = Instance.new('UICorner')
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
end

local function TW(obj, t, props)
    local anim = TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    anim:Play()
    return anim
end

-- GUI BASE
local GUI = New('ScreenGui', { Name = 'Saxzhub_GUI', ResetOnSpawn = false, Parent = (gethui and gethui() or game:GetService('CoreGui')) })
print('Saxzhub: GUI Base Creada')

-- SKINS LOGIC
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

-- WINDOW
local winMain = New('Frame', { Name = 'Window', AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(0, 600, 0, 320), BackgroundColor3 = T.bg, Visible = false, Parent = GUI })
Cor(winMain, 10)

local titleBar = New('Frame', { Position = UDim2.new(0, 8, 0, 8), Size = UDim2.new(1, -16, 0, 42), BackgroundColor3 = Color3.fromRGB(25, 25, 25), Parent = winMain })
Cor(titleBar, 12)

local titleText = New('TextLabel', { Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(0, 300, 1, 0), BackgroundTransparency = 1, Text = 'Saxzhub | Duels', TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, Parent = titleBar })

local closeX = New('TextButton', { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.new(0, 32, 0, 32), BackgroundColor3 = T.red, Text = '-', TextColor3 = T.text, Font = Enum.Font.GothamBold, Parent = titleBar })
Cor(closeX, 8)

local sidebar = New('ScrollingFrame', { Position = UDim2.new(0, 10, 0, 58), Size = UDim2.new(0, T.tabSize, 1, -66), BackgroundTransparency = 1, ScrollBarThickness = 0, Parent = winMain })
New('UIListLayout', { Padding = UDim.new(0, 10), Parent = sidebar })

local contentArea = New('Frame', { Position = UDim2.new(0, T.tabSize + 25, 0, 58), Size = UDim2.new(1, -(T.tabSize + 25), 1, -66), BackgroundTransparency = 1, Parent = winMain })

local pages = {}
local function newPage(name)
    local pg = New('ScrollingFrame', { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 0, Parent = contentArea })
    New('UIListLayout', { Padding = UDim.new(0, 10), Parent = pg })
    pages[name] = pg
    return pg
end

local function Sec(par, ttl)
    local c = New('Frame', { Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = T.panel2, Parent = par })
    Cor(c, 5)
    New('TextLabel', { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = ttl, TextColor3 = T.acc, Font = Enum.Font.GothamBold, TextSize = 12, Parent = c })
    return par
end

local function Btn(par, lbl, cb)
    local b = New('TextButton', { Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = T.panel2, Text = lbl, TextColor3 = T.text, Font = Enum.Font.GothamBold, Parent = par })
    Cor(b, 5)
    b.MouseButton1Click:Connect(cb)
end

local function Tog(par, lbl, def, cb)
    local b = New('TextButton', { Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = def and Color3.fromRGB(0, 200, 0) or T.red, Text = lbl, TextColor3 = T.text, Font = Enum.Font.GothamBold, Parent = par })
    Cor(b, 5)
    local active = def
    b.MouseButton1Click:Connect(function()
        active = not active
        b.BackgroundColor3 = active and Color3.fromRGB(0, 200, 0) or T.red
        cb(active)
    end)
end

-- PAGES SETUP
local infoPage = newPage('Info')
Sec(infoPage, 'INFO')
New('TextLabel', { Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1, Text = 'Owner: alexiz139', TextColor3 = T.text, Parent = infoPage })

local combatPage = newPage('Combat')
Sec(combatPage, 'COMBAT')
Tog(combatPage, 'Silent Aim', false, function(v) S.saEn = v end)
Tog(combatPage, 'Hitbox', false, function(v) S.hbEn = v end)

local skinsPage = newPage('Skins')
Sec(skinsPage, 'SKINS')
Btn(skinsPage, 'Korblox', ApplyKorblox)
Btn(skinsPage, 'Headless', ApplyHeadless)

-- SIDEBAR
local function addTab(n, p)
    local b = New('TextButton', { Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = T.panel2, Text = n, TextColor3 = T.text, Font = Enum.Font.GothamBold, Parent = sidebar })
    Cor(b, 5)
    b.MouseButton1Click:Connect(function()
        for _, pg in pairs(pages) do pg.Visible = false end
        pages[p].Visible = true
    end)
end
addTab('INFO', 'Info')
addTab('COMBAT', 'Combat')
addTab('SKINS', 'Skins')
pages['Info'].Visible = true

-- FLOAT ICON
local floatIcon = New('ImageButton', { Name = 'FloatIcon', Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 10, 0.5, -25), Image = 'rbxassetid://83175093174782', Visible = false, Parent = GUI })
Cor(floatIcon, 25)
floatIcon.MouseButton1Click:Connect(function() winMain.Visible = not winMain.Visible end)
closeX.MouseButton1Click:Connect(function() winMain.Visible = false end)

-- INTRO
local IntroFrame = New('Frame', { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0,0,0), ZIndex = 100, Parent = GUI })
local IntroLogo = New('ImageLabel', { Size = UDim2.new(0, 100, 0, 100), AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5, 0.4), Image = 'rbxassetid://83175093174782', BackgroundTransparency = 1, ZIndex = 101, Parent = IntroFrame })
local IntroText = New('TextLabel', { Size = UDim2.new(0, 200, 0, 50), AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5, 0.55), Text = 'Saxzhub', TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 30, BackgroundTransparency = 1, ZIndex = 101, Parent = IntroFrame })

task.spawn(function()
    print('Saxzhub: Iniciando Intro...')
    task.wait(3)
    TW(IntroFrame, 1, { BackgroundTransparency = 1 })
    TW(IntroLogo, 1, { ImageTransparency = 1 })
    TW(IntroText, 1, { TextTransparency = 1 })
    task.wait(1)
    IntroFrame:Destroy()
    floatIcon.Visible = true
    print('Saxzhub: Script Listo!')
end)

-- AIMBOT / ESP LOGIC (Simplified for Failsafe)
RunService.RenderStepped:Connect(function()
    if S.saEn then
        -- Aimbot Logic here
    end
end)
