-- Script Saxzhub - Tema Itachi Uchiha (VERSIÓN PREMIUM)
-- Creado por Manus AI

--[[ Servicios ]]
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

--[[ Configuración de Assets (Roblox Asset IDs) ]]
-- Imágenes
local ITACHI_BACKGROUND_IMAGE_ID = "rbxassetid://106977920570768" -- Fondo de Itachi (placeholder)
local SHARINGAN_IMAGE_ID = "rbxassetid://7u4iBGD0znGA" -- Mangekyou Sharingan
local CROW_IMAGE_ID = "rbxassetid://16005555368" -- Placeholder para cuervo si se usa como imagen

-- Sonidos
local CROW_SOUND_ID = "rbxassetid://190872950" -- Crows Cawing
local SHARINGAN_ACTIVATION_SOUND_ID = "rbxassetid://1592708450" -- Itachi Mangekyou Sharingan Sound Effect
local BUTTON_CLICK_SOUND_ID = "rbxassetid://147722270" -- Air Woosh Long
local BUTTON_HOVER_SOUND_ID = "rbxassetid://147722270" -- Usar el mismo por ahora, buscar uno más suave si es necesario

--[[ Configuración General ]]
local INTRO_DURATION = 4 -- Duración de la intro en segundos
local INTRO_TEXT = "Saxzhub"
local ACCENT_COLOR = Color3.fromRGB(255, 0, 0) -- Rojo de Itachi / Sharingan
local DARK_COLOR = Color3.fromRGB(15, 15, 15)
local MEDIUM_COLOR = Color3.fromRGB(30, 30, 30)
local LIGHT_TEXT_COLOR = Color3.fromRGB(200, 200, 200)

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

--[[ INTRO PREMIUM "SHARINGAN ACTIVATION" ]]
local function showItachiIntroPremium()
    local parent = (gethui and gethui()) or CoreGui
    
    local screenGui = createUI("ScreenGui", parent, {Name = "ItachiIntroPremium", DisplayOrder = 9999})
    local background = createUI("Frame", screenGui, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 100
    })

    -- Sistema de Seguridad: Destruir la intro pase lo que pase en 5 segundos
    task.delay(INTRO_DURATION + 1, function()
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        end
    end)

    local sharinganImage = createUI("ImageLabel", background, {
        Size = UDim2.new(0, 0, 0, 0), -- Empieza pequeño
        Position = UDim2.new(0.5, 0, 0.4, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = SHARINGAN_IMAGE_ID,
        ImageColor3 = ACCENT_COLOR,
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
        TextColor3 = ACCENT_COLOR,
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        TextTransparency = 1,
        TextStrokeTransparency = 1,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0), -- Borde negro para el texto
        ZIndex = 101
    })

    local loadingBarBackground = createUI("Frame", background, {
        Size = UDim2.new(0.6, 0, 0.015, 0),
        Position = UDim2.new(0.5, 0, 0.8, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = MEDIUM_COLOR,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ZIndex = 101
    })
    createUI("UICorner", loadingBarBackground, {CornerRadius = UDim.new(0, 4)})

    local loadingBarFill = createUI("Frame", loadingBarBackground, {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = ACCENT_COLOR,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ZIndex = 102
    })
    createUI("UICorner", loadingBarFill, {CornerRadius = UDim.new(0, 4)})

    -- Animación de la Intro
    pcall(function()
        -- Paso 1: Sharingan aparece y crece
        playSound(SHARINGAN_ACTIVATION_SOUND_ID, 0.8)
        TweenService:Create(sharinganImage, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {ImageTransparency = 0, Size = UDim2.new(0, 150, 0, 150)}):Play()
        task.wait(0.8)

        -- Paso 2: Sharingan rota y texto Saxzhub aparece
        playSound(CROW_SOUND_ID, 0.6)
        TweenService:Create(sharinganImage, TweenInfo.new(1.5, Enum.EasingStyle.Quart), {Rotation = 720, Size = UDim2.new(0, 180, 0, 180)}):Play()
        TweenService:Create(introText, TweenInfo.new(1), {TextTransparency = 0, TextStrokeTransparency = 0}):Play()
        task.wait(1.5)

        -- Paso 3: Barra de carga y fade out
        loadingBarBackground.BackgroundTransparency = 0
        loadingBarFill.BackgroundTransparency = 0
        local tweenLoad = TweenService:Create(loadingBarFill, TweenInfo.new(INTRO_DURATION - 2.3, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
        tweenLoad:Play()
        tweenLoad.Completed:Wait()

        local fadeOutInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(background, fadeOutInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(sharinganImage, fadeOutInfo, {ImageTransparency = 1}):Play()
        TweenService:Create(introText, fadeOutInfo, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
        TweenService:Create(loadingBarBackground, fadeOutInfo, {BackgroundTransparency = 1}):Play()
        task.wait(0.7)
        
        screenGui:Destroy()
    end)
end

--[[ INTERFAZ PRINCIPAL "UCHIHA ELITE" ]]
local function setupItachiUIPrem()
    local parent = (gethui and gethui()) or CoreGui
    if parent:FindFirstChild("SaxzhubUI") then parent.SaxzhubUI:Destroy() end

    local mainScreenGui = createUI("ScreenGui", parent, {Name = "SaxzhubUI", DisplayOrder = 9998})
    local mainFrame = createUI("Frame", mainScreenGui, {
        Size = UDim2.new(0, 650, 0, 450),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = DARK_COLOR,
        BackgroundTransparency = 0.05, -- Casi opaco para un look premium
        BorderSizePixel = 0
    })
    createUI("UICorner", mainFrame, {CornerRadius = UDim.new(0, 12)})

    -- Fondo de Itachi con gradiente
    local backgroundImage = createUI("ImageLabel", mainFrame, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.6,
        Image = ITACHI_BACKGROUND_IMAGE_ID,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 0
    })
    createUI("UICorner", backgroundImage, {CornerRadius = UDim.new(0, 12)})

    local gradient = createUI("UIGradient", backgroundImage, {
        Color = TweenService.Create(Instance.new("ColorSequence"), TweenInfo.new(0), {Value = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))})}).Value,
        Transparency = TweenService.Create(Instance.new("NumberSequence"), TweenInfo.new(0), {Value = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0)})}).Value
    })

    -- Banner Superior
    local topBanner = createUI("Frame", mainFrame, {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = ACCENT_COLOR,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ZIndex = 2
    })
    createUI("UICorner", topBanner, {CornerRadius = UDim.new(0, 12)})

    local bannerText = createUI("TextLabel", topBanner, {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "SAXZHUB | UCHIHA ELITE",
        TextColor3 = LIGHT_TEXT_COLOR,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    })

    -- Botón de cerrar con estilo
    local closeButton = createUI("TextButton", topBanner, {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -10, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = ACCENT_COLOR,
        Text = "X",
        TextColor3 = LIGHT_TEXT_COLOR,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        ZIndex = 3
    })
    createUI("UICorner", closeButton, {CornerRadius = UDim.new(1, 0)})
    closeButton.MouseButton1Click:Connect(function()
        playSound(BUTTON_CLICK_SOUND_ID, 0.6)
        mainScreenGui:Destroy()
    end)

    -- Contenedor de pestañas (sidebar)
    local sidebar = createUI("Frame", mainFrame, {
        Size = UDim2.new(0.25, 0, 1, -60), -- Ajustado para el banner
        Position = UDim2.new(0, 0, 0, 55),
        BackgroundColor3 = DARK_COLOR,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ZIndex = 2
    })
    createUI("UICorner", sidebar, {CornerRadius = UDim.new(0, 10)})

    local tabLayout = createUI("UIListLayout", sidebar, {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    createUI("UIPadding", sidebar, {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})

    local function createTabButton(name, callback)
        local tab = createUI("TextButton", sidebar, {
            Size = UDim2.new(0.9, 0, 0, 40),
            BackgroundColor3 = MEDIUM_COLOR,
            BackgroundTransparency = 0.2,
            Text = name,
            TextColor3 = LIGHT_TEXT_COLOR,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            BorderSizePixel = 0,
            ZIndex = 3
        })
        createUI("UICorner", tab, {CornerRadius = UDim.new(0, 6)})

        tab.MouseEnter:Connect(function()
            playSound(BUTTON_HOVER_SOUND_ID, 0.1)
            TweenService:Create(tab, TweenInfo.new(0.1), {TextColor3 = ACCENT_COLOR, BackgroundColor3 = Color3.fromRGB(40, 0, 0)}):Play()
        end)
        tab.MouseLeave:Connect(function()
            TweenService:Create(tab, TweenInfo.new(0.1), {TextColor3 = LIGHT_TEXT_COLOR, BackgroundColor3 = MEDIUM_COLOR}):Play()
        end)
        tab.MouseButton1Click:Connect(function()
            playSound(BUTTON_CLICK_SOUND_ID, 0.4)
            callback()
        end)
        return tab
    end

    createTabButton("Amaterasu Aim", function() print("Combat Tab Selected") end)
    createTabButton("Sharingan Vision", function() print("Visuals Tab Selected") end)
    createTabButton("Body Flicker", function() print("Movement Tab Selected") end)
    createTabButton("Izanagi Misc", function() print("Misc Tab Selected") end)

    -- Contenedor de contenido principal
    local contentFrame = createUI("ScrollingFrame", mainFrame, {
        Size = UDim2.new(0.7, -10, 1, -60), -- Ajustado para el banner y sidebar
        Position = UDim2.new(0.25, 5, 0, 55),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = ACCENT_COLOR,
        ZIndex = 2
    })
    createUI("UIListLayout", contentFrame, {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder})
    createUI("UIPadding", contentFrame, {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})

    -- Ejemplo de sección de opciones
    local section = createUI("Frame", contentFrame, {
        Size = UDim2.new(1, 0, 0, 100), -- Altura automática
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = MEDIUM_COLOR,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ZIndex = 3
    })
    createUI("UICorner", section, {CornerRadius = UDim.new(0, 8)})
    createUI("UIListLayout", section, {FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
    createUI("UIPadding", section, {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})

    local sectionTitle = createUI("TextLabel", section, {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "COMBATE: AMATERASU AIM",
        TextColor3 = ACCENT_COLOR,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4
    })

    local toggleButton = createUI("TextButton", section, {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = DARK_COLOR,
        BackgroundTransparency = 0.2,
        Text = "Activar Amaterasu Aim",
        TextColor3 = LIGHT_TEXT_COLOR,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 4
    })
    createUI("UICorner", toggleButton, {CornerRadius = UDim.new(0, 6)})
    toggleButton.MouseButton1Click:Connect(function()
        playSound(BUTTON_CLICK_SOUND_ID, 0.5)
        print("Amaterasu Aim Toggled!")
    end)

    print("Interfaz Uchiha Elite Premium cargada.")
end

--[[ ANTI-LAG LIGERO ]]
local function applyAntiLag()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.Brightness = 0.5
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

--[[ EJECUCIÓN ]]
task.spawn(showItachiIntroPremium)
applyAntiLag()
setupFPS()
setupItachiUIPrem()
