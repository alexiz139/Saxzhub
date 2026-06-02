-- Script Saxzhub - Tema Itachi Uchiha
-- Creado por Manus AI

--[[ Configuración de Assets (Roblox Asset IDs) ]]
local ITACHI_BACKGROUND_IMAGE_ID = "rbxassetid://106977920570768" -- Usar un ID de fondo de Itachi (ej. de la imagen 4 o 6)
local SHARINGAN_IMAGE_ID = "rbxassetid://7u4iBGD0znGA" -- Mangekyou Sharingan (Index 7)
local CROW_SOUND_ID = "rbxassetid://190872950" -- Crows Cawing
local SHARINGAN_ACTIVATION_SOUND_ID = "rbxassetid://1592708450" -- Itachi Mangekyou Sharingan Sound Effect
local BUTTON_CLICK_SOUND_ID = "rbxassetid://147722270" -- Air Woosh Long

--[[ Configuración General ]]
local INTRO_DURATION = 4 -- Duración de la intro en segundos
local INTRO_TEXT = "Saxzhub"
local INTRO_TEXT_COLOR = Color3.fromRGB(255, 0, 0) -- Rojo
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
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = volume or 1
    sound.Parent = game.Workspace -- O un lugar más apropiado si se prefiere
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
end

--[[ Intro "Sharingan Activation" ]]
local function showItachiIntro()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = createUI("ScreenGui", playerGui, {Name = "ItachiIntro", DisplayOrder = 999})
    local background = createUI("Frame", screenGui, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0
    })

    -- Sharingan Image
    local sharinganImage = createUI("ImageLabel", background, {
        Size = UDim2.new(0.3, 0, 0.3, 0),
        Position = UDim2.new(0.5, 0, 0.4, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = SHARINGAN_IMAGE_ID,
        ImageColor3 = Color3.fromRGB(255, 0, 0), -- Rojo Sharingan
        ScaleType = Enum.ScaleType.Fit
    })
    sharinganImage.ImageTransparency = 1
    sharinganImage.Rotation = 0

    -- Saxzhub Text
    local introText = createUI("TextLabel", background, {
        Size = UDim2.new(0.8, 0, 0.2, 0),
        Position = UDim2.new(0.5, 0, 0.65, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Text = INTRO_TEXT,
        TextColor3 = INTRO_TEXT_COLOR,
        TextScaled = true,
        Font = Enum.Font.SourceSansBold, -- Considerar una fuente más "anime" si hay disponible
        BorderSizePixel = 0
    })
    introText.TextTransparency = 1
    introText.TextStrokeTransparency = 1
    introText.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)

    -- Loading Bar
    local loadingBarBackground = createUI("Frame", background, {
        Size = UDim2.new(0.6, 0, 0.02, 0),
        Position = UDim2.new(0.5, 0, 0.8, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0
    })
    local loadingBarFill = createUI("Frame", loadingBarBackground, {
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0), -- Rojo para la barra de carga
        BorderSizePixel = 0
    })
    loadingBarBackground.BackgroundTransparency = 1
    loadingBarFill.BackgroundTransparency = 1

    -- Animación de la Intro
    -- Paso 1: Sharingan aparece y sonido de activación
    playSound(SHARINGAN_ACTIVATION_SOUND_ID, 0.8)
    TweenService:Create(sharinganImage, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
    task.wait(0.5)

    -- Paso 2: Sharingan pulsa y texto Saxzhub aparece
    TweenService:Create(sharinganImage, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.35, 0, 0.35, 0), Rotation = 360}):Play()
    TweenService:Create(introText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0, TextStrokeTransparency = 0}):Play()
    playSound(CROW_SOUND_ID, 0.7)
    task.wait(1)

    -- Paso 3: Barra de carga y fade out
    loadingBarBackground.BackgroundTransparency = 0
    loadingBarFill.BackgroundTransparency = 0
    for i = 0, 100 do
        local progress = i / 100
        loadingBarFill:TweenSize(UDim2.new(progress, 0, 1, 0), "Out", "Quad", 0.1, true)
        task.wait(INTRO_DURATION / 100)
    end

    TweenService:Create(screenGui, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
    task.wait(0.5)
    screenGui:Destroy()
end

--[[ Interfaz Principal "Uchiha Elite" ]]
local function setupItachiUI()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local mainScreenGui = createUI("ScreenGui", playerGui, {Name = "SaxzhubUI", DisplayOrder = 998})
    local mainFrame = createUI("Frame", mainScreenGui, {
        Size = UDim2.new(0.6, 0, 0.8, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0
    })
    -- Fondo de Itachi
    local backgroundImage = createUI("ImageLabel", mainFrame, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = ITACHI_BACKGROUND_IMAGE_ID,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = -1 -- Para que esté detrás de todo
    })

    -- Borde de neón rojo (Amaterasu)
    local borderFrame = createUI("Frame", mainFrame, {
        Size = UDim2.new(1, 4, 1, 4),
        Position = UDim2.new(0.5, -2, 0.5, -2),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        ZIndex = -2 -- Detrás del fondo
    })

    -- Aquí irán los botones y paneles de opciones
    -- Barra lateral para pestañas
    local sidebar = createUI("Frame", mainFrame, {
        Size = UDim2.new(0.25, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0
    })

    local function createTab(name, pos, callback)
        local tab = createUI("TextButton", sidebar, {
            Size = UDim2.new(0.9, 0, 0.1, 0),
            Position = UDim2.new(0.05, 0, pos, 0),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            BackgroundTransparency = 0.2,
            Text = name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextScaled = true,
            Font = Enum.Font.SourceSansBold,
            BorderSizePixel = 0
        })
        createUI("UICorner", tab, {CornerRadius = UDim.new(0, 6)})

        tab.MouseEnter:Connect(function()
            playSound(BUTTON_CLICK_SOUND_ID, 0.3)
            TweenService:Create(tab, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 0, 0), BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        end)
        tab.MouseLeave:Connect(function()
            TweenService:Create(tab, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200), BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        end)
        tab.MouseButton1Click:Connect(function()
            playSound(BUTTON_CLICK_SOUND_ID, 0.6)
            callback()
        end)
        return tab
    end

    -- Contenedor de opciones
    local container = createUI("ScrollingFrame", mainFrame, {
        Size = UDim2.new(0.7, 0, 0.9, 0),
        Position = UDim2.new(0.28, 0, 0.05, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
    })
    createUI("UIListLayout", container, {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder})

    -- Pestañas de ejemplo
    createTab("Amaterasu Aim", 0.1, function() print("Tab Combat") end)
    createTab("Sharingan Vision", 0.22, function() print("Tab Visuals") end)
    createTab("Body Flicker", 0.34, function() print("Tab Movement") end)
    createTab("Izanagi Misc", 0.46, function() print("Tab Misc") end)

    -- Botón de cerrar con efecto
    local closeButton = createUI("TextButton", mainFrame, {
        Size = UDim2.new(0.05, 0, 0.05, 0),
        Position = UDim2.new(0.98, 0, 0.02, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(200, 0, 0),
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSansBold,
        TextScaled = true,
        BorderSizePixel = 0
    })
    createUI("UICorner", closeButton, {CornerRadius = UDim.new(1, 0)})
    closeButton.MouseButton1Click:Connect(function()
        playSound(BUTTON_CLICK_SOUND_ID, 0.8)
        mainScreenGui:Destroy()
    end)

    print("Interfaz Uchiha Elite cargada.")
end

--[[ Sistema Anti-Lag Pro (Grey Sky / Modo Cartón) - Mantener la funcionalidad base ]]
local function optimize(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("Texture") or child:IsA("Decal") then child:Destroy() end
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Trail") then
            obj.Enabled = false
        end
    end)
end

local function applyAntiLagPro()
    game.Lighting.GlobalShadows = false
    game.Lighting.Brightness = 0.5
    game.Lighting.Ambient = Color3.fromRGB(100, 100, 100)
    game.Lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
    if game.Lighting:FindFirstChildOfClass("Sky") then game.Lighting:FindFirstChildOfClass("Sky"):Destroy() end
    game.Workspace.Terrain.Decoration = false
    game.Workspace.Terrain.WaterTransparency = 1

    task.spawn(function()
        local descendants = game:GetDescendants()
        for i, v in pairs(descendants) do
            optimize(v)
            if i % 100 == 0 then task.wait() end
        end
    end)

    game.DescendantAdded:Connect(optimize)
end

--[[ Contador de FPS con RGB (Botón Pequeño y Ligero) ]]
local function setupFPSCounter()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = createUI("ScreenGui", playerGui, {Name = "FPSCounter", DisplayOrder = 998})
    local fpsButton = createUI("TextLabel", screenGui, {
        Size = UDim2.new(0.08, 0, 0.03, 0),
        Position = UDim2.new(0.9, 0, 0.02, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.7,
        Text = FPS_BUTTON_TEXT .. ": Loading...",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextScaled = true,
        Font = Enum.Font.SourceSansBold,
        BorderSizePixel = 0
    })

    local hue = 0
    game:GetService("RunService").RenderStepped:Connect(function()
        local currentFps = math.floor(1 / game:GetService("RunService").Heartbeat:Wait() + 0.5)
        fpsButton.Text = FPS_BUTTON_TEXT .. ": " .. currentFps

        hue = (hue + 0.01) % 1
        fpsButton.TextColor3 = Color3.fromHSV(hue, 1, 1)
    end)
end

--[[ Ejecución del Script ]]
showItachiIntro()
applyAntiLagPro()
setupFPSCounter()
setupItachiUI()

print("Script Saxzhub - Tema Itachi Uchiha cargado exitosamente.")
