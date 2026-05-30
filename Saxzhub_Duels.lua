--[[ 
    Saxzhub Duels Script
    Owner: alexiz139
    Credits: alexiz139
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
    Image = "rbxassetid://102909282369466",
    ScaleType = Enum.ScaleType.Crop,
    BackgroundTransparency = 1,
    ZIndex = 101,
    Parent = IntroFrame
})

local IntroLogo = New("ImageLabel", {
    Size = UDim2.new(0, 150, 0, 150),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.4),
    Image = "rbxassetid://83175093174782",
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

local pages = {}
local function newPage(name)
    local pg = New("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = contentArea
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
    local btnPlus = New("TextButton", { Position = UDim2.new(1, -58, 0, 25), Size = UDim2.new(0, 26, 0, 26), BackgroundColor3 = T.panel, Text = "+", TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 18, Parent = row })
    styleButton(btnPlus)
    local dragging = false
    local function update(input)
        local per = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val = math.floor(mn + (per * (mx - mn)))
        fill.Size = UDim2.fromScale(per, 1); thumb.Position = UDim2.new(per, -10, 0.5, -10); valueLabel.Text = tostring(val); cb(val)
    end
    thumb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    btnMinus.MouseButton1Click:Connect(function() local val = math.clamp(tonumber(valueLabel.Text) - 1, mn, mx); local per = (val - mn) / (mx - mn); fill.Size = UDim2.fromScale(per, 1); thumb.Position = UDim2.new(per, -10, 0.5, -10); valueLabel.Text = tostring(val); cb(val) end)
    btnPlus.MouseButton1Click:Connect(function() local val = math.clamp(tonumber(valueLabel.Text) + 1, mn, mx); local per = (val - mn) / (mx - mn); fill.Size = UDim2.fromScale(per, 1); thumb.Position = UDim2.new(per, -10, 0.5, -10); valueLabel.Text = tostring(val); cb(val) end)
end

local function Btn(par, lbl, cb)
    local btn = New("TextButton", { Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = T.panel2, Text = lbl, TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 14, Parent = par })
    Cor(btn, 10)
    New("UIStroke", { Color = Color3.fromRGB(0,0,0), Thickness = 2, Parent = btn })
    btn.MouseButton1Click:Connect(cb)
    btn.MouseEnter:Connect(function() TW(btn, 0.2, {BackgroundColor3 = T.acc, TextColor3 = Color3.new(0,0,0)}) end)
    btn.MouseLeave:Connect(function() TW(btn, 0.2, {BackgroundColor3 = T.panel2, TextColor3 = T.text}) end)
end

local function isEnemy(p)
    if not p or not LP then return false end
    if p.Team ~= LP.Team then return true end
    return false
end

local function applyESP(p)
    if p == LP then return end
    local char = p.Character or p.CharacterAdded:Wait()
    local highlight = New("Highlight", { Name = "ESPHighlight", Parent = char, FillTransparency = 0.5, OutlineTransparency = 0 })
    local line = Drawing.new("Line"); line.Visible = false; line.Thickness = 1.5; line.Transparency = 1
    local box = Drawing.new("Square"); box.Visible = false; box.Thickness = 1.5; box.Filled = false
    RunService.RenderStepped:Connect(function()
        if not char or not char:FindFirstChild("HumanoidRootPart") then highlight.Enabled = false; line.Visible = false; box.Visible = false; return end
        local isE = isEnemy(p)
        highlight.Enabled = S.eP and isE; highlight.FillColor = S.espColor; highlight.OutlineColor = S.espColor
        local hrp = char.HumanoidRootPart; local pos, onScreen = Cam:WorldToViewportPoint(hrp.Position)
        if onScreen and isE then
            if S.espLines then line.From = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y); line.Color = S.espColor; line.Visible = true else line.Visible = false end
            if S.espBoxes then local size = (Cam:WorldToViewportPoint(hrp.Position + Vector3.new(2, 3, 0)).Y - Cam:WorldToViewportPoint(hrp.Position + Vector3.new(-2, -3, 0)).Y); box.Size = Vector2.new(size * 0.6, size); box.Position = Vector2.new(pos.X - box.Size.X / 2, pos.Y - box.Size.Y / 2); box.Color = S.espColor; box.Visible = true else box.Visible = false end
        else line.Visible = false; box.Visible = false end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do task.spawn(function() applyESP(p) end) end
Players.PlayerAdded:Connect(function(p) task.spawn(function() applyESP(p) end) end)

local fovCircle = Drawing.new("Circle"); fovCircle.Thickness = 1.5; fovCircle.NumSides = 64; fovCircle.Filled = false; fovCircle.Transparency = 1
RunService.RenderStepped:Connect(function()
    fovCircle.Visible = not S.hideFovCircle and S.saEn; fovCircle.Radius = S.saFOV; fovCircle.Position = UserInputService:GetMouseLocation(); fovCircle.Color = S.espColor
    if S.fovEn then Cam.FieldOfView = S.fovVal end
    if LP.Character and LP.Character:FindFirstChild("Humanoid") and S.spdEn then LP.Character.Humanoid.WalkSpeed = S.spdVal end
    if S.ncEn and LP.Character then for _, part in ipairs(LP.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end
end)

local function getClosestPlayer()
    local closest, dist = nil, S.saFOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild(S.saPart) and isEnemy(p) then
            local pos, onScreen = Cam:WorldToViewportPoint(p.Character[S.saPart].Position)
            if onScreen then local d = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude; if d < dist then closest = p; dist = d end end
        end
    end
    return closest
end

local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}; local method = getnamecallmethod()
    if not checkcaller() and method == "FireServer" and S.saEn then
        if self.Name == "RemoteEvent" or self.Name == "Shoot" or self.Name == "Fire" then
            local target = getClosestPlayer()
            if target then local prediction = target.Character[S.saPart].Velocity * (S.saPrediction / 1000); args[1] = target.Character[S.saPart].Position + prediction; return oldNamecall(self, unpack(args)) end
        end
    end
    return oldNamecall(self, ...)
end)

task.spawn(function()
    while task.wait(0.1) do
        if S.hbEn then for _, p in ipairs(Players:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and isEnemy(p) then p.Character.HumanoidRootPart.Size = Vector3.new(S.hbSize, S.hbSize, S.hbSize); p.Character.HumanoidRootPart.Transparency = 0.7; p.Character.HumanoidRootPart.CanCollide = false end end end
    end
end)

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
