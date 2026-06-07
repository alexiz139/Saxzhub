
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
local TabCreator = Window:CreateTab("Creador 👑", 4483362458)

-- SECCIÓN CREADOR (TEXTO ROJO)
TabCreator:CreateSection("👑 INFORMACIÓN DEL CREADOR")
TabCreator:CreateLabel("CREADOR 👑", 4483362458, Color3.fromRGB(255, 0, 0))
TabCreator:CreateParagraph({Title = "Owner", Content = "alexiz139"})

-- SECCIÓN PRINCIPAL (AUTO WIN MEJORADO)
TabMain:CreateSection("Farming")

TabMain:CreateToggle({
   Name = "Auto Win (Placas Amarillas)",
   CurrentValue = false,
   Flag = "AutoWin",
   Callback = function(Value)
      S.AutoWin = Value
      task.spawn(function()
          while S.AutoWin do
              pcall(function()
                  -- Buscar placas amarillas con texto de Win
                  for _, obj in pairs(workspace:GetDescendants()) do
                      if S.AutoWin and obj:IsA("BasePart") and (obj.Name:lower():find("win") or obj.Color == Color3.fromRGB(255, 255, 0)) then
                          -- Verificar si tiene un BillboardGui o texto arriba
                          local hasWinText = false
                          for _, child in pairs(obj:GetDescendants()) do
                              if child:IsA("TextLabel") and child.Text:lower():find("win") then
                                  hasWinText = true
                                  break
                              end
                          end
                          
                          if hasWinText or obj.Name:lower():find("winpad") then
                              LP.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                              task.wait(0.6) -- Tiempo para que el juego registre la victoria
                          end
                      end
                  end
              end)
              task.wait(0.5)
          end
      end)
   end,
})

-- SECCIÓN TELETRANSPORTES (BOTONES DINÁMICOS)
TabTeleport:CreateSection("Teletransportes a Victorias")

TabTeleport:CreateButton({
   Name = "Escanear y TP a Placas de Win",
   Callback = function()
       local found = false
       for _, obj in pairs(workspace:GetDescendants()) do
           if obj:IsA("BasePart") and (obj.Name:lower():find("win") or obj.Color == Color3.fromRGB(255, 255, 0)) then
               LP.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
               found = true
               break
           end
       end
       if not found then
           Rayfield:Notify({Title = "Error", Content = "No se encontraron placas de victoria cercanas.", Duration = 3})
       end
   end,
})

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
      if LP.Character and LP.Character:FindFirstChild("Humanoid") then
          LP.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- Mantener la velocidad al respawnear
task.spawn(function()
    while true do
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.WalkSpeed ~= S.WalkSpeed then
                LP.Character.Humanoid.WalkSpeed = S.WalkSpeed
            end
        end)
        task.wait(1)
    end
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
                  local events = game:GetService("ReplicatedStorage"):FindFirstChild("Events") or game:GetService("ReplicatedStorage")
                  for _, remote in pairs(events:GetChildren()) do
                      if remote:IsA("RemoteEvent") and (remote.Name:lower():find("buy") or remote.Name:lower():find("upgrade")) then
                          remote:FireServer("Speed")
                      end
                  end
              end)
              task.wait(2)
          end
      end)
   end,
})

Rayfield:LoadConfiguration()
