-- Script Anti-Lag Pro (Versión Final - Grey Sky / Modo Cartón)
-- Intro Saxzhub + FPS RGB + Limpieza Progresiva
-- Creado por Manus AI

--[[ Configuración ]]
local INTRO_DURATION = 4 -- Duración de la intro en segundos
local INTRO_TEXT = "Saxzhub"
local INTRO_TEXT_COLOR = Color3.fromRGB(255, 0, 0) -- Rojo
local FPS_BUTTON_TEXT = "Fps"

--[[ Funciones de Utilidad ]]
local function createUI(instanceType, parent, properties)
    local ui = Instance.new(instanceType)
    for prop, value in pairs(properties) do
        ui[prop] = value
    end
    ui.Parent = parent
    return ui
end

--[[ Intro "Saxzhub" ]]
local function showIntro()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = createUI("ScreenGui", playerGui, {Name = "SaxzhubIntro", DisplayOrder = 999})
    local background = createUI("Frame", screenGui, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0
    })

    local introText = createUI("TextLabel", background, {
        Size = UDim2.new(0.8, 0, 0.2, 0),
        Position = UDim2.new(0.1, 0, 0.3, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Text = INTRO_TEXT,
        TextColor3 = INTRO_TEXT_COLOR,
        TextScaled = true,
        Font = Enum.Font.SourceSansBold,
        BorderSizePixel = 0
    })

    local loadingBarBackground = createUI("Frame", background, {
        Size = UDim2.new(0.6, 0, 0.05, 0),
        Position = UDim2.new(0.2, 0, 0.6, 0),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0
    })

    local loadingBarFill = createUI("Frame", loadingBarBackground, {
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0), -- Rojo para la barra de carga
        BorderSizePixel = 0
    })

    for i = 0, 100 do
        local progress = i / 100
        loadingBarFill:TweenSize(UDim2.new(progress, 0, 1, 0), "Out", "Quad", 0.1, true)
        task.wait(INTRO_DURATION / 100)
    end

    screenGui:Destroy()
end

--[[ Función para optimizar un objeto individual ]]
local function optimizeObject(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false

            -- Eliminar texturas y decals
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("Texture") or child:IsA("Decal") then
                    child:Destroy()
                end
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Beam") or obj:IsA("Trail") then
            obj.Enabled = false
        elseif obj:IsA("Sound") then
            obj.Volume = 0 -- Silenciar sonidos para un rendimiento extremo (opcional)
        end
    end)
end

--[[ Sistema Anti-Lag Pro (Grey Sky / Modo Cartón) ]]
local function applyAntiLagPro()
    -- Configuración de iluminación para Grey Sky y Modo Cartón
    game.Lighting.GlobalShadows = false
    game.Lighting.Brightness = 0.5 -- Brillo general más bajo
    game.Lighting.Ambient = Color3.fromRGB(80, 80, 80) -- Ambiente gris
    game.Lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100) -- Ambiente exterior gris
    game.Lighting.ColorShift_Top = Color3.fromRGB(50, 50, 50)
    game.Lighting.ColorShift_Bottom = Color3.fromRGB(50, 50, 50)
    game.Lighting.FogEnd = 0 -- Eliminar niebla
    game.Lighting.FogStart = 0

    -- Desactivar efectos de iluminación avanzados
    for _, effect in pairs(game.Lighting:GetChildren()) do
        if effect:IsA("PostEffect") or effect:IsA("Bloom") or effect:IsA("ColorCorrection") or effect:IsA("SunRaysEffect") or effect:IsA("BlurEffect") or effect:IsA("Atmosphere") then
            effect.Enabled = false
        end
    end

    -- Eliminar Skybox existente
    if game.Lighting:FindFirstChildOfClass("Sky") then
        game.Lighting:FindFirstChildOfClass("Sky"):Destroy()
    end

    -- Optimización de Terreno
    game.Workspace.Terrain.Decoration = false
    game.Workspace.Terrain.WaterWaveSize = 0
    game.Workspace.Terrain.WaterWaveSpeed = 0
    game.Workspace.Terrain.WaterReflectance = 0
    game.Workspace.Terrain.WaterTransparency = 1 -- Hacer el agua completamente transparente

    -- Limpieza progresiva de objetos existentes
    task.spawn(function()
        local descendants = game:GetDescendants()
        local count = 0
        for _, v in pairs(descendants) do
            optimizeObject(v)
            count = count + 1
            if count % 100 == 0 then
                task.wait()
            end
        end
        print("Limpieza inicial de objetos completada.")
    end)

    -- Auto-optimización continua para nuevos objetos
    game.DescendantAdded:Connect(function(newDescendant)
        optimizeObject(newDescendant)
    end)

    -- No forzar el color del personaje a negro en esta versión

    print("Sistema Anti-Lag Pro (Grey Sky / Modo Cartón) activado.")
end

--[[ Contador de FPS con RGB (Botón Pequeño y Ligero) ]]
local function setupFPSCounter()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = createUI("ScreenGui", playerGui, {Name = "FPSCounter", DisplayOrder = 998})
    local fpsButton = createUI("TextLabel", screenGui, {
        Size = UDim2.new(0.08, 0, 0.03, 0), -- Tamaño más pequeño
        Position = UDim2.new(0.9, 0, 0.02, 0), -- Esquina superior derecha, ajustado para el tamaño
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.7, -- Transparente
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

        hue = (hue + 0.01) % 1 -- Cambiar el tono (hue) para el efecto RGB
        fpsButton.TextColor3 = Color3.fromHSV(hue, 1, 1)
    end)

    print("Contador de FPS activado.")
end

--[[ Ejecución del Script ]]
showIntro()
applyAntiLagPro() -- Llamar a la función Anti-Lag Pro corregida
setupFPSCounter()

print("Script Anti-Lag Pro (Grey Sky / Modo Cartón) y FPS Counter cargado exitosamente.")
