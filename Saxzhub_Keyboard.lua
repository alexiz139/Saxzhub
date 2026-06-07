
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Saxzhub | +1 Escapa del Teclado (Mundo 2)",
   LoadingTitle = "Cargando Saxzhub...",
   LoadingSubtitle = "por alexiz139",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Saxzhub_Keyboard",
      FileName = "config"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false
})

-- VARIABLES
local LP = game:GetService("Players").LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local S = {
    WalkSpeed = 16,
    AutoWin = false,
    AutoShop = false
}

-- PESTAÑAS
local TabMain = Window:CreateTab("Principal", 4483362458)
local TabTeleport = Window:CreateTab("Teletransportes", 4483362458)
local TabPlayer = Window:CreateTab("Jugador", 4483362458)

-- SECCIÓN PRINCIPAL (AUTO WIN)
TabMain:CreateSection("Farming")

TabMain:CreateToggle({
   Name = "Auto Win (Farmear Victorias)",
   CurrentValue = false,
   Flag = "AutoWin",
   Callback = function(Value)
      S.AutoWin = Value
      task.spawn(function()
          while S.AutoWin do
              pcall(function()
                  -- Intentar teletransportarse a las placas amarillas de victoria
                  -- Estructura común: Workspace.Worlds.World2.Wins o similar
                  local wins = workspace:FindFirstChild("Worlds") and workspace.Worlds:FindFirstChild("World2") and workspace.Worlds.World2:FindFirstChild("Wins")
                  if wins then
                      for _, win in pairs(wins:GetChildren()) do
                          if win:IsA("BasePart") and S.AutoWin then
                              LP.Character.HumanoidRootPart.CFrame = win.CFrame + Vector3.new(0, 3, 0)
                              task.wait(0.5)
                          end
                      end
                  else
                      -- Backup: Buscar por nombre en todo el workspace si no se encuentra la ruta exacta
                      for _, obj in pairs(workspace:GetDescendants()) do
                          if obj.Name == "WinPart" or obj.Name == "WinPad" or (obj:IsA("BasePart") and obj.Color == Color3.fromRGB(255, 255, 0)) then
                             if S.AutoWin then
                                 LP.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                                 task.wait(0.5)
                             end
                          end
                      end
                  end
              end)
              task.wait(1)
          end
      end)
   end,
})

-- SECCIÓN TELETRANSPORTES
TabTeleport:CreateSection("Secciones del Mundo 2")

local function TPTo(pos)
    pcall(function()
        LP.Character.HumanoidRootPart.CFrame = pos
    end)
end

-- Botones para TPs específicos (Basado en la estructura típica de niveles)
for i = 1, 15 do
    TabTeleport:CreateButton({
       Name = "Teleport a Sección " .. i,
       Callback = function()
          -- Buscar la sección por nombre o número
          local target = workspace:FindFirstChild("World2") and workspace.World2:FindFirstChild("Stage" .. i) or workspace:FindFirstChild("Stage" .. i)
          if target then
              TPTo(target.CFrame + Vector3.new(0, 5, 0))
          else
              Rayfield:Notify({
                 Title = "Error",
                 Content = "No se encontró la sección " .. i,
                 Duration = 3,
                 Image = 4483362458,
              })
          end
       end,
    })
end

-- SECCIÓN JUGADOR
TabPlayer:CreateSection("Mejoras de Jugador")

TabPlayer:CreateSlider({
   Name = "Velocidad (WalkSpeed)",
   Range = {16, 500},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "WS_Slider",
   Callback = function(Value)
      S.WalkSpeed = Value
      LP.Character.Humanoid.WalkSpeed = Value
   end,
})

-- Mantener la velocidad al respawnear
LP.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    task.wait(0.5)
    hum.WalkSpeed = S.WalkSpeed
end)

-- SECCIÓN AUTO SHOP
TabMain:CreateSection("Auto Shop")
TabMain:CreateToggle({
   Name = "Auto Comprar Mejoras",
   CurrentValue = false,
   Callback = function(Value)
      S.AutoShop = Value
      task.spawn(function()
          while S.AutoShop do
              pcall(function()
                  -- Intentar disparar remotos de compra comunes
                  local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Events") and game.ReplicatedStorage.Events:FindFirstChild("BuyUpgrade")
                  if remote then
                      remote:FireServer("Speed")
                  end
              end)
              task.wait(1)
          end
      end)
   end,
})

Rayfield:LoadConfiguration()
