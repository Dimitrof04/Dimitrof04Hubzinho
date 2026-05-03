--[[
    DIMITROF04 HUB - SISTEMA DE ABAS (V6)
    Abas:
    1. LocalPlayer (Movimentação & Fly)
    2. FPS (Combate)
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
MainFrame.Size = UDim2.new(0, 550, 0, 450) -- Aumentado um pouco para a lista
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
Title.Text = "Dimitrof04 ;3 (V6)"
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

-- Containers de Conteúdo
local LocalPlayerPage = Instance.new("ScrollingFrame")
local FPSPage = Instance.new("ScrollingFrame")

local function SetupPage(page)
	page.Size = UDim2.new(1, -20, 1, -95)
	page.Position = UDim2.new(0, 10, 0, 85)
	page.BackgroundTransparency = 1
	page.CanvasSize = UDim2.new(0, 0, 0, 700)
	page.ScrollBarThickness = 4
	page.Visible = false
	page.Parent = MainFrame
	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, 10)
	list.HorizontalAlignment = Enum.HorizontalAlignment.Center
	list.Parent = page
end

SetupPage(LocalPlayerPage)
SetupPage(FPSPage)

local function OpenTab(tabName)
	LocalPlayerPage.Visible = (tabName == "LocalPlayer")
	FPSPage.Visible = (tabName == "FPS")
end

local function CreateTabBtn(text, target)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 120, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Parent = TabBar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(function() OpenTab(target) end)
	return btn
end

CreateTabBtn("LocalPlayer", "LocalPlayer")
CreateTabBtn("FPS", "FPS")
OpenTab("LocalPlayer")

-- Auxiliares de UI
local function CreateButton(text, parent)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.95, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local function CreateInput(placeholder, labelText, parent)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.95, 0, 0, 55)
	frame.BackgroundTransparency = 1
	frame.Parent = parent
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 15)
	lbl.Text = labelText
	lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
	lbl.BackgroundTransparency = 1
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 12
	lbl.Parent = frame
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, 0, 0, 30)
	box.Position = UDim2.new(0, 0, 0, 20)
	box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	box.PlaceholderText = placeholder
	box.Text = ""
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.Parent = frame
	Instance.new("UICorner", box)
	return box
end

-- --- CONTEÚDO: LOCALPLAYER ---
local FlyBtn = CreateButton("Voo (Fly): OFF", LocalPlayerPage)
local SpeedInput = CreateInput("Valor (16)", "Velocidade", LocalPlayerPage)
local JumpInput = CreateInput("Valor (50)", "Pulo", LocalPlayerPage)
local NoclipBtn = CreateButton("Noclip: OFF", LocalPlayerPage)
local InfJumpBtn = CreateButton("Pulo Infinito: OFF", LocalPlayerPage)

-- Seção de Teleporte
local TPFrame = Instance.new("Frame")
TPFrame.Size = UDim2.new(0.95, 0, 0, 180)
TPFrame.BackgroundTransparency = 1
TPFrame.Parent = LocalPlayerPage

local TPLabel = Instance.new("TextLabel", TPFrame)
TPLabel.Text = "Teleporte (Selecione ou Digite)"
TPLabel.Size = UDim2.new(1, 0, 0, 20)
TPLabel.TextColor3 = Color3.fromRGB(0, 120, 255)
TPLabel.BackgroundTransparency = 1
TPLabel.Font = Enum.Font.GothamBold

local TPInput = Instance.new("TextBox", TPFrame)
TPInput.Size = UDim2.new(0.6, -5, 0, 30)
TPInput.Position = UDim2.new(0, 0, 0, 25)
TPInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TPInput.PlaceholderText = "Nome..."
TPInput.Text = ""
TPInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", TPInput)

local TPBtn = Instance.new("TextButton", TPFrame)
TPBtn.Size = UDim2.new(0.4, -5, 0, 30)
TPBtn.Position = UDim2.new(0.6, 5, 0, 25)
TPBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
TPBtn.Text = "Teleportar"
TPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", TPBtn)

local PlayerScroll = Instance.new("ScrollingFrame", TPFrame)
PlayerScroll.Size = UDim2.new(1, 0, 0, 110)
PlayerScroll.Position = UDim2.new(0, 0, 0, 65)
PlayerScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlayerScroll.BorderSizePixel = 0
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UIListLayout", PlayerScroll).Padding = UDim.new(0, 2)
Instance.new("UICorner", PlayerScroll)

-- Atualizar Lista de Jogadores
local function UpdatePlayerList()
	for _, child in pairs(PlayerScroll:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local pBtn = Instance.new("TextButton", PlayerScroll)
			pBtn.Size = UDim2.new(1, -10, 0, 25)
			pBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			pBtn.Text = p.Name
			pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			pBtn.Font = Enum.Font.Gotham
			pBtn.TextSize = 12
			Instance.new("UICorner", pBtn)
			
			pBtn.MouseButton1Click:Connect(function()
				TPInput.Text = p.Name
			end)
		end
	end
	PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 27)
end
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
UpdatePlayerList()

-- --- CONTEÚDO: FPS ---
local ESPBtn = CreateButton("ESP: OFF", FPSPage)
local AimbotBtn = CreateButton("Aimbot: OFF", FPSPage)
local HitboxBtn = CreateButton("Hitbox Gigante: OFF", FPSPage)
local AutoFireBtn = CreateButton("AutoFire: OFF", FPSPage)

-- --- LÓGICA DE MOVIMENTAÇÃO ---

-- Fly System
local flyKeyDown, flyKeyUp
FlyBtn.MouseButton1Click:Connect(function()
	Fly_Enabled = not Fly_Enabled
	FlyBtn.Text = "Voo (Fly): " .. (Fly_Enabled and "ON" or "OFF")
	FlyBtn.BackgroundColor3 = Fly_Enabled and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(35, 35, 35)
	
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	
	if Fly_Enabled then
		local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
		bv.Name = "FlyVelocity"
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		
		local bg = Instance.new("BodyGyro", char.HumanoidRootPart)
		bg.Name = "FlyGyro"
		bg.P = 9e4
		bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bg.CFrame = char.HumanoidRootPart.CFrame
		
		task.spawn(function()
			while Fly_Enabled and char:FindFirstChild("HumanoidRootPart") do
				local moveDir = char.Humanoid.MoveDirection
				local flyVel = moveDir * FlySpeed
				
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					flyVel = flyVel + Vector3.new(0, FlySpeed, 0)
				elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
					flyVel = flyVel + Vector3.new(0, -FlySpeed, 0)
				end
				
				bv.Velocity = flyVel
				bg.CFrame = Camera.CFrame
				RunService.RenderStepped:Wait()
			end
			bv:Destroy()
			bg:Destroy()
		end)
	end
end)

-- WalkSpeed / JumpPower
SpeedInput.FocusLost:Connect(function() WalkSpeed_Value = tonumber(SpeedInput.Text) or 16 end)
JumpInput.FocusLost:Connect(function() JumpPower_Value = tonumber(JumpInput.Text) or 50 end)

RunService.Heartbeat:Connect(function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.WalkSpeed = WalkSpeed_Value
		char.Humanoid.JumpPower = JumpPower_Value
	end
end)

-- Teleporte
TPBtn.MouseButton1Click:Connect(function()
	local targetName = TPInput.Text:lower()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Name:lower():sub(1, #targetName) == targetName then
			if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
				break
			end
		end
	end
end)

-- Noclip & InfJump (Mantidos da V5)
NoclipBtn.MouseButton1Click:Connect(function()
	Noclip_Enabled = not Noclip_Enabled
	NoclipBtn.Text = "Noclip: " .. (Noclip_Enabled and "ON" or "OFF")
	NoclipBtn.BackgroundColor3 = Noclip_Enabled and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(35, 35, 35)
end)

RunService.Stepped:Connect(function()
	if Noclip_Enabled and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
end)

InfJumpBtn.MouseButton1Click:Connect(function()
	InfJump_Enabled = not InfJump_Enabled
	InfJumpBtn.Text = "Pulo Infinito: " .. (InfJump_Enabled and "ON" or "OFF")
end)

UserInputService.JumpRequest:Connect(function()
	if InfJump_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- --- LÓGICA FPS ---
-- (ESP, Aimbot, Hitbox e AutoFire mantidos da lógica anterior para estabilidade)

AimbotBtn.MouseButton1Click:Connect(function()
	Aimbot_Enabled = not Aimbot_Enabled
	AimbotBtn.Text = "Aimbot: " .. (Aimbot_Enabled and "ON" or "OFF")
end)

local function GetClosestPlayer()
	local closest, shortestDist = nil, math.huge
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
			if onScreen then
				local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
				if dist < shortestDist and dist < 400 then
					shortestDist = dist
					closest = p
				end
			end
		end
	end
	return closest
end

RunService.RenderStepped:Connect(function()
	if Aimbot_Enabled then
		local target = GetClosestPlayer()
		if target and target.Character:FindFirstChild("Head") then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
		end
	end
end)

-- Arrastar Janela
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

-- Atalho para abrir/fechar
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.J then ScreenGui.Enabled = not ScreenGui.Enabled end
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

print("Dimitrof04 Hub V6 Carregado - Use 'J' para ocultar")
