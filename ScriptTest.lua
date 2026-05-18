--[[
	@Dimitrof04
	-- nao reposabilisamos por expulsoes / banimentos
	-- use com moderacao
	-- algumas funcoes pode nao ta funcionando pois esta em fase de teste
	-- killaura // autofire funciona apenas se a tool tiver Remoteevent!!!
]]
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local haveblur = true

local Blur = Lighting:FindFirstChild("Blur")
if not Blur then
	Blur = Instance.new("BlurEffect", Lighting)
	Blur.Size = 0
	haveblur = false
end

-- 1. Verificar se já existe uma GUI e deletar a antiga
local oldGui = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("Dimitrof04Hub")
local Oldgui2 = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("Dimitrof04List")

if oldGui and Oldgui2 then
	script:Destroy()
end

local SizesMainJanel = {
	Janel = UDim2.new(0.287, 0,0.417, 0),
	Max = UDim2.new(1,0,0.939,0)
}

local PosMainJanel = {
	Janel = UDim2.new(0.357, 0,0.292, 0),
	Max = UDim2.new(0, 0,0.06, 0) -- Não se move
}

local ImportantesArrays = {
	TitleBar = {
		Max = UDim2.new(0.927, 0,1, 0),
		Janel = UDim2.new(0.757, 0,1, 0)
	},
	sizesbuttons = {
		Max = UDim2.new(0.023, 0, 0.875, 0),
		Janel = UDim2.new(0.084, 0,0.875, 0)
	}
}

-- Inicialização da GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "Dimitrof04Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 35

local ListScrenguis = Instance.new("ScreenGui", ScreenGui.Parent)
ListScrenguis.Name = "Dimitrof04HubList"
ListScrenguis.ResetOnSpawn = false
ListScrenguis.IgnoreGuiInset = true
ListScrenguis.DisplayOrder = 90
ListScrenguis.Enabled = true

-- --- Variáveis de Estado ---
-- DRAG DO BOTÃO MINI
local States = {
	draggingMini = false,
	IsMaxSize = false,
	ESP_Enabled = false,
	Aimbot_Enabled = false,
	AutoFire_Enabled = false,
	KillAura_Enabled = false,
	Speed_Enabled = true,
	Jump_Enabled = true,
	Spin_Enabled = false,
	TweenTP_Enabled = false,
	Noclip_Enabled = false,
	InfJump_Enabled = false,
	Fly_Enabled = false,
	Minimized = false,
	BlurScript_enabled = false,
}

local Values = {
	WalkSpeed = 16,
	JumpPower = 50,
	SpinSpeed = 75,
	FlySpeed = 50,
	AimSmoothness = 0.2,
	FOV = 500,
	BgTransparency = 0.6,
	SelectedPlayer = nil
}

local DragData = {
	dragStartMini = nil,
	startPosMini = nil
}

local function CreateUiStroke(parent, size, color)
	local Uistrokebtntab = Instance.new("UIStroke")
	Uistrokebtntab.Color = color or Color3.fromRGB(255, 255, 255)
	Uistrokebtntab.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Uistrokebtntab.Thickness = size
	Uistrokebtntab.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	Uistrokebtntab.LineJoinMode = Enum.LineJoinMode.Round
	Uistrokebtntab.Parent = parent

	return Uistrokebtntab
end

local function CreateUiFrame(Parent, pos, siz)
	local Frame = Instance.new("Frame")
	Frame.Name = "Frame"
	Frame.Size = siz
	Frame.Position = pos
	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Parent = Parent
	Frame.Visible = true

	return Frame
end

local function CreateUiList(Parent, VA, HA, Wraps, Sortorder, FD)
	local List = Instance.new("UIListLayout", Parent)
	List.FillDirection = FD
	List.SortOrder = Sortorder or Enum.SortOrder.LayoutOrder
	List.Wraps = Wraps
	List.VerticalAlignment = VA
	List.HorizontalAlignment = HA
	List.Name = "List"
	List.Padding = UDim.new(0, 0)

	return List
end

local function CreateUiText(TextLabel, Parent, pos, siz)
	local Text = Instance.new("TextLabel")
	Text.Size = siz
	Text.Position = pos
	Text.BackgroundTransparency = 1
	Text.Text = TextLabel
	Text.TextColor3 = Color3.fromRGB(255, 255, 255)
	Text.TextXAlignment = Enum.TextXAlignment.Center
	Text.Font = Enum.Font.SourceSans
	Text.TextSize = 14
	Text.TextScaled = false
	Text.Parent = Parent
	Text.Name = "TextLabel"

	return Text
end

local function CreateUiTextButton(Text ,Parent, pos, siz)
	local TextButton = Instance.new("TextButton")
	TextButton.Size = siz
	TextButton.Position = pos
	TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	TextButton.BackgroundTransparency = 1
	TextButton.Text = Text
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.Parent = Parent
	TextButton.Font = Enum.Font.SourceSans
	TextButton.TextScaled = false
	TextButton.Name = "TextButton"

	return TextButton
end

local function InitScript()
	-- MainMiniButton
	local MainMiniButton = Instance.new("ImageButton") --butaozinho
	MainMiniButton.Name = "MainMiniButton"
	MainMiniButton.Size = UDim2.new(0.061, 0,0.109, 0)
	MainMiniButton.Position = UDim2.new(0.052, 0,0.093, 0)
	MainMiniButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	MainMiniButton.BackgroundTransparency = 1
	MainMiniButton.Image = "rbxassetid://96272608935524"
	MainMiniButton.BorderSizePixel = 0
	MainMiniButton.Parent = ScreenGui
	MainMiniButton.ZIndex = 0
	Instance.new("UICorner", MainMiniButton).CornerRadius = UDim.new(0.3,0)
	CreateUiStroke(MainMiniButton, 0.03, Color3.fromRGB(71, 71, 71))

	-- Estrutura da Janela Principal
	local MainFrame = CreateUiFrame(ScreenGui, PosMainJanel.Janel, SizesMainJanel.Janel)
	MainFrame.BackgroundTransparency = Values.BgTransparency
	MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	MainFrame.Name = "MainFrame"
	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
	CreateUiStroke(MainFrame, 0.01, Color3.fromRGB(255, 255, 255))

	local TopBar = CreateUiFrame(MainFrame, UDim2.new(0.018, 0,0, 0), UDim2.new(0.982, 0,0.089, 0))

	local ListLayoutTopbar = CreateUiList(TopBar, Enum.VerticalAlignment.Top, Enum.HorizontalAlignment.Left, false, Enum.SortOrder.Name, Enum.FillDirection.Horizontal)

	local Title = CreateUiText("~ Dimitrof04 Hub ~ ", TopBar, UDim2.new(0,0,0,0), ImportantesArrays.TitleBar.Janel)
	Title.BackgroundTransparency = 1
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Font = Enum.Font.GothamBold
	Title.Name = "a"

	local CloseBtn = CreateUiTextButton("X", TopBar, UDim2.new(0,0,0,0), ImportantesArrays.sizesbuttons.Janel)
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.Font = Enum.Font.Kalam
	CloseBtn.TextScaled = true
	CloseBtn.Name = "d"
	Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

	local MaxJanelSizebtn = CreateUiTextButton("[]", TopBar, UDim2.new(0,0,0,0), ImportantesArrays.sizesbuttons.Janel)
	MaxJanelSizebtn.TextScaled = true
	MaxJanelSizebtn.Font = Enum.Font.Kalam
	MaxJanelSizebtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	MaxJanelSizebtn.Name = "c"
	Instance.new("UICorner", MaxJanelSizebtn).CornerRadius = UDim.new(0, 5)

	local MinBtn = CreateUiTextButton("-", TopBar, UDim2.new(0,0,0,0), ImportantesArrays.sizesbuttons.Janel)
	MinBtn.TextScaled = true
	MinBtn.Font = Enum.Font.Kalam
	MinBtn.Parent = TopBar
	MinBtn.Name = "b"
	Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

	-- Barra de Abas
	local TabBar = CreateUiFrame(MainFrame, UDim2.new(0.018, 0,0.1, 0), UDim2.new(0.218, 0,0.855, 0))

	local TabListLayout = CreateUiList(TabBar, Enum.VerticalAlignment.Top, Enum.HorizontalAlignment.Left, true, Enum.SortOrder.Name, Enum.FillDirection.Vertical)
	TabListLayout.Padding = UDim.new(0.03, 0)

	-- Containers de Conteúdo
	local LocalPlayerPage = Instance.new("ScrollingFrame")
	local FPSPage = Instance.new("ScrollingFrame")
	local MiscPage = Instance.new("ScrollingFrame")
	local PlayerPage = Instance.new("ScrollingFrame")

	local Animates = {
		MaxSize = TweenService:Create(
			MainFrame,
			TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				Size = SizesMainJanel.Max,
				Position = PosMainJanel.Max
			}
		),

		MinSize = TweenService:Create(
			MainFrame,
			TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				Size = SizesMainJanel.Janel,
				Position = PosMainJanel.Janel
			}
		),

		Minimize = TweenService:Create(
			MainFrame,
			TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{
				Size = UDim2.new(0, 0, 0, 0),
				Position = MainMiniButton.Position,
				BackgroundTransparency = 1
			}
		),

		Open = TweenService:Create(
			MainFrame,
			TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				Size = SizesMainJanel.Janel,
				Position = PosMainJanel.Janel,
				BackgroundTransparency = Values.BgTransparency
			}
		),

		BlurIn = TweenService:Create(
			Blur,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Size = 0 }
		),

		BlurOut = TweenService:Create(
			Blur,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ Size = 12 }
		),
	}

	local function TransferirJanela()
		States.IsMaxSize = not States.IsMaxSize

		-- Cancela animações anteriores (evita bug spam click)
		for _, anim in pairs(Animates) do
			if typeof(anim) == "Instance" and anim:IsA("Tween") then
				anim:Cancel()
			end
		end

		if States.IsMaxSize then
			Animates.MaxSize:Play()
			MaxJanelSizebtn.Text = "#"

			-- Ajuste UI
			Title.Size = ImportantesArrays.TitleBar.Max
			CloseBtn.Size = ImportantesArrays.sizesbuttons.Max
			MaxJanelSizebtn.Size = ImportantesArrays.sizesbuttons.Max
			MinBtn.Size = ImportantesArrays.sizesbuttons.Max

		else
			Animates.MinSize:Play()
			MaxJanelSizebtn.Text = "[]"

			-- Ajuste UI
			Title.Size = ImportantesArrays.TitleBar.Janel
			CloseBtn.Size = ImportantesArrays.sizesbuttons.Janel
			MaxJanelSizebtn.Size = ImportantesArrays.sizesbuttons.Janel
			MinBtn.Size = ImportantesArrays.sizesbuttons.Janel
		end
	end

	local function SetupPage(page)
		page.Size = UDim2.new(0.729, 0,0.878, 0)
		page.Position = UDim2.new(0.252, 0,0.1, 0)
		page.BackgroundTransparency = 1
		page.CanvasSize = UDim2.new(0, 0, 0, 700)
		page.ScrollBarThickness = 4
		page.Visible = false
		page.Parent = MainFrame

		local list = CreateUiList(page, Enum.VerticalAlignment.Top, Enum.HorizontalAlignment.Center,false,Enum.SortOrder.LayoutOrder, Enum.FillDirection.Vertical)
		list.Padding = UDim.new(0, 10)
	end

	local function OpenTab(tabName)
		LocalPlayerPage.Visible = (tabName == "LocalPlayer")
		FPSPage.Visible = (tabName == "FPS")
		MiscPage.Visible = (tabName == "Misc")
		PlayerPage.Visible = (tabName == "Player")
	end

	local function GetClosestPlayer()
		local closest, shortestDist = nil, math.huge
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
				if onScreen then
					local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
					if dist < shortestDist and dist < Values.FOV then
						shortestDist = dist
						closest = p
					end
				end
			end
			task.wait(0.1)
		end
		return closest
	end

	local function ToggleState(key, btn, label)
		States[key] = not States[key]
		btn.Text = label .. ": " .. (States[key] and "ON" or "OFF")
	end

	local LastStateBeforeMinimize = {
		Size = SizesMainJanel.Janel,
		Position = PosMainJanel.Janel,
		IsMax = false
	}

	local function MinizeWindows()
		States.Minimized = not States.Minimized

		States.IsMaxSize = LastStateBeforeMinimize.IsMax

		if States.Minimized then
			-- Salva estado atual
			LastStateBeforeMinimize.Size = MainFrame.Size
			LastStateBeforeMinimize.Position = MainFrame.Position
			LastStateBeforeMinimize.IsMax = States.IsMaxSize

			-- Blur entra
			Animates.BlurIn:Play()

			-- Minimizar
			Animates.Minimize:Play()

			Animates.Minimize.Completed:Once(function()
				MainFrame.Visible = false
			end)

		else
			MainFrame.Visible = true

			-- cancela tweens
			for _, anim in pairs(Animates) do
				if typeof(anim) == "Instance" and anim:IsA("Tween") then
					anim:Cancel()
				end
			end

			-- Começa do botão
			MainFrame.Size = UDim2.new(0,0,0,0)
			MainFrame.Position = MainMiniButton.Position
			MainFrame.BackgroundTransparency = 1

			Animates.BlurOut:Play()

			States.IsMaxSize = LastStateBeforeMinimize.IsMax

			if LastStateBeforeMinimize.IsMax then
				Animates.MinSize:Play()

				Animates.MinSize.Completed:Once(function()
					Animates.MaxSize:Play()
				end)

				MaxJanelSizebtn.Text = "#"

				Title.Size = ImportantesArrays.TitleBar.Max
				CloseBtn.Size = ImportantesArrays.sizesbuttons.Max
				MaxJanelSizebtn.Size = ImportantesArrays.sizesbuttons.Max
				MinBtn.Size = ImportantesArrays.sizesbuttons.Max
			else
				Animates.MinSize:Play()

				MaxJanelSizebtn.Text = "[]"

				Title.Size = ImportantesArrays.TitleBar.Janel
				CloseBtn.Size = ImportantesArrays.sizesbuttons.Janel
				MaxJanelSizebtn.Size = ImportantesArrays.sizesbuttons.Janel
				MinBtn.Size = ImportantesArrays.sizesbuttons.Janel
			end
		end
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
			hum.WalkSpeed = Values.WalkSpeed
			hum.JumpPower = Values.JumpPower
			hum.UseJumpPower = true
		end
	end

	local function CreateTabBtn(text, target)
		local btn = CreateUiTextButton(text, TabBar, UDim2.new(0,0,0,0), UDim2.new(0.999, 0,0.126, 0))
		btn.Font = Enum.Font.GothamBold
		btn.TextScaled = true
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
		btn.Activated:Connect(function() OpenTab(target) end)

		local Uistrokebtntab = CreateUiStroke(btn, 0.075)
		return btn
	end

	-- Auxiliares de UI
	local function CreateButtonInput(text, parent, stateKey)
		local btn = CreateUiTextButton(text .. ": OFF", parent, UDim2.new(0,0,0,0), UDim2.new(0.791, 0,0.047, 0))
		btn.TextScaled = true
		btn.Font = Enum.Font.GothamMedium
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0.1, 0)

		local stroke = CreateUiStroke(btn, 0.1)

		local function Update()
			local enabled = States[stateKey]
			btn.Text = text .. ": " .. (enabled and "ON" or "OFF")
			stroke.Color = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(156, 156, 156)
		end

		btn.Activated:Connect(function()
			States[stateKey] = not States[stateKey]
			Update()
		end)

		Update()

		return btn
	end

	local function CreateOneButton(text, parent)
		local btn = CreateUiTextButton(text, parent, UDim2.new(0,0,0,0), UDim2.new(0.791, 0,0.047, 0))
		btn.TextScaled = true
		btn.Font = Enum.Font.GothamMedium
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0.1, 0)

		CreateUiStroke(btn, 0.1)

		return btn
	end

	local function CreateInput(placeholder, labelText, parent)
		local frame = CreateUiFrame(parent, UDim2.new(0,0,0,0), UDim2.new(0.95, 0,0.073, 0))
		local lbl = CreateUiText(labelText, frame, UDim2.new(0,0,0,0), UDim2.new(1,0,0.1,0))
		lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
		lbl.TextXAlignment = Enum.TextXAlignment.Center
		lbl.Font = Enum.Font.Gotham
		lbl.TextSize = 12
		local box = Instance.new("TextBox")
		box.Size = UDim2.new(1, 0, 0, 30)
		box.Position = UDim2.new(0, 0, 0, 0)
		box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		box.PlaceholderText = placeholder
		box.Text = ""
		box.TextColor3 = Color3.fromRGB(255, 255, 255)
		box.Parent = frame
		Instance.new("UICorner", box)
		return box
	end

	local function CreateSlider(labelText, min, max, default, parent, callback)
		local frame = CreateUiFrame(parent, UDim2.new(0,0,0,0), UDim2.new(0.95, 0,0.073, 0))

		local label = CreateUiText(labelText .. ": " .. default, frame, UDim2.new(0,0,0,0), UDim2.new(1,0,0.5,0))
		label.Font = Enum.Font.Gotham
		label.TextScaled = true

		local bar = CreateUiFrame(frame,UDim2.new(0, 0, 0, 25),UDim2.new(1, 0, 0, 10))
		bar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		bar.BackgroundTransparency = 0
		Instance.new("UICorner", bar)

		local fill = CreateUiFrame(bar, UDim2.new(0, 0, 0, 0), UDim2.new((default-min)/(max-min), 0, 1, 0))
		fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		fill.BackgroundTransparency = 0
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

	local function CreateList(Parent, text, namelist)
		local btn = CreateUiTextButton(string.format("< %s >", text), Parent, UDim2.new(0,0,0,0), UDim2.new(0.791, 0,0.047, 0))
		btn.Font = Enum.Font.Gotham
		btn.TextScaled = true

		Instance.new("UICorner", btn).CornerRadius = UDim.new(0.1, 0)

		CreateUiStroke(btn, 0.1)

		local ListFrame = CreateUiFrame(ListScrenguis, UDim2.new(0,0,0,0), UDim2.new(1,0,1,0))
		ListFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		ListFrame.BackgroundTransparency = 0.6
		ListFrame.Visible = false

		CreateUiList(ListFrame, Enum.VerticalAlignment.Center, Enum.HorizontalAlignment.Center, true, Enum.SortOrder.Name, Enum.FillDirection.Vertical).Padding = UDim.new(0.03,0)

		local function CreateButtonList(name, text)
			local button = ListFrame:FindFirstChild(name)
			if not button then
				local button = CreateUiTextButton(text, ListFrame, UDim2.new(0.156, 0,0.07, 0), UDim2.new(0,0,0,0))
				button.Name = name
				button.TextColor3 = Color3.fromRGB(255, 255, 255)
				button.TextScaled = true
				button.Font = Enum.Font.Gotham

				CreateUiStroke(button, 0.075)
				Instance.new("UICorner", button).CornerRadius = UDim.new(1,0)
			end
			return button
		end

		local function DeleteButtonList(name)
			local Dbutton = ListFrame:FindFirstChild(name)
			if Dbutton then
				Dbutton:Destroy()
			end
		end

		btn.Activated:Connect(function()
			ListFrame.Visible = not ListFrame.Visible
		end)

		return {
			Create = CreateButtonList,
			Delete = DeleteButtonList,
			Frame = ListFrame -- opcional
		}
	end

	SetupPage(LocalPlayerPage)
	SetupPage(FPSPage)
	SetupPage(MiscPage)
	SetupPage(PlayerPage)

	CreateTabBtn("LocalPlayer", "LocalPlayer")
	CreateTabBtn("Player", "Player")
	CreateTabBtn("FPS", "FPS")
	CreateTabBtn("Misc", "Misc")
	OpenTab("LocalPlayer")

	-- --- CONTEÚDO: LOCALPLAYER ---
	CreateSlider("Velocidade", 10, 500, 16, LocalPlayerPage, function(val)
		Values.WalkSpeed = val
	end)
	local SpeedToggle = CreateButtonInput("Speed", LocalPlayerPage, "Speed_Enabled")
	CreateSlider("Pulo", 10, 500, 50, LocalPlayerPage, function(val)
		Values.JumpPower = val
	end)
	local JumpToggle = CreateButtonInput("Jump", LocalPlayerPage, "Jump_Enabled")
	CreateSlider("Fly Speed", 10, 750, 50, LocalPlayerPage, function(val)
		Values.FlySpeed = val
	end)
	local FlyBtn = CreateButtonInput("Fly", LocalPlayerPage, "Fly_Enabled")
	local NoclipBtn = CreateButtonInput("Noclip", LocalPlayerPage, "Noclip_Enabled")
	local InfJumpBtn = CreateButtonInput("Inf Jump", LocalPlayerPage, "InfJump_Enabled")

	-- -- Player
	local Player = CreateInput("Player", "Select Player", PlayerPage)
	local PlayersListButton = CreateList(PlayerPage,"PlayerList","PlayersListButton")
	local TeleportBtn = CreateOneButton("Teleport", PlayerPage)

	-- --- CONTEÚDO: FPS ---
	local ESPBtn = CreateButtonInput("ESP", FPSPage, "ESP_Enabled")
	CreateSlider("AimbotForce", 300, 750, 400, FPSPage, function(val)
		Values.FOV = val
	end)
	local AimbotBtn = CreateButtonInput("Aimbot", FPSPage, "Aimbot_Enabled")
	CreateSlider("SpinSpeed", 10, 300, 75, FPSPage, function(val)
		Values.SpinSpeed = val
	end)

	local SpinCharBtn = CreateButtonInput("Spin", FPSPage, "Spin_Enabled")

	-- --- Misc ---
	local BgColorInput = CreateInput("15,15,15", "Cor do Fundo (R,G,B)", MiscPage)
	CreateSlider("Background Transparancy", 0, 100, Values.BgTransparency * 100, MiscPage, function(val)
		Values.BgTransparency = val
		MainFrame.BackgroundTransparency = val / 100
	end)
	--local BgTransparencyInput = CreateInput("0-1", "Transparência (0 = sólido, 1 = invisível)", MiscPage)

	--local AutoFireBtn = CreateButtonInput("AutoFire: OFF", FPSPage)

	-- --- LÓGICA DE MOVIMENTAÇÃO ---

	-- Fly System
	local flyKeyDown, flyKeyUp

	RunService.Heartbeat:Connect(function()
		if States.Fly_Enabled then
			local char = LocalPlayer.Character
			if char and char:FindFirstChild("HumanoidRootPart") then

				if not char.HumanoidRootPart:FindFirstChild("FlyVelocity") then
					local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
					bv.Name = "FlyVelocity"
					bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

					local bg = Instance.new("BodyGyro", char.HumanoidRootPart)
					bg.Name = "FlyGyro"
					bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
				end

				local bv = char.HumanoidRootPart:FindFirstChild("FlyVelocity")
				local bg = char.HumanoidRootPart:FindFirstChild("FlyGyro")

				if bv and bg then
					local moveDir = char.Humanoid.MoveDirection
					local flyVel = moveDir * Values.FlySpeed

					if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
						flyVel += Vector3.new(0, Values.FlySpeed, 0)
					elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
						flyVel += Vector3.new(0, -Values.FlySpeed, 0)
					end

					bv.Velocity = flyVel
					bg.CFrame = Camera.CFrame
				end
			end
		else
			local char = LocalPlayer.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local bv = char.HumanoidRootPart:FindFirstChild("FlyVelocity")
				local bg = char.HumanoidRootPart:FindFirstChild("FlyGyro")

				if bv then bv:Destroy() end
				if bg then bg:Destroy() end
			end
		end
	end)

	UserInputService.JumpRequest:Connect(function()
		if States.InfJump_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)

	-- --- LÓGICA FPS ---
	-- (ESP, Aimbot, Hitbox e AutoFire mantidos da lógica anterior para estabilidade)

	AimbotBtn.Activated:Connect(function()
		States.Aimbot_Enabled = not States.Aimbot_Enabled
		AimbotBtn.Text = "Aimbot: " .. (States.Aimbot_Enabled and "ON" or "OFF")
	end)

	local folder = Instance.new("Folder", workspace)
	folder.Name = "ESP_FOLDER"

	RunService.RenderStepped:Connect(function()

		-- AIMBOT
		if States.Aimbot_Enabled then
			local target = GetClosestPlayer()
			if target and target.Character and target.Character:FindFirstChild("Head") then
				local targetPos = target.Character.Head.Position
				local current = Camera.CFrame.Position

				local newCF = CFrame.new(current, targetPos)
				Camera.CFrame = Camera.CFrame:Lerp(newCF, Values.AimSmoothness)
			end
		end

		-- NOCLIP
		if States.Noclip_Enabled and LocalPlayer.Character then
			for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end

		-- PlayersStats
		local char = LocalPlayer.Character
		if char then
			if States.Speed_Enabled then
				char.Humanoid.WalkSpeed = Values.WalkSpeed
			else
				char.Humanoid.WalkSpeed = 16
			end

			if States.Jump_Enabled then
				char.Humanoid.JumpPower = Values.JumpPower
			else
				char.Humanoid.JumpPower = 50
			end

			char.Humanoid.UseJumpPower = true
		end


		--Spin
		if States.Spin_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(Values.SpinSpeed), 0)
		end

		-- ESP
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
				if States.ESP_Enabled then
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
						local esp1 = p.Character.Head:FindFirstChild("ESP")
						local esp2 = p.Character.HumanoidRootPart:FindFirstChild("ESP")

						if esp1 then esp1:Destroy() end
						if esp2 then esp2:Destroy() end
					end
				end
			end
		end
	end)

	task.spawn(function()
		while task.wait(0.05) do
			if States.AutoFire_Enabled then
				AutoShoot()
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

	MainMiniButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			DragData.draggingMini = true
			DragData.dragStartMini = input.Position
			DragData.startPosMini = MainMiniButton.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement and not States.IsMaxSize then
			local delta = input.Position - dragStart
			PosMainJanel.Janel = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			MainFrame.Position = PosMainJanel.Janel
		end
		if DragData.draggingMini and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - DragData.dragStartMini

			MainMiniButton.Position = UDim2.new(
				DragData.startPosMini.X.Scale,
				DragData.startPosMini.X.Offset + delta.X,
				DragData.startPosMini.Y.Scale,
				DragData.startPosMini.Y.Offset + delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input) 
		if input.UserInputType == Enum.UserInputType.MouseButton1 then 
			dragging = false
			DragData.draggingMini = false
		end
	end)

	-- Atalho para abrir/fechar
	UserInputService.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == Enum.KeyCode.J then
			MinizeWindows()
		end
	end)

	MinBtn.Activated:Connect(function()
		MinizeWindows()
	end)

	MainMiniButton.Activated:Connect(function()
		MinizeWindows()
	end)

	CloseBtn.Activated:Connect(function() ScreenGui:Destroy() end)

	TeleportBtn.Activated:Connect(function()
		if not Values.SelectedPlayer then
			warn("Nenhum player selecionado")
			return
		end

		local myChar = LocalPlayer.Character
		local targetChar = Values.SelectedPlayer.Character

		if myChar and targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
			myChar:PivotTo(targetChar.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
		else
			warn("Erro ao teleportar")
		end
	end)

	BgColorInput.FocusLost:Connect(function(enterPressed)
		if not enterPressed then return end

		local text = BgColorInput.Text
		local r, g, b = string.match(text, "(%d+),%s*(%d+),%s*(%d+)")

		r = tonumber(r)
		g = tonumber(g)
		b = tonumber(b)

		if r and g and b then
			r = math.clamp(r, 0, 255)
			g = math.clamp(g, 0, 255)
			b = math.clamp(b, 0, 255)

			MainFrame.BackgroundColor3 = Color3.fromRGB(r, g, b)
		else
			warn("Formato inválido! Use: R,G,B (ex: 15,15,15)")
		end
	end)

	Player.FocusLost:Connect(function(enterPressed)
		if not enterPressed then return end

		local name = Player.Text
		local plr = Players:FindFirstChild(name)

		if plr then
			Values.SelectedPlayer = plr
		else
			warn("Player não encontrado")
		end
	end)

	MaxJanelSizebtn.Activated:Connect(function()
		TransferirJanela()
	end)

	-- aplica quando spawnar
	LocalPlayer.CharacterAdded:Connect(function(char)
		char:WaitForChild("Humanoid")
		task.wait(0.2)
		ApplyStats(char)
	end)
	
	local debounce = false

	local function CreateTeleportbutton(player)
		local btn = PlayersListButton.Create(player.Name, player.Name)

		btn.Activated:Connect(function()
			if debounce then return end
			debounce = true
			
			local target = Players:FindFirstChild(player.Name)

			if not target then return end
			if not target.Character then return end
			if not target.Character:FindFirstChild("HumanoidRootPart") then return end
			if not LocalPlayer.Character then return end
			if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

			local targetPos = target.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
			local myHRP = LocalPlayer.Character.HumanoidRootPart

			-- 💡 MODO INSTANTÂNEO
			if not States.TweenTP_Enabled then
				myHRP.CFrame = CFrame.new(targetPos)
				debounce = false
				return
			end

			-- 💡 MODO TWEEN (suave)
			local tweenInfo = TweenInfo.new(
				1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out
			)

			local tween = TweenService:Create(myHRP, tweenInfo, {
				CFrame = CFrame.new(targetPos)
			})

			tween:Play()
			tween.Completed:Wait()
			
			debounce = false
		end)

	end
	
	Players.PlayerAdded:Connect(function(player)
		if player ~= LocalPlayer then
			CreateTeleportbutton(player)
		end
	end)

	-- quando sai
	Players.PlayerRemoving:Connect(function(player)
		PlayersListButton.Delete(player.Name)
	end)

	-- players que já estão no jogo
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			CreateTeleportbutton(player)
		end
	end
end

if not Blur then
	local AlertBlurjanel = CreateUiFrame(ScreenGui, UDim2.new(0.299, 0,0.291, 0), UDim2.new(0.401, 0,0.417, 0))
	AlertBlurjanel.BackgroundTransparency = 0.6

	CreateUiStroke(AlertBlurjanel, 0.03)
	Instance.new("UICorner", AlertBlurjanel).CornerRadius = UDim.new(0.05, 0)

	local AlertText = CreateUiText("This game have blur effect", AlertBlurjanel, UDim2.new(0.018, 0,0.027, 0), UDim2.new(0.963, 0,0.258, 0))
	AlertText.TextScaled = true

	local ComunFrameinAlertJanel = CreateUiFrame(AlertBlurjanel,UDim2.new(0,0,0.284,0),UDim2.new(1, 0,0.715, 0))
	local ListAlertJanel = CreateUiList(ComunFrameinAlertJanel, Enum.VerticalAlignment.Center, Enum.HorizontalAlignment.Center, false, Enum.SortOrder.LayoutOrder, Enum.FillDirection.Horizontal)
	ListAlertJanel.Padding = UDim.new(0.1,0)

	local FirstOpcion = CreateUiTextButton(" ", ComunFrameinAlertJanel, UDim2.new(0.18,0,0,0),UDim2.new(0.36, 0,0.382, 0))
	Instance.new("UICorner", FirstOpcion).CornerRadius = UDim.new(1, 0)
	CreateUiStroke(FirstOpcion, 0.08)

	local SecondOpcion = CreateUiTextButton(" ", ComunFrameinAlertJanel, UDim2.new(0.18,0,0,0),UDim2.new(0.36, 0,0.382, 0))
	Instance.new("UICorner", SecondOpcion).CornerRadius = UDim.new(1, 0)
	CreateUiStroke(SecondOpcion, 0.08)

	FirstOpcion.Text = "cheat blur effects"
	SecondOpcion.Text = "game blur effects"

	FirstOpcion.TextScaled = true
	SecondOpcion.TextScaled = true

	local function Initt()
		AlertBlurjanel:Destroy()

		InitScript()
	end

	FirstOpcion.Activated:Connect(function()
		States.BlurScript_enabled = true
		Initt()
	end)

	SecondOpcion.Activated:Connect(Initt)
else
	InitScript()
end
