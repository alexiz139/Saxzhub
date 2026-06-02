-- Script Saxzhub - Tema Itachi Uchiha (VERSIÓN CORREGIDA)
-- Creado por Manus AI

--[[ Librerías de Roblox ]]
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

--[[ Configuración de Assets (Roblox Asset IDs) ]]
local ITACHI_BACKGROUND_IMAGE_ID = "rbxassetid://106977920570768" 
local SHARINGAN_IMAGE_ID = "rbxassetid://7u4iBGD0znGA" 
local CROW_SOUND_ID = "rbxassetid://190872950" 
local SHARINGAN_ACTIVATION_SOUND_ID = "rbxassetid://1592708450" 
local BUTTON_CLICK_SOUND_ID = "rbxassetid://147722270" 

--[[ Configuración General ]]
local INTRO_DURATION = 4 
local INTRO_TEXT = "Saxzhub"
local INTRO_TEXT_COLOR = Color3.fromRGB(255, 0, 0)
local FPS_BUTTON_TEXT = "FPS"

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

--[[ Intro "Sharingan Activation" ]]
local function showItachiIntro()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = createUI("ScreenGui", playerGui, {Name = "ItachiIntro", DisplayOrder = 999})
    local background = createUI("Frame", screenGui, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0
    })

    local sharinganImage = createUI("ImageLabel", background, {
        Size = UDim2.new(0.3, 0, 0.3, 0),
        Position = UDim2.new(0.5, 0, 0.4, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = SHARINGAN_IMAGE_ID,
        ImageColor3 = Color3.fromRGB(255, 0, 0),
        ScaleType = Enum.ScaleType.Fit,
        ImageTransparency = 1,
        Rotation = 0
    })

    local introText = createUI("TextLabel", background, {
        Size = UDim2.new(0.8, 0, 0.2, 0),
        Position = UDim2.new(0.5, 0, 0.65, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Text = INTRO_TEXT,
        TextColor3 = INTRO_TEXT_COLOR,
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        TextTransparency = 1,
        TextStrokeTransparency = 1,
        TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
    })

    local loadingBarBackground = createUI("Frame", background, {
        Size = UDim2.new(0.6, 0, 0.015, 0),
        Position = UDim2.new(0.5, 0, 0.8, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    })
    local loadingBarFill = createUI("Frame", loadingBarBackground, {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    })

    -- Animación de Seguridad (Si algo falla, la intro se quita en 6 segundos)
    task.delay(6, function()
        if screenGui and screenGui.Parent then screenGui:Destroy() end
    end)

    -- Ejecución de Animaciones
    playSound(SHARINGAN_ACTIVATION_SOUND_ID, 0.8)
    TweenService:Create(sharinganImage, TweenInfo.new(0.8), {ImageTransparency = 0}):Play()
    task.wait(0.8)

    TweenService:Create(sharinganImage, TweenInfo.new(1.5, Enum.EasingStyle.Quart), {Size = UDim2.new(0.35, 0, 0.35, 0), Rotation = 360}):Play()
    TweenService:Create(introText, TweenInfo.new(1), {TextTransparency = 0, TextStrokeTransparency = 0}):Play()
    playSound(CROW_SOUND_ID, 0.6)
    task.wait(1)

    loadingBarBackground.BackgroundTransparency = 0
    loadingBarFill.BackgroundTransparency = 0
    local tweenLoad = TweenService:Create(loadingBarFill, TweenInfo.new(INTRO_DURATION, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    tweenLoad:Play()
    tweenLoad.Completed:Wait()

    task.wait(0.2)
    local fadeOut = TweenService:Create(background, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    TweenService:Create(sharinganImage, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
    TweenService:Create(introText, TweenInfo.new(0.5), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
    fadeOut:Play()
    fadeOut.Completed:Wait()
    
    screenGui:Destroy()
end

--[[ Interfaz Principal "Uchiha Elite" ]]
local function setupItachiUI()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local mainScreenGui = createUI("ScreenGui", playerGui, {Name = "SaxzhubUI", DisplayOrder = 998})
    local mainFrame = createUI("Frame", mainScreenGui, {
        Size = UDim2.new(0, 550, 0, 350),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0
    })
    createUI("UICorner", mainFrame, {CornerRadius = UDim.new(0, 10)})

    local backgroundImage = createUI("ImageLabel", mainFrame, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.4,
        Image = ITACHI_BACKGROUND_IMAGE_ID,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 0
    })
    createUI("UICorner", backgroundImage, {CornerRadius = UDim.new(0, 10)})

    local sidebar = createUI("Frame", mainFrame, {
        Size = UDim2.new(0.28, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(5, 5, 5),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        ZIndex = 2
    })
    createUI("UICorner", sidebar, {CornerRadius = UDim.new(0, 10)})

    local function createTab(name, pos, callback)
        local tab = createUI("TextButton", sidebar, {
            Size = UDim2.new(0.85, 0, 0.08, 0),
            Position = UDim2.new(0.5, 0, 0.1 + (pos * 0.1), 0),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            BackgroundTransparency = 0.3,
            Text = name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            BorderSizePixel = 0,
            ZIndex = 3
        })
        createUI("UICorner", tab, {CornerRadius = UDim.new(0, 4)})

        tab.MouseEnter:Connect(function()
            playSound(BUTTON_CLICK_SOUND_ID, 0.2)
            TweenService:Create(tab, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 0, 0), BackgroundColor3 = Color3.fromRGB(40, 0, 0)}):Play()
        end)
        tab.MouseLeave:Connect(function()
            TweenService:Create(tab, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200), BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        end)
        tab.MouseButton1Click:Connect(function()
            playSound(BUTTON_CLICK_SOUND_ID, 0.5)
            callback()
        end)
    end

    createTab("Amaterasu Aim", 0, function() print("Combat") end)
    createTab("Sharingan Vision", 1, function() print("Visuals") end)
    createTab("Body Flicker", 2, function() print("Movement") end)
    createTab("Izanagi Misc", 3, function() print("Misc") end)

    local closeButton = createUI("TextButton", mainFrame, {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -10, 0, 10),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(150, 0, 0),
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        ZIndex = 5
    })
    createUI("UICorner", closeButton, {CornerRadius = UDim.new(1, 0)})
    closeButton.MouseButton1Click:Connect(function()
        playSound(BUTTON_CLICK_SOUND_ID, 0.6)
        mainScreenGui:Destroy()
    end)
end

--[[ Sistema Anti-Lag Pro ]]
local function applyAntiLagPro()
    Lighting.GlobalShadows = false
    Lighting.Brightness = 0.5
    if Lighting:FindFirstChildOfClass("Sky") then Lighting:FindFirstChildOfClass("Sky"):Destroy() end
    Workspace.Terrain.Decoration = false

    task.spawn(function()
        for i, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") then
                v.Enabled = false
            end
            if i % 200 == 0 then task.wait() end
        end
    end)
end

--[[ Contador de FPS ]]
local function setupFPSCounter()
    local screenGui = createUI("ScreenGui", Players.LocalPlayer.PlayerGui, {Name = "FPSCounter"})
    local fpsLabel = createUI("TextLabel", screenGui, {
        Size = UDim2.new(0, 100, 0, 30),
        Position = UDim2.new(1, -110, 0, 10),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.7,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold
    })
    createUI("UICorner", fpsLabel, {CornerRadius = UDim.new(0, 6)})

    RunService.RenderStepped:Connect(function()
        local fps = math.floor(1 / RunService.Heartbeat:Wait() + 0.5)
        fpsLabel.Text = FPS_BUTTON_TEXT .. ": " .. fps
        fpsLabel.TextColor3 = Color3.fromHSV((tick() * 0.1) % 1, 1, 1)
    end)
end

--[[ Ejecución ]]
task.spawn(showItachiIntro)
applyAntiLagPro()
setupFPSCounter()
setupItachiUI()
