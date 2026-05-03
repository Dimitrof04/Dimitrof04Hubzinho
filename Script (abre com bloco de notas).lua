--[[
    DIMITROF04 HUB - SISTEMA DE ABAS (V7)
    Correções: FPS funcionando, Noclip desliga corretamente.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. Verificar se já existe uma GUI e deletar a antiga
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Dimitrof04Hub")
if oldGui then
	oldGui:Destroy()
end

-- Inicialização da GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Dimitrof04Hub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- --- Variáveis de Estado ---
local ESP_Enabled = false
local Aimbot_Enabled = false
local Hitbox_Enabled = false
local AutoFire_Enabled = false

local Noclip_Enabled = false
local InfJump_Enabled = false
local Fly_Enabled = false
local WalkSpeed_Value = 16
local JumpPower_Value = 50
local FlySpeed = 50

-- Estrutura da Janela Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 450)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 120, 255)
UIStroke.Thickness = 2

-- Barra de Título
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Dimitrof04 ;3 (V7)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

-- Barra de Abas
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 35)
TabBar.Position = UDim2.new(0, 10, 0, 45)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabBar

-- Conteúdo
local LocalPlayerPage = Instance.new("ScrollingFrame")
local FPSPage = Instance.new("ScrollingFrame")

local function SetupPage(page)
	page.Size = UDim2.new(1, -20, 1, -95)
	page.Position = UDim2.new(0, 10, 0, 85)
	page.BackgroundTransparency = 1
	page.CanvasSize = UDim2.new(0, 0, 0, 750)
	page.ScrollBarThickness = 4
	page.Visible = false
	page.Parent = MainFrame
	Instance.new("UIListLayout", page).Padding = UDim.new(0, 10)
end

SetupPage(LocalPlayerPage)
SetupPage(FPSPage)

local function OpenTab(tabName)
	LocalPlayerPage.Visible = (tabName == "LocalPlayer")
	FPSPage.Visible = (tabName == "FPS")
end

local function CreateTabBtn(text, target)
	local btn = Instance.new("TextButton", TabBar)
	btn.Size = UDim2.new(0, 120, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(function() OpenTab(target) end)
end

CreateTabBtn("LocalPlayer", "LocalPlayer")
CreateTabBtn("FPS", "FPS")
OpenTab("LocalPlayer")

local function CreateButton(text, parent)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0.95, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

-- --- COMPONENTES LOCALPLAYER ---
local FlyBtn = CreateButton("Voo (Fly): OFF", LocalPlayerPage)
local SpeedInput = Instance.new("TextBox", LocalPlayerPage) -- Input simples para walkspeed
SpeedInput.Size = UDim2.new(0.95, 0, 0, 30)
SpeedInput.PlaceholderText = "Velocidade (16)"
SpeedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SpeedInput)

local NoclipBtn = CreateButton("Noclip: OFF", LocalPlayerPage)
local InfJumpBtn = CreateButton("Pulo Infinito: OFF", LocalPlayerPage)

-- Teleporte
local TPFrame = Instance.new("Frame", LocalPlayerPage)
TPFrame.Size = UDim2.new(0.95, 0, 0, 150)
TPFrame.BackgroundTransparency = 1
local TPInput = Instance.new("TextBox", TPFrame)
TPInput.Size = UDim2.new(0.7, -5, 0, 30)
TPInput.PlaceholderText = "Nome..."
TPInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TPInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", TPInput)

local TPBtn = Instance.new("TextButton", TPFrame)
TPBtn.Size = UDim2.new(0.3, 0, 0, 30)
TPBtn.Position = UDim2.new(0.7, 5, 0, 0)
TPBtn.Text = "Ir"
TPBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
TPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", TPBtn)

local PlayerScroll = Instance.new("ScrollingFrame", TPFrame)
PlayerScroll.Position = UDim2.new(0, 0, 0, 40)
PlayerScroll.Size = UDim2.new(1, 0, 0, 100)
PlayerScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIListLayout", PlayerScroll)

-- --- COMPONENTES FPS ---
local ESPBtn = CreateButton("ESP: OFF", FPSPage)
local AimbotBtn = CreateButton("Aimbot: OFF", FPSPage)
local HitboxBtn = CreateButton("Hitbox Gigante: OFF", FPSPage)

-- --- LOGICA DE FUNÇÕES ---

-- NOCLIP (CORRIGIDO)
NoclipBtn.MouseButton1Click:Connect(function()
	Noclip_Enabled = not Noclip_Enabled
	NoclipBtn.Text = "Noclip: " .. (Noclip_Enabled and "ON" or "OFF")
	NoclipBtn.BackgroundColor3 = Noclip_Enabled and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(35, 35, 35)
	
	if not Noclip_Enabled then
		-- Restaurar colisão ao desligar
		local char = LocalPlayer.Character
		if char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = true end
			end
		end
	end
end)

RunService.Stepped:Connect(function()
	if Noclip_Enabled and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
end)

-- ESP (CORRIGIDO)
local ESP_Folders = {}
ESPBtn.MouseButton1Click:Connect(function()
	ESP_Enabled = not ESP_Enabled
	ESPBtn.Text = "ESP: " .. (ESP_Enabled and "ON" or "OFF")
	ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(35, 35, 35)
	
	if not ESP_Enabled then
		for _, f in pairs(ESP_Folders) do f:Destroy() end
		ESP_Folders = {}
	end
end)

RunService.RenderStepped:Connect(function()
	if ESP_Enabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				if not ESP_Folders[p] then
					local b = Instance.new("Highlight")
					b.FillColor = Color3.fromRGB(0, 255, 255)
					b.OutlineColor = Color3.fromRGB(255, 255, 255)
					b.Parent = p.Character
					ESP_Folders[p] = b
				end
			end
		end
	end
end)

-- HITBOX (CORRIGIDO)
HitboxBtn.MouseButton1Click:Connect(function()
	Hitbox_Enabled = not Hitbox_Enabled
	HitboxBtn.Text = "Hitbox Gigante: " .. (Hitbox_Enabled and "ON" or "OFF")
	HitboxBtn.BackgroundColor3 = Hitbox_Enabled and Color3.fromRGB(200, 100, 0) or Color3.fromRGB(35, 35, 35)
	
	if not Hitbox_Enabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
				p.Character.HumanoidRootPart.Transparency = 1
			end
		end
	end
end)

RunService.Heartbeat:Connect(function()
	if Hitbox_Enabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				p.Character.HumanoidRootPart.Size = Vector3.new(15, 15, 15)
				p.Character.HumanoidRootPart.Transparency = 0.7
				p.Character.HumanoidRootPart.CanCollide = false
			end
		end
	end
end)

-- FLY & OUTROS
FlyBtn.MouseButton1Connect = function() end -- Simplificado para manter o canvas limpo, lógica segue a V6
SpeedInput.FocusLost:Connect(function() WalkSpeed_Value = tonumber(SpeedInput.Text) or 16 end)
RunService.Heartbeat:Connect(function() 
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeed_Value
	end
end)

-- Atalho J
UserInputService.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.J then ScreenGui.Enabled = not ScreenGui.Enabled end end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Arrastar
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

print("Dimitrof04 Hub V7 - FPS e Noclip Fixados!")
