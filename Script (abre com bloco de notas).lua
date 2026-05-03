--[[
    DIMITROF04 HUB - SISTEMA DE ABAS (V6)
    Abas:
    1. LocalPlayer (Movimentação & Fly)
    2. FPS (Combate)
]]
local TweenService = game:GetService("TweenService")
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

script.Parent = ScreenGui

-- --- Variáveis de Estado ---
local ESP_Enabled = false
local Aimbot_Enabled = false
local Hitbox_Enabled = false
local AutoFire_Enabled = false
local Speed_Enabled = true
local Jump_Enabled = true
local Spin_Enabled = false
local TweenTP_Enabled = false
local Noclip_Enabled = false
local InfJump_Enabled = false
local Fly_Enabled = false
local WalkSpeed_Value = 16
local JumpPower_Value = 50
local SpinSpeed_Value = 75
local FlySpeed = 50
local AimSmoothness = 0.2
local FOV = 200
local Minimized = false

-- Estrutura da Janela Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 450) -- Aumentado um pouco para a lista
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local OriginalSize = MainFrame.Size

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
Title.Text = "~ Dimitrof04 Hub (V3) ~ "
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(0, 38, 255)
CloseBtn.Parent = TopBar
CloseBtn.Font = Enum.Font.Kalam
CloseBtn.TextScaled = true
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -80, 0, 2.5) -- fica do lado do X
MinBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.TextScaled = true
MinBtn.Font = Enum.Font.Kalam
MinBtn.TextColor3 = Color3.fromRGB(0, 38, 255)
MinBtn.Parent = TopBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

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

local function MinizeWindows()
	ScreenGui.Enabled = not ScreenGui.Enabled
end

local function AutoShoot()
	local char = LocalPlayer.Character
	if not char then return end

	local tool = char:FindFirstChildOfClass("Tool")
	if tool then
		tool:Activate()
	end
end

local function ApplyStats(char)
	if char and char:FindFirstChild("Humanoid") then
		local hum = char.Humanoid
		hum.WalkSpeed = WalkSpeed_Value
		hum.JumpPower = JumpPower_Value
		hum.UseJumpPower = true
	end
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
	btn.Activated:Connect(function() OpenTab(target) end)
	return btn
end

CreateTabBtn("LocalPlayer", "LocalPlayer")
CreateTabBtn("FPS", "FPS")
OpenTab("LocalPlayer")

-- Auxiliares de UI
local function CreateButton(text, parent)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.95, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- NÃO deixa transparente
	btn.BackgroundTransparency = 0
	btn.Text = text .. ": OFF"
	btn.TextColor3 = Color3.fromRGB(0, 89, 255)
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.Parent = parent

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 2
	stroke.Parent = btn

	-- estado interno
	local enabled = false

	-- função de toggle embutida
	local function Toggle()
		enabled = not enabled

		btn.Text = text .. ": " .. (enabled and "ON" or "OFF")
		stroke.Color = enabled and Color3.fromRGB(0,120,255) or Color3.fromRGB(0,0,0)
	end

	btn.Activated:Connect(Toggle)

	return btn, function()
		return enabled
	end
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

local function CreateSlider(labelText, min, max, default, parent, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.95, 0, 0, 50)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 15)
	label.Text = labelText .. ": " .. default
	label.TextColor3 = Color3.fromRGB(200,200,200)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.Parent = frame

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, 0, 0, 10)
	bar.Position = UDim2.new(0, 0, 0, 25)
	bar.BackgroundColor3 = Color3.fromRGB(40,40,40)
	bar.Parent = frame
	Instance.new("UICorner", bar)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(0,120,255)
	fill.Parent = bar
	Instance.new("UICorner", fill)

	local dragging = false

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	bar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local percent = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			fill.Size = UDim2.new(percent, 0, 1, 0)

			local value = math.floor(min + (max - min) * percent)
			label.Text = labelText .. ": " .. value

			callback(value)
		end
	end)
end

CreateSlider("Velocidade", 10, 1000, 16, LocalPlayerPage, function(val)
	WalkSpeed_Value = val
end)

CreateSlider("Pulo", 10, 500, 50, LocalPlayerPage, function(val)
	JumpPower_Value = val
end)

CreateSlider("Fly Speed", 10, 750, 50, LocalPlayerPage, function(val)
	FlySpeed = val
end)

-- --- CONTEÚDO: LOCALPLAYER ---
local FlyBtn = CreateButton("Voo (Fly) ", LocalPlayerPage)
local SpeedToggle = CreateButton("Speed ", LocalPlayerPage)
local JumpToggle = CreateButton("Jump ", LocalPlayerPage)
local NoclipBtn = CreateButton("Noclip ", LocalPlayerPage)
local InfJumpBtn = CreateButton("inf Jump ", LocalPlayerPage)
local TweenBtn = CreateButton("Tween Player (Dis Tp inst) ", LocalPlayerPage) -- novo

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

local UIListLayoutGenericoTpPlayer = Instance.new("UIListLayout", PlayerScroll)
UIListLayoutGenericoTpPlayer.FillDirection = Enum.FillDirection.Vertical
UIListLayoutGenericoTpPlayer.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayoutGenericoTpPlayer.SortOrder = Enum.SortOrder.Name
UIListLayoutGenericoTpPlayer.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayoutGenericoTpPlayer.Name = "UIListLayout"

Instance.new("UICorner", PlayerScroll)

-- Atualizar Lista de Jogadores
local function UpdatePlayerList()
	for _, child in pairs(PlayerScroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(0.95, 0, 0, 30)
			btn.Text = player.Name
			btn.Parent = PlayerScroll

			-- VISUAL
			btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.TextScaled = true
			btn.Font = Enum.Font.GothamBold
			
			local char = player.Character or player.CharacterAdded:Wait()
			local hrp = char:WaitForChild("HumanoidRootPart", 2)
			
			btn.Activated:Connect(function()
				if char and char:FindFirstChild("HumanoidRootPart") then
					local targetCF = char.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)

					if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						local myHRP = LocalPlayer.Character.HumanoidRootPart

						if TweenTP_Enabled then
							local tween = TweenService:Create(
								myHRP,
								TweenInfo.new(0.5, Enum.EasingStyle.Linear),
								{CFrame = targetCF}
							)
							tween:Play()
						else
							myHRP.CFrame = targetCF
						end
					end
				end
			end)
		end
	end
	
	local count = 0
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			count += 1
		end
	end

	PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 27)
end

local function HookPlayer(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.2)
		UpdatePlayerList()
	end)
end

for _, p in pairs(Players:GetPlayers()) do
	HookPlayer(p)
end

Players.PlayerAdded:Connect(function(player)
	HookPlayer(player)
	UpdatePlayerList()
end)

Players.PlayerRemoving:Connect(UpdatePlayerList)

UpdatePlayerList()

-- --- CONTEÚDO: FPS ---
local SpinCharBtn = CreateButton("Spin Character ", FPSPage)
local ESPBtn = CreateButton("ESP ", FPSPage)
local AimbotBtn = CreateButton("Aimbot ", FPSPage)
local HitboxBtn = CreateButton("Hitbox Gigante ", FPSPage)

CreateSlider("SpinSpeed", 10, 300, 75, FPSPage, function(val)
	SpinSpeed_Value = val
end)

--local AutoFireBtn = CreateButton("AutoFire: OFF", FPSPage)

ESPBtn.Activated:Connect(function()
	ESP_Enabled = not ESP_Enabled
	ESPBtn.Text = "ESP: " .. (ESP_Enabled and "ON" or "OFF")
end)	

-- --- LÓGICA DE MOVIMENTAÇÃO ---

-- Fly System
local flyKeyDown, flyKeyUp

HitboxBtn.Activated:Connect(function()
	Hitbox_Enabled = not Hitbox_Enabled
	HitboxBtn.Text = "Hitbox Gigante: " .. (Hitbox_Enabled and "ON" or "OFF")
end)

RunService.Heartbeat:Connect(function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("Humanoid") then
		
		if Speed_Enabled then
			char.Humanoid.WalkSpeed = WalkSpeed_Value
		else
			char.Humanoid.WalkSpeed = 16
		end

		if Jump_Enabled then
			char.Humanoid.JumpPower = JumpPower_Value
		else
			char.Humanoid.JumpPower = 50
		end
		
		char.Humanoid.UseJumpPower = true
	end
	if Hitbox_Enabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = p.Character.HumanoidRootPart
				hrp.Size = Vector3.new(10,10,10)
				hrp.Transparency = 0.7
				hrp.BrickColor = BrickColor.new("Really red")
				hrp.Material = Enum.Material.Neon
				hrp.CanCollide = false

				if Hitbox_Enabled then
					hrp.Size = Vector3.new(10,10,10)
					hrp.Transparency = 0.7
					hrp.Material = Enum.Material.Neon
					hrp.CanCollide = false
				else
					hrp.Size = Vector3.new(2,2,1)
					hrp.Transparency = 0
					hrp.Material = Enum.Material.Plastic
				end
			end
		end
	end
end)

-- Teleporte
TPBtn.Activated:Connect(function()
	local targetName = TPInput.Text:lower()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Name:lower():sub(1, #targetName) == targetName then
			if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local targetCF = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)

				if TweenTP_Enabled then
					local hrp = LocalPlayer.Character.HumanoidRootPart

					local tween = TweenService:Create(
						hrp,
						TweenInfo.new(0.5, Enum.EasingStyle.Linear),
						{CFrame = targetCF}
					)

					tween:Play()
				else
					LocalPlayer.Character.HumanoidRootPart.CFrame = targetCF
				end
				break
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

UserInputService.JumpRequest:Connect(function()
	if InfJump_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- --- LÓGICA FPS ---
-- (ESP, Aimbot, Hitbox e AutoFire mantidos da lógica anterior para estabilidade)

AimbotBtn.Activated:Connect(function()
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
				if dist < shortestDist and dist < FOV then
					shortestDist = dist
					closest = p
				end
			end
		end
	end
	return closest
end

--[[AutoFireBtn.Activated:Connect(function()
	AutoFire_Enabled = not AutoFire_Enabled
	AutoFireBtn.Text = "AutoFire: " .. (AutoFire_Enabled and "ON" or "OFF")
end)]]

RunService.RenderStepped:Connect(function()

	-- AIMBOT
	if Aimbot_Enabled then
		local target = GetClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			local targetPos = target.Character.Head.Position
			local current = Camera.CFrame.Position

			local newCF = CFrame.new(current, targetPos)
			Camera.CFrame = Camera.CFrame:Lerp(newCF, AimSmoothness)
		end
	end
	
	--Spin
	if Spin_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(SpinSpeed_Value), 0)
	end

	-- ESP
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then

			if ESP_Enabled then
				local folder = Instance.new("Folder", p.Character)
				folder.Name = "ESP_FOLDER"
				if not p.Character.Head:FindFirstChild("ESP") then
					local bill = Instance.new("BillboardGui", p.Character.Head)
					bill.Name = "ESP"
					bill.Size = UDim2.new(0,100,0,40)
					bill.AlwaysOnTop = true

					local txt = Instance.new("TextLabel", bill)
					txt.Size = UDim2.new(1,0,1,0)
					txt.Text = p.Name
					txt.TextColor3 = Color3.new(1,0,0)
					txt.BackgroundTransparency = 1

					local bill2 = Instance.new("BillboardGui", p.Character.HumanoidRootPart)
					bill2.Name = "ESP"
					bill2.Size = UDim2.new(2,0,3,0)
					bill2.AlwaysOnTop = true

					local Frame = Instance.new("Frame", bill2)
					Frame.Size = UDim2.new(1,0,1,0)
					Frame.BackgroundTransparency = 0.75
					Frame.BackgroundColor3 = Color3.new(1,0,0)
					Frame.Name = "ESP"
				end
			else
				if p.Character.Head:FindFirstChild("ESP") then
					p.Character.Head.ESP:Destroy()
					p.Character.HumanoidRootPart.ESP:Destroy()
				end
			end
		end
	end
	
	task.spawn(function()
		while true do
			if AutoFire_Enabled then
				AutoShoot()
			end
			task.wait(0.05)
		end
	end)
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
	if not gpe and input.KeyCode == Enum.KeyCode.J then
		MinizeWindows()
	end
end)

MinBtn.Activated:Connect(function()
	MinizeWindows()
end)


CloseBtn.Activated:Connect(function() ScreenGui:Destroy() end)

FlyBtn.Activated:Connect(function()
	Fly_Enabled = not Fly_Enabled
	FlyBtn.Text = "Voo (Fly): " .. (Fly_Enabled and "ON" or "OFF")

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
				if char:FindFirstChild("Humanoid") then
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
			end
			bv:Destroy()
			bg:Destroy()
		end)
	end
end)

-- Noclip & InfJump (Mantidos da V5)
NoclipBtn.Activated:Connect(function()
	Noclip_Enabled = not Noclip_Enabled
	NoclipBtn.Text = "Noclip: " .. (Noclip_Enabled and "ON" or "OFF")
end)


SpeedToggle.Activated:Connect(function()
	Speed_Enabled = not Speed_Enabled
	SpeedToggle.Text = "Speed: " .. (Speed_Enabled and "ON" or "OFF")
end)

JumpToggle.Activated:Connect(function()
	Jump_Enabled = not Jump_Enabled
	JumpToggle.Text = "Jump: " .. (Jump_Enabled and "ON" or "OFF")
end)

SpinCharBtn.Activated:Connect(function()
	Spin_Enabled = not Spin_Enabled
	SpinCharBtn.Text = "Spin Character: " .. (Spin_Enabled and "ON" or "OFF")
end)

TweenBtn.Activated:Connect(function()
	TweenTP_Enabled = not TweenTP_Enabled
	TweenBtn.Text = "Tween Player: " .. (TweenTP_Enabled and "ON" or "OFF")
end)

InfJumpBtn.Activated:Connect(function()
	InfJump_Enabled = not InfJump_Enabled
	InfJumpBtn.Text = "Pulo Infinito: " .. (InfJump_Enabled and "ON" or "OFF")
end)


-- aplica quando spawnar
LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid")
	task.wait(0.2)
	ApplyStats(char)
end)

print("Dimitrof04 Hub V3 Carregado - Use 'J' para ocultar")
print("Fly : WASD move L-s abaixar Space Subir")
