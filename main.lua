-- Script Saxzhub - Tema Itachi Uchiha (VERSIÓN ULTRA-SEGURA)
-- Creado por Manus AI

--[[ Servicios ]]
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

--[[ Configuración de Assets ]]
local ITACHI_BACKGROUND_IMAGE_ID = "rbxassetid://106977920570768" 
local SHARINGAN_IMAGE_ID = "rbxassetid://7u4iBGD0znGA" 
local CROW_SOUND_ID = "rbxassetid://190872950" 
local SHARINGAN_ACTIVATION_SOUND_ID = "rbxassetid://1592708450" 
local BUTTON_CLICK_SOUND_ID = "rbxassetid://147722270" 

--[[ Configuración General ]]
local INTRO_DURATION = 3
local INTRO_TEXT = "Saxzhub"

--[[ Funciones de Utilidad ]]
local function createUI(instanceType, parent, properties)
    local ui = Instance.new(instanceType)
    for prop, value in pairs(properties) do
        ui[prop] = value
    end
    ui.Parent = parent
    return ui
end

local function playSound(soundId, volume)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = volume or 1
        sound.Parent = Workspace
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end)
end

--[[ INTRO PROTEGIDA ]]
local function showItachiIntro()
    -- Usar gethui() si está disponible (mejor para Delta), si no CoreGui
    local parent = (gethui and gethui()) or CoreGui
    
    local screenGui = createUI("ScreenGui", parent, {Name = "ItachiIntro", DisplayOrder = 9999})
    local background = createUI("Frame", screenGui, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 100
    })

    -- Sistema de Seguridad: Destruir la intro pase lo que pase en 5 segundos
    task.delay(5, function()
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        end
    end)

    local sharinganImage = createUI("ImageLabel", background, {
        Size = UDim2.new(0, 150, 0, 150),
        Position = UDim2.new(0.5, 0, 0.4, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = SHARINGAN_IMAGE_ID,
        ImageColor3 = Color3.fromRGB(255, 0, 0),
        ScaleType = Enum.ScaleType.Fit,
        ImageTransparency = 1,
        ZIndex = 101
    })

    local introText = createUI("TextLabel", background, {
        Size = UDim2.new(0.8, 0, 0.2, 0),
        Position = UDim2.new(0.5, 0, 0.65, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Text = INTRO_TEXT,
        TextColor3 = Color3.fromRGB(255, 0, 0),
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        TextTransparency = 1,
        ZIndex = 101
    })

    -- Animación simple y rápida
    pcall(function()
        playSound(SHARINGAN_ACTIVATION_SOUND_ID, 0.8)
        TweenService:Create(sharinganImage, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
        task.wait(0.5)
        
        playSound(CROW_SOUND_ID, 0.6)
        TweenService:Create(introText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
        TweenService:Create(sharinganImage, TweenInfo.new(1, Enum.EasingStyle.Quart), {Rotation = 360, Size = UDim2.new(0, 180, 0, 180)}):Play()
        task.wait(2)
        
        local fade = TweenService:Create(background, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        TweenService:Create(sharinganImage, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
        TweenService:Create(introText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        fade:Play()
        fade.Completed:Connect(function() screenGui:Destroy() end)
    end)
end

--[[ INTERFAZ PRINCIPAL ]]
local function setupItachiUI()
    local parent = (gethui and gethui()) or CoreGui
    if parent:FindFirstChild("SaxzhubUI") then parent.SaxzhubUI:Destroy() end

    local mainScreenGui = createUI("ScreenGui", parent, {Name = "SaxzhubUI", DisplayOrder = 9998})
    local mainFrame = createUI("Frame", mainScreenGui, {
        Size = UDim2.new(0, 500, 0, 300),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        BorderSizePixel = 0
    })
    createUI("UICorner", mainFrame, {CornerRadius = UDim.new(0, 8)})

    local backgroundImage = createUI("ImageLabel", mainFrame, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.5,
        Image = ITACHI_BACKGROUND_IMAGE_ID,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 0
    })
    createUI("UICorner", backgroundImage, {CornerRadius = UDim.new(0, 8)})

    local title = createUI("TextLabel", mainFrame, {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = "SAXZHUB | ITACHI THEME",
        TextColor3 = Color3.fromRGB(255, 0, 0),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        ZIndex = 2
    })

    local close = createUI("TextButton", mainFrame, {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -5, 0, 5),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(200, 0, 0),
        Text = "X",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        ZIndex = 3
    })
    createUI("UICorner", close, {CornerRadius = UDim.new(1, 0)})
    close.MouseButton1Click:Connect(function() mainScreenGui:Destroy() end)

    -- Botones de ejemplo rápidos
    local btnContainer = createUI("Frame", mainFrame, {
        Size = UDim2.new(0.9, 0, 0.7, 0),
        Position = UDim2.new(0.5, 0, 0.6, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ZIndex = 2
    })
    createUI("UIGridLayout", btnContainer, {CellSize = UDim2.new(0, 140, 0, 40), CellPadding = UDim2.new(0, 10, 0, 10)})

    local function makeBtn(name)
        local b = createUI("TextButton", btnContainer, {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BackgroundTransparency = 0.2,
            Text = name,
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.GothamBold,
            TextSize = 12
        })
        createUI("UICorner", b, {CornerRadius = UDim.new(0, 6)})
        b.MouseButton1Click:Connect(function() playSound(BUTTON_CLICK_SOUND_ID, 0.5) end)
    end

    makeBtn("Amaterasu Aim")
    makeBtn("Sharingan ESP")
    makeBtn("Body Flicker")
    makeBtn("Izanagi Misc")
end

--[[ ANTI-LAG LIGERO ]]
local function applyAntiLag()
    pcall(function()
        Lighting.GlobalShadows = false
        if Lighting:FindFirstChildOfClass("Sky") then Lighting:FindFirstChildOfClass("Sky"):Destroy() end
        task.spawn(function()
            local d = game:GetDescendants()
            for i, v in pairs(d) do
                if v:IsA("BasePart") then v.Material = Enum.Material.Plastic; v.CastShadow = false end
                if i % 500 == 0 then task.wait() end
            end
        end)
    end)
end

--[[ FPS ]]
local function setupFPS()
    local parent = (gethui and gethui()) or CoreGui
    local screen = createUI("ScreenGui", parent, {Name = "SaxzFPS"})
    local label = createUI("TextLabel", screen, {
        Size = UDim2.new(0, 80, 0, 25),
        Position = UDim2.new(1, -85, 0, 10),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.7,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        Font = Enum.Font.GothamBold
    })
    createUI("UICorner", label, {CornerRadius = UDim.new(0, 4)})
    RunService.RenderStepped:Connect(function()
        local fps = math.floor(1 / RunService.Heartbeat:Wait() + 0.5)
        label.Text = "FPS: " .. fps
        label.TextColor3 = Color3.fromHSV((tick() * 0.1) % 1, 1, 1)
    end)
end

--[[ EJECUCIÓN SEGURA ]]
task.spawn(function()
    pcall(showItachiIntro)
end)
applyAntiLag()
setupFPS()
setupItachiUI()
