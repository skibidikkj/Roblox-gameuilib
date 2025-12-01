-- Phoenix UI - Toggle Executor System
local PhoenixUI = {}
PhoenixUI.__index = PhoenixUI

-- Serviços
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Cores tema fênix premium
local Colors = {
    Main = Color3.fromRGB(15, 10, 15),
    Secondary = Color3.fromRGB(30, 20, 30),
    Accent = Color3.fromRGB(255, 80, 0),
    AccentHover = Color3.fromRGB(255, 120, 40),
    Success = Color3.fromRGB(0, 255, 100),
    Warning = Color3.fromRGB(255, 200, 0),
    Error = Color3.fromRGB(255, 50, 50),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    Dark = Color3.fromRGB(10, 5, 10)
}

-- Função para criar instâncias rapidamente
local function Create(className, props)
    local instance = Instance.new(className)
    for prop, value in pairs(props) do
        if prop == "Children" then
            for _, child in ipairs(value) do
                child.Parent = instance
            end
        else
            instance[prop] = value
        end
    end
    return instance
end

-- Sistema de animação avançado
local function Animate(object, props, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quint,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, props)
    tween:Play()
    return tween
end

-- Sistema de execução de scripts
local ScriptExecutor = {
    ExecutedScripts = {},
    ActiveToggles = {}
}

function ScriptExecutor:ExecuteScript(scriptCode, toggleName)
    local success, result = pcall(function()
        -- Verificar se é um loadstring
        if string.sub(scriptCode, 1, 10) == "loadstring" or string.find(scriptCode, "getfenv") then
            local loadFunc = loadstring(scriptCode)
            if loadFunc then
                return loadFunc()
            else
                error("Erro ao carregar loadstring")
            end
        else
            -- Executar script Lua diretamente
            return loadstring(scriptCode)()
        end
    end)
    
    if success then
        self.ExecutedScripts[toggleName] = true
        return true, "Script executado com sucesso!"
    else
        self.ExecutedScripts[toggleName] = false
        return false, "Erro: " .. tostring(result)
    end
end

function ScriptExecutor:StopScript(toggleName)
    self.ExecutedScripts[toggleName] = false
    -- Aqui você pode adicionar lógica para parar scripts específicos
    return true, "Script parado!"
end

-- Detectar dispositivo
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

-- Ajustes para mobile
local MOBILE_ADJUSTMENTS = {
    Scale = 1.3,
    FontSizeMultiplier = 1.2,
    ButtonHeight = 45,
    TabHeight = 50,
    HeaderHeight = 60
}

-- Criar janela principal premium
function PhoenixUI:CreateWindow(title, subtitle)
    local self = setmetatable({}, PhoenixUI)
    
    self.Elements = {}
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsMobile = IsMobile()
    
    -- Ajustar tamanhos para mobile
    local scale = self.IsMobile and MOBILE_ADJUSTMENTS.Scale or 1
    local baseWidth, baseHeight = 500, 450
    local width, height = baseWidth * scale, baseHeight * scale
    
    -- GUI principal
    self.ScreenGui = Create("ScreenGui", {
        Name = "PhoenixUIPremium",
        ResetOnSpawn = false,
        DisplayOrder = 10,
        Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    })
    
    -- Frame principal com sombra
    self.MainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, width, 0, height),
        Position = UDim2.new(0.5, -width/2, 0.5, -height/2),
        BackgroundColor3 = Colors.Main,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    })
    
    -- Efeitos visuais premium
    Create("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = self.MainFrame
    })
    
    -- Sombras
    Create("UIStroke", {
        Color = Colors.Accent,
        Thickness = 2,
        Transparency = 0.8,
        Parent = self.MainFrame
    })
    
    -- Cabeçalho premium
    local headerHeight = self.IsMobile and MOBILE_ADJUSTMENTS.HeaderHeight or 50
    local Header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, headerHeight),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = Header
    })
    
    -- Título e subtítulo
    local TitleContainer = Create("Frame", {
        Name = "TitleContainer",
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Parent = Header
    })
    
    local Title = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0.6, 0),
        BackgroundTransparency = 1,
        Text = title or "PHOENIX UI",
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 20 or 18,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom,
        Parent = TitleContainer
    })
    
    local Subtitle = Create("TextLabel", {
        Name = "Subtitle",
        Size = UDim2.new(1, 0, 0.4, 0),
        Position = UDim2.new(0, 0, 0.6, 0),
        BackgroundTransparency = 1,
        Text = subtitle or "Executor Edition",
        TextColor3 = Colors.TextSecondary,
        TextSize = self.IsMobile and 14 or 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = TitleContainer
    })
    
    -- Botões de controle
    local ControlButtons = Create("Frame", {
        Name = "ControlButtons",
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = Header
    })
    
    -- Botão minimizar (VERDE)
    local MinimizeBtn = Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0.5, -35, 0.5, -15),
        BackgroundColor3 = Colors.Success,
        TextColor3 = Colors.Text,
        Text = "_",
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = ControlButtons
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MinimizeBtn})
    
    -- Botão fechar (VERMELHO)
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        BackgroundColor3 = Colors.Error,
        TextColor3 = Colors.Text,
        Text = "×",
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = ControlButtons
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = CloseBtn})
    
    -- Container de abas premium
    self.TabContainer = Create("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 140, 1, -headerHeight),
        Position = UDim2.new(0, 0, 0, headerHeight),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = self.TabContainer
    })
    
    -- Container de conteúdo
    self.ContentContainer = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -140, 1, -headerHeight),
        Position = UDim2.new(0, 140, 0, headerHeight),
        BackgroundColor3 = Colors.Main,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = self.ContentContainer
    })
    
    -- Lista de abas com scroll
    self.TabList = Create("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, -10, 1, -20),
        Position = UDim2.new(0, 5, 0, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.TabContainer
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = self.TabList
    })
    
    -- Funções dos botões
    MinimizeBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Efeitos hover nos botões
    local function SetupButtonEffects(button, normalColor, hoverColor)
        button.MouseEnter:Connect(function()
            Animate(button, {BackgroundColor3 = hoverColor}, 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            Animate(button, {BackgroundColor3 = normalColor}, 0.2)
        end)
    end
    
    SetupButtonEffects(MinimizeBtn, Colors.Success, Color3.fromRGB(100, 255, 150))
    SetupButtonEffects(CloseBtn, Colors.Error, Color3.fromRGB(255, 100, 100))
    
    -- Sistema de arrastar
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function UpdateDrag(input)
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            UpdateDrag(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return self
end

-- Criar nova aba premium
function PhoenixUI:CreateTab(name, icon)
    local Tab = {}
    
    local tabHeight = self.IsMobile and MOBILE_ADJUSTMENTS.TabHeight or 45
    
    -- Botão da aba premium
    local TabButton = Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, -10, 0, tabHeight),
        BackgroundColor3 = Colors.Secondary,
        AutoButtonColor = false,
        Text = "",
        Parent = self.TabList
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = TabButton})
    
    -- Container de conteúdo do botão
    local ButtonContent = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = TabButton
    })
    
    -- Texto da aba
    local TabText = Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Colors.TextSecondary,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ButtonContent
    })
    
    -- Indicador de aba ativa
    local ActiveIndicator = Create("Frame", {
        Name = "ActiveIndicator",
        Size = UDim2.new(0, 4, 0.6, 0),
        Position = UDim2.new(1, -8, 0.2, 0),
        BackgroundColor3 = Colors.Accent,
        Visible = false,
        Parent = ButtonContent
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ActiveIndicator})
    
    -- Frame do conteúdo da aba
    local TabFrame = Create("ScrollingFrame", {
        Name = name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        Parent = self.ContentContainer
    })
    
    local UIListLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 12),
        Parent = TabFrame
    })
    
    -- Atualizar tamanho do canvas
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Função para mostrar esta aba
    local function ShowTab()
        if self.CurrentTab then
            Animate(self.CurrentTab.Button, {BackgroundColor3 = Colors.Secondary}, 0.3)
            Animate(self.CurrentTab.Button.Content.Text, {TextColor3 = Colors.TextSecondary}, 0.3)
            self.CurrentTab.Button.Content.ActiveIndicator.Visible = false
            self.CurrentTab.Frame.Visible = false
        end
        
        Animate(TabButton, {BackgroundColor3 = Color3.fromRGB(40, 25, 40)}, 0.3)
        Animate(TabText, {TextColor3 = Colors.Text}, 0.3)
        ActiveIndicator.Visible = true
        TabFrame.Visible = true
        self.CurrentTab = Tab
    end
    
    -- Efeitos do botão da aba
    TabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= Tab then
            Animate(TabButton, {BackgroundColor3 = Color3.fromRGB(35, 25, 35)}, 0.2)
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= Tab then
            Animate(TabButton, {BackgroundColor3 = Colors.Secondary}, 0.2)
        end
    end)
    
    TabButton.MouseButton1Click:Connect(ShowTab)
    
    -- Configurar aba
    Tab.Button = TabButton
    Tab.Frame = TabFrame
    Tab.Name = name
    
    -- Adicionar à lista
    table.insert(self.Tabs, Tab)
    
    -- Mostrar primeira aba
    if #self.Tabs == 1 then
        ShowTab()
    end
    
    -- Atualizar tamanho da lista de abas
    self.TabList.CanvasSize = UDim2.new(0, 0, 0, #self.Tabs * (tabHeight + 8))
    
    return Tab
end

-- Criar seção premium
function PhoenixUI:CreateSection(tab, name)
    local Section = {}
    
    -- Frame da seção
    local SectionFrame = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, -20, 0, 50),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        LayoutOrder = #tab.Frame:GetChildren(),
        Parent = tab.Frame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = SectionFrame})
    
    Create("UIStroke", {
        Color = Color3.fromRGB(60, 40, 60),
        Thickness = 1,
        Parent = SectionFrame
    })
    
    -- Cabeçalho da seção
    local SectionHeader = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = SectionFrame
    })
    
    local SectionTitle = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SectionHeader
    })
    
    -- Container de elementos
    local ElementsContainer = Create("Frame", {
        Name = "Elements",
        Size = UDim2.new(1, -10, 0, 0),
        Position = UDim2.new(0, 5, 1, 5),
        BackgroundTransparency = 1,
        Parent = SectionFrame
    })
    
    local ElementsList = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = ElementsContainer
    })
    
    Section.Frame = ElementsContainer
    
    return Section
end

-- TOGGLE EXECUTOR PREMIUM - AGORA COM FUNCIONALIDADE DE SCRIPTS
function PhoenixUI:CreateToggleExecutor(section, name, scriptCode, description)
    local Toggle = {}
    local State = false
    local ToggleName = name
    
    local ToggleFrame = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Parent = section.Frame
    })
    
    -- Container principal do toggle
    local ToggleContainer = Create("Frame", {
        Name = "Container",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Colors.Secondary,
        Parent = ToggleFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = ToggleContainer})
    Create("UIStroke", {
        Color = Color3.fromRGB(60, 40, 60),
        Thickness = 1,
        Parent = ToggleContainer
    })
    
    -- Informações do toggle
    local InfoFrame = Create("Frame", {
        Name = "Info",
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = ToggleContainer
    })
    
    local ToggleText = Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, -10, 0, 25),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = InfoFrame
    })
    
    local ToggleDesc = Create("TextLabel", {
        Name = "Description",
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        Text = description or "Clique para executar/parar",
        TextColor3 = Colors.TextSecondary,
        TextSize = self.IsMobile and 12 or 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = InfoFrame
    })
    
    -- Botão toggle (VERMELHO/VERDE)
    local ToggleButton = Create("TextButton", {
        Name = "Toggle",
        Size = UDim2.new(0, 80, 0, 35),
        Position = UDim2.new(1, -90, 0.5, -17.5),
        BackgroundColor3 = Colors.Error, -- Vermelho quando desligado
        AutoButtonColor = false,
        Text = "OFF",
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 14 or 12,
        Font = Enum.Font.GothamBold,
        Parent = ToggleContainer
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ToggleButton})
    Create("UIStroke", {
        Color = Colors.Text,
        Thickness = 2,
        Parent = ToggleButton
    })
    
    -- Status indicator
    local StatusIndicator = Create("Frame", {
        Name = "Status",
        Size = UDim2.new(0, 8, 0, 8),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundColor3 = Colors.Error,
        Parent = ToggleContainer
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = StatusIndicator})
    
    local function UpdateToggle()
        if State then
            -- Ligado - VERDE
            Animate(ToggleButton, {BackgroundColor3 = Colors.Success}, 0.3)
            Animate(StatusIndicator, {BackgroundColor3 = Colors.Success}, 0.3)
            ToggleButton.Text = "ON"
            
            -- Executar script quando ligado
            local success, message = ScriptExecutor:ExecuteScript(scriptCode, ToggleName)
            if not success then
                warn("Erro no toggle '" .. ToggleName .. "': " .. message)
                -- Se der erro, desliga o toggle
                State = false
                UpdateToggle()
            end
        else
            -- Desligado - VERMELHO
            Animate(ToggleButton, {BackgroundColor3 = Colors.Error}, 0.3)
            Animate(StatusIndicator, {BackgroundColor3 = Colors.Error}, 0.3)
            ToggleButton.Text = "OFF"
            
            -- Parar script quando desligado
            ScriptExecutor:StopScript(ToggleName)
        end
    end
    
    local function ToggleState()
        State = not State
        UpdateToggle()
    end
    
    -- Efeitos hover
    ToggleButton.MouseEnter:Connect(function()
        if State then
            Animate(ToggleButton, {BackgroundColor3 = Color3.fromRGB(100, 255, 150)}, 0.2)
        else
            Animate(ToggleButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.2)
        end
    end)
    
    ToggleButton.MouseLeave:Connect(function()
        UpdateToggle()
    end)
    
    ToggleButton.MouseButton1Click:Connect(ToggleState)
    
    -- Suporte mobile
    if self.IsMobile then
        ToggleButton.TouchTap:Connect(ToggleState)
    end
    
    UpdateToggle()
    
    -- Métodos públicos
    Toggle.Set = function(value)
        State = value
        UpdateToggle()
    end
    
    Toggle.Get = function()
        return State
    end
    
    Toggle.Execute = function()
        State = true
        UpdateToggle()
    end
    
    Toggle.Stop = function()
        State = false
        UpdateToggle()
    end
    
    return Toggle
end

-- Criar botão de execução rápida
function PhoenixUI:CreateScriptButton(section, name, scriptCode, description)
    local buttonHeight = self.IsMobile and MOBILE_ADJUSTMENTS.ButtonHeight or 40
    
    local Button = Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, 0, 0, buttonHeight),
        BackgroundColor3 = Colors.Accent,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = false,
        Parent = section.Frame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Button})
    
    Create("UIStroke", {
        Color = Color3.fromRGB(60, 40, 60),
        Thickness = 1,
        Parent = Button
    })
    
    -- Tooltip de descrição
    if description then
        Button.MouseEnter:Connect(function()
            -- Poderia adicionar um tooltip aqui
        end)
    end
    
    -- Efeitos hover
    Button.MouseEnter:Connect(function()
        Animate(Button, {BackgroundColor3 = Colors.AccentHover}, 0.2)
    end)
    
    Button.MouseLeave:Connect(function()
        Animate(Button, {BackgroundColor3 = Colors.Accent}, 0.2)
    end)
    
    -- Executar script no click
    Button.MouseButton1Click:Connect(function()
        local success, message = ScriptExecutor:ExecuteScript(scriptCode, name)
        if success then
            -- Feedback visual de sucesso
            Animate(Button, {BackgroundColor3 = Colors.Success}, 0.2)
            task.wait(0.5)
            Animate(Button, {BackgroundColor3 = Colors.Accent}, 0.2)
        else
            -- Feedback visual de erro
            Animate(Button, {BackgroundColor3 = Colors.Error}, 0.2)
            task.wait(0.5)
            Animate(Button, {BackgroundColor3 = Colors.Accent}, 0.2)
            warn("Erro no botão '" .. name .. "': " .. message)
        end
    end)
    
    return Button
end

-- Criar área de script personalizado
function PhoenixUI:CreateScriptBox(section, name)
    local ScriptBox = {}
    
    local Container = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 150),
        BackgroundTransparency = 1,
        Parent = section.Frame
    })
    
    local Label = Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Container
    })
    
    local TextBox = Create("TextBox", {
        Name = "ScriptInput",
        Size = UDim2.new(1, 0, 0, 100),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Colors.Secondary,
        TextColor3 = Colors.Text,
        Text = "-- Cole seu script aqui...",
        TextSize = self.IsMobile and 14 or 12,
        Font = Enum.Font.RobotoMono,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        ClearTextOnFocus = false,
        MultiLine = true,
        Parent = Container
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TextBox})
    
    local ExecuteButton = Create("TextButton", {
        Name = "Execute",
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 135),
        BackgroundColor3 = Colors.Success,
        Text = "EXECUTAR SCRIPT",
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 14 or 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = Container
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ExecuteButton})
    
    ExecuteButton.MouseButton1Click:Connect(function()
        local scriptCode = TextBox.Text
        local success, message = ScriptExecutor:ExecuteScript(scriptCode, "CustomScript")
        if success then
            Animate(ExecuteButton, {BackgroundColor3 = Colors.Success}, 0.2)
        else
            Animate(ExecuteButton, {BackgroundColor3 = Colors.Error}, 0.2)
            warn("Erro no script personalizado: " .. message)
        end
    end)
    
    ScriptBox.GetScript = function()
        return TextBox.Text
    end
    
    ScriptBox.SetScript = function(code)
        TextBox.Text = code
    end
    
    return ScriptBox
end

-- Destruir UI
function PhoenixUI:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- Mostrar/Esconder UI
function PhoenixUI:Toggle()
    if self.ScreenGui then
        self.ScreenGui.Enabled = not self.ScreenGui.Enabled
    end
end

return PhoenixUI    
    self.Elements = {}
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsMobile = IsMobile()
    
    -- Ajustar tamanhos para mobile
    local scale = self.IsMobile and MOBILE_ADJUSTMENTS.Scale or 1
    local baseWidth, baseHeight = 500, 450
    local width, height = baseWidth * scale, baseHeight * scale
    
    -- GUI principal
    self.ScreenGui = Create("ScreenGui", {
        Name = "PhoenixUIPremium",
        ResetOnSpawn = false,
        DisplayOrder = 10,
        Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    })
    
    -- Frame principal com sombra (SEM OVERLAY)
    self.MainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, width, 0, height),
        Position = UDim2.new(0.5, -width/2, 0.5, -height/2),
        BackgroundColor3 = Colors.Main,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    })
    
    -- Efeitos visuais premium
    Create("UIGradient", {
        Color = Gradients.Main,
        Rotation = 45,
        Parent = self.MainFrame
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = self.MainFrame
    })
    
    -- Sombras
    Create("UIStroke", {
        Color = Colors.Accent,
        Thickness = 2,
        Transparency = 0.8,
        Parent = self.MainFrame
    })
    
    -- Efeito de brilho
    local Glow = Create("ImageLabel", {
        Name = "Glow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://8992230671",
        ImageColor3 = Colors.Accent,
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 900, 900),
        Parent = self.MainFrame
    })
    
    -- Cabeçalho premium
    local headerHeight = self.IsMobile and MOBILE_ADJUSTMENTS.HeaderHeight or 50
    local Header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, headerHeight),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = Header
    })
    
    -- Gradiente do cabeçalho
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Colors.Secondary),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 25, 40))
        }),
        Parent = Header
    })
    
    -- Título e subtítulo
    local TitleContainer = Create("Frame", {
        Name = "TitleContainer",
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Parent = Header
    })
    
    local Title = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0.6, 0),
        BackgroundTransparency = 1,
        Text = title or "PHOENIX UI",
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 20 or 18,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom,
        Parent = TitleContainer
    })
    
    local Subtitle = Create("TextLabel", {
        Name = "Subtitle",
        Size = UDim2.new(1, 0, 0.4, 0),
        Position = UDim2.new(0, 0, 0.6, 0),
        BackgroundTransparency = 1,
        Text = subtitle or "Premium Edition",
        TextColor3 = Colors.TextSecondary,
        TextSize = self.IsMobile and 14 or 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = TitleContainer
    })
    
    -- Botões de controle (AGORA VERDE E VERMELHO)
    local ControlButtons = Create("Frame", {
        Name = "ControlButtons",
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = Header
    })
    
    -- Botão minimizar (VERDE)
    local MinimizeBtn = Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0.5, -35, 0.5, -15),
        BackgroundColor3 = Colors.Success, -- VERDE
        TextColor3 = Colors.Text,
        Text = "_",
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = ControlButtons
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MinimizeBtn})
    
    -- Botão fechar (VERMELHO)
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        BackgroundColor3 = Colors.Error, -- VERMELHO
        TextColor3 = Colors.Text,
        Text = "×",
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = ControlButtons
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = CloseBtn})
    
    -- Container de abas premium
    self.TabContainer = Create("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 140, 1, -headerHeight),
        Position = UDim2.new(0, 0, 0, headerHeight),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = self.TabContainer
    })
    
    -- Container de conteúdo
    self.ContentContainer = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -140, 1, -headerHeight),
        Position = UDim2.new(0, 140, 0, headerHeight),
        BackgroundColor3 = Colors.Main,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = self.ContentContainer
    })
    
    -- Lista de abas com scroll
    self.TabList = Create("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, -10, 1, -20),
        Position = UDim2.new(0, 5, 0, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.TabContainer
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = self.TabList
    })
    
    -- Funções dos botões
    MinimizeBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Efeitos hover nos botões (COM CORES VERDE E VERMELHO)
    local function SetupButtonEffects(button, normalColor, hoverColor)
        button.MouseEnter:Connect(function()
            Animate(button, {BackgroundColor3 = hoverColor}, 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            Animate(button, {BackgroundColor3 = normalColor}, 0.2)
        end)
        
        button.MouseButton1Down:Connect(function()
            Animate(button, {Size = UDim2.new(0, 28, 0, 28)}, 0.1)
        end)
        
        button.MouseButton1Up:Connect(function()
            Animate(button, {Size = UDim2.new(0, 30, 0, 30)}, 0.1)
        end)
    end
    
    -- Cores específicas para os botões verde e vermelho
    SetupButtonEffects(MinimizeBtn, Colors.Success, Color3.fromRGB(100, 255, 150)) -- Verde mais claro
    SetupButtonEffects(CloseBtn, Colors.Error, Color3.fromRGB(255, 100, 100)) -- Vermelho mais claro
    
    -- Sistema de arrastar melhorado
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function UpdateDrag(input)
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            UpdateDrag(input)
        end
    end)
    
    -- Suporte a gestos mobile
    if self.IsMobile then
        -- Pinch to resize
        local lastPinchDistance = nil
        
        UserInputService.TouchPinch:Connect(function(scale, state, inputs)
            if state == Enum.UserInputState.Begin then
                lastPinchDistance = nil
            elseif state == Enum.UserInputState.Change then
                local currentSize = self.MainFrame.Size
                local newWidth = math.clamp(currentSize.X.Offset * scale, 400, 800)
                local newHeight = math.clamp(currentSize.Y.Offset * scale, 300, 600)
                
                self.MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
                self.MainFrame.Position = UDim2.new(0.5, -newWidth/2, 0.5, -newHeight/2)
            end
        end)
    end
    
    return self
end

-- Criar nova aba premium
function PhoenixUI:CreateTab(name, icon)
    local Tab = {}
    
    local tabHeight = self.IsMobile and MOBILE_ADJUSTMENTS.TabHeight or 45
    
    -- Botão da aba premium
    local TabButton = Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, -10, 0, tabHeight),
        BackgroundColor3 = Colors.Secondary,
        AutoButtonColor = false,
        Text = "",
        Parent = self.TabList
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = TabButton})
    
    -- Container de conteúdo do botão
    local ButtonContent = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = TabButton
    })
    
    -- Ícone (se fornecido)
    if icon then
        Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 15, 0.5, -10),
            BackgroundTransparency = 1,
            Image = icon,
            ImageColor3 = Colors.TextSecondary,
            Parent = ButtonContent
        })
    end
    
    -- Texto da aba
    local textPosition = icon and UDim2.new(0, 45, 0, 0) or UDim2.new(0, 15, 0, 0)
    local TabText = Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, -50, 1, 0),
        Position = textPosition,
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Colors.TextSecondary,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ButtonContent
    })
    
    -- Indicador de aba ativa
    local ActiveIndicator = Create("Frame", {
        Name = "ActiveIndicator",
        Size = UDim2.new(0, 4, 0.6, 0),
        Position = UDim2.new(1, -8, 0.2, 0),
        BackgroundColor3 = Colors.Accent,
        Visible = false,
        Parent = ButtonContent
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ActiveIndicator})
    
    -- Frame do conteúdo da aba
    local TabFrame = Create("ScrollingFrame", {
        Name = name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        Parent = self.ContentContainer
    })
    
    local UIListLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 12),
        Parent = TabFrame
    })
    
    -- Atualizar tamanho do canvas
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Função para mostrar esta aba
    local function ShowTab()
        if self.CurrentTab then
            Animate(self.CurrentTab.Button, {BackgroundColor3 = Colors.Secondary}, 0.3)
            Animate(self.CurrentTab.Button.Content.Text, {TextColor3 = Colors.TextSecondary}, 0.3)
            if self.CurrentTab.Button.Content:FindFirstChild("Icon") then
                Animate(self.CurrentTab.Button.Content.Icon, {ImageColor3 = Colors.TextSecondary}, 0.3)
            end
            self.CurrentTab.Button.Content.ActiveIndicator.Visible = false
            self.CurrentTab.Frame.Visible = false
        end
        
        Animate(TabButton, {BackgroundColor3 = Color3.fromRGB(40, 25, 40)}, 0.3)
        Animate(TabText, {TextColor3 = Colors.Text}, 0.3)
        if TabButton.Content:FindFirstChild("Icon") then
            Animate(TabButton.Content.Icon, {ImageColor3 = Colors.Accent}, 0.3)
        end
        ActiveIndicator.Visible = true
        TabFrame.Visible = true
        self.CurrentTab = Tab
    end
    
    -- Efeitos do botão da aba
    TabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= Tab then
            Animate(TabButton, {BackgroundColor3 = Color3.fromRGB(35, 25, 35)}, 0.2)
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= Tab then
            Animate(TabButton, {BackgroundColor3 = Colors.Secondary}, 0.2)
        end
    end)
    
    TabButton.MouseButton1Click:Connect(ShowTab)
    
    -- Configurar aba
    Tab.Button = TabButton
    Tab.Frame = TabFrame
    Tab.Name = name
    
    -- Adicionar à lista
    table.insert(self.Tabs, Tab)
    
    -- Mostrar primeira aba
    if #self.Tabs == 1 then
        ShowTab()
    end
    
    -- Atualizar tamanho da lista de abas
    self.TabList.CanvasSize = UDim2.new(0, 0, 0, #self.Tabs * (tabHeight + 8))
    
    return Tab
end

-- Criar seção premium
function PhoenixUI:CreateSection(tab, name)
    local Section = {}
    
    -- Frame da seção
    local SectionFrame = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, -20, 0, 50),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        LayoutOrder = #tab.Frame:GetChildren(),
        Parent = tab.Frame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = SectionFrame})
    
    Create("UIStroke", {
        Color = Color3.fromRGB(60, 40, 60),
        Thickness = 1,
        Parent = SectionFrame
    })
    
    -- Cabeçalho da seção
    local SectionHeader = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = SectionFrame
    })
    
    local SectionTitle = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SectionHeader
    })
    
    local ExpandIcon = Create("ImageLabel", {
        Name = "ExpandIcon",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(964, 324),
        ImageRectSize = Vector2.new(36, 36),
        ImageColor3 = Colors.TextSecondary,
        Parent = SectionHeader
    })
    
    -- Container de elementos
    local ElementsContainer = Create("Frame", {
        Name = "Elements",
        Size = UDim2.new(1, -10, 0, 0),
        Position = UDim2.new(0, 5, 1, 5),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = SectionFrame
    })
    
    local ElementsList = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = ElementsContainer
    })
    
    -- Toggle da seção
    local Expanded = false
    
    local function ToggleSection()
        Expanded = not Expanded
        if Expanded then
            SectionFrame.Size = UDim2.new(1, -20, 0, 60 + ElementsList.AbsoluteContentSize.Y + 10)
            ElementsContainer.Visible = true
            Animate(ExpandIcon, {Rotation = 180}, 0.3)
        else
            SectionFrame.Size = UDim2.new(1, -20, 0, 50)
            ElementsContainer.Visible = false
            Animate(ExpandIcon, {Rotation = 0}, 0.3)
        end
    end
    
    SectionHeader.MouseButton1Click:Connect(ToggleSection)
    
    -- Atualizar tamanho quando elementos mudarem
    ElementsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if Expanded then
            SectionFrame.Size = UDim2.new(1, -20, 0, 60 + ElementsList.AbsoluteContentSize.Y + 10)
        end
    end)
    
    Section.Frame = ElementsContainer
    Section.Toggle = ToggleSection
    
    return Section
end

-- Criar botão premium
function PhoenixUI:CreateButton(section, name, callback)
    local buttonHeight = self.IsMobile and MOBILE_ADJUSTMENTS.ButtonHeight or 40
    
    local Button = Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, 0, 0, buttonHeight),
        BackgroundColor3 = Colors.Secondary,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = false,
        Parent = section.Frame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Button})
    
    Create("UIStroke", {
        Color = Color3.fromRGB(60, 40, 60),
        Thickness = 1,
        Parent = Button
    })
    
    -- Efeitos hover avançados
    Button.MouseEnter:Connect(function()
        Animate(Button, {BackgroundColor3 = Colors.AccentHover, Size = UDim2.new(1, 2, 0, buttonHeight)}, 0.2)
    end)
    
    Button.MouseLeave:Connect(function()
        Animate(Button, {BackgroundColor3 = Colors.Secondary, Size = UDim2.new(1, 0, 0, buttonHeight)}, 0.2)
    end)
    
    -- Efeito de click
    Button.MouseButton1Down:Connect(function()
        Animate(Button, {BackgroundColor3 = Colors.Accent, Size = UDim2.new(1, -2, 0, buttonHeight - 2)}, 0.1)
    end)
    
    Button.MouseButton1Up:Connect(function()
        Animate(Button, {BackgroundColor3 = Colors.AccentHover, Size = UDim2.new(1, 2, 0, buttonHeight)}, 0.1)
        
        if callback then
            callback()
        end
    end)
    
    -- Suporte a toque mobile
    if self.IsMobile then
        local touchCount = 0
        local lastTouchTime = 0
        
        Button.TouchTap:Connect(function()
            local currentTime = tick()
            if currentTime - lastTouchTime < 0.3 then
                touchCount = touchCount + 1
            else
                touchCount = 1
            end
            lastTouchTime = currentTime
            
            if touchCount == 1 then
                Animate(Button, {BackgroundColor3 = Colors.Accent}, 0.1)
                task.wait(0.1)
                Animate(Button, {BackgroundColor3 = Colors.AccentHover}, 0.2)
                
                if callback then
                    callback()
                end
            end
        end)
    end
    
    return Button
end

-- Criar toggle premium
function PhoenixUI:CreateToggle(section, name, default, callback)
    local Toggle = {}
    local State = default or false
    
    local ToggleFrame = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        Parent = section.Frame
    })
    
    local ToggleText = Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ToggleFrame
    })
    
    local ToggleButton = Create("TextButton", {
        Name = "Toggle",
        Size = UDim2.new(0, 50, 0, 25),
        Position = UDim2.new(1, -50, 0.5, -12.5),
        BackgroundColor3 = Colors.Secondary,
        AutoButtonColor = false,
        Text = "",
        Parent = ToggleFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleButton})
    
    Create("UIStroke", {
        Color = Color3.fromRGB(60, 40, 60),
        Thickness = 1,
        Parent = ToggleButton
    })
    
    local ToggleDot = Create("Frame", {
        Name = "Dot",
        Size = UDim2.new(0, 19, 0, 19),
        Position = UDim2.new(0, 3, 0.5, -9.5),
        BackgroundColor3 = Colors.Text,
        Parent = ToggleButton
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleDot})
    
    local function UpdateToggle()
        if State then
            Animate(ToggleButton, {BackgroundColor3 = Colors.Success}, 0.2) -- VERDE quando ativo
            Animate(ToggleDot, {Position = UDim2.new(1, -22, 0.5, -9.5)}, 0.2)
        else
            Animate(ToggleButton, {BackgroundColor3 = Colors.Error}, 0.2) -- VERMELHO quando inativo
            Animate(ToggleDot, {Position = UDim2.new(0, 3, 0.5, -9.5)}, 0.2)
        end
    end
    
    local function ToggleState()
        State = not State
        UpdateToggle()
        if callback then
            callback(State)
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(ToggleState)
    
    -- Suporte mobile
    if self.IsMobile then
        ToggleButton.TouchTap:Connect(ToggleState)
    end
    
    UpdateToggle()
    
    Toggle.Set = function(value)
        State = value
        UpdateToggle()
    end
    
    Toggle.Get = function()
        return State
    end
    
    return Toggle
end

-- Criar slider premium
function PhoenixUI:CreateSlider(section, name, min, max, default, callback)
    local Slider = {}
    local Value = default or min
    
    local SliderFrame = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Parent = section.Frame
    })
    
    local SliderText = Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = name .. ": " .. Value,
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SliderFrame
    })
    
    local SliderTrack = Create("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 1, -25),
        BackgroundColor3 = Colors.Secondary,
        Parent = SliderFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderTrack})
    
    Create("UIStroke", {
        Color = Color3.fromRGB(60, 40, 60),
        Thickness = 1,
        Parent = SliderTrack
    })
    
    local SliderFill = Create("Frame", {
        Name = "Fill",
        Size = UDim2.new((Value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Colors.Accent,
        Parent = SliderTrack
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderFill})
    
    Create("UIGradient", {
        Color = Gradients.Accent,
        Parent = SliderFill
    })
    
    local SliderButton = Create("TextButton", {
        Name = "Button",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new((Value - min) / (max - min), -10, 0.5, -10),
        BackgroundColor3 = Colors.Text,
        AutoButtonColor = false,
        Text = "",
        Parent = SliderTrack
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderButton})
    
    Create("UIStroke", {
        Color = Colors.Accent,
        Thickness = 2,
        Parent = SliderButton
    })
    
    local function UpdateSlider(input)
        local relativeX = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        Value = math.floor(min + (max - min) * relativeX)
        SliderText.Text = name .. ": " .. Value
        
        Animate(SliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.1)
        Animate(SliderButton, {Position = UDim2.new(relativeX, -10, 0.5, -10)}, 0.1)
        
        if callback then
            callback(Value)
        end
    end
    
    local function StartSliding(input)
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if input then
                UpdateSlider(input)
            end
        end)
        
        local function EndSliding()
            connection:Disconnect()
        end
        
        if self.IsMobile then
            UserInputService.TouchEnded:Connect(EndSliding)
        else
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    EndSliding()
                end
            end)
        end
    end
    
    SliderButton.MouseButton1Down:Connect(function()
        StartSliding(UserInputService:GetMouseLocation())
    end)
    
    SliderTrack.MouseButton1Down:Connect(function(input)
        UpdateSlider(input)
        StartSliding(UserInputService:GetMouseLocation())
    end)
    
    -- Suporte mobile para slider
    if self.IsMobile then
        SliderButton.TouchTap:Connect(function()
            StartSliding(UserInputService:GetMouseLocation())
        end)
        
        SliderTrack.TouchTap:Connect(function(input)
            UpdateSlider(input)
            StartSliding(UserInputService:GetMouseLocation())
        end)
    end
    
    Slider.Set = function(value)
        Value = math.clamp(value, min, max)
        local relativeX = (Value - min) / (max - min)
        SliderText.Text = name .. ": " .. Value
        Animate(SliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.2)
        Animate(SliderButton, {Position = UDim2.new(relativeX, -10, 0.5, -10)}, 0.2)
    end
    
    Slider.Get = function()
        return Value
    end
    
    return Slider
end

-- Criar label premium
function PhoenixUI:CreateLabel(section, text, color)
    local Label = Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or Colors.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section.Frame
    })
    
    return Label
end

-- Criar dropdown premium
function PhoenixUI:CreateDropdown(section, name, options, default, callback)
    local Dropdown = {}
    local IsOpen = false
    local Selected = default or options[1]
    
    local DropdownFrame = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = section.Frame
    })
    
    local DropdownText = Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = DropdownFrame
    })
    
    local DropdownButton = Create("TextButton", {
        Name = "Button",
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 1, -30),
        BackgroundColor3 = Colors.Secondary,
        Text = Selected,
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.Gotham,
        AutoButtonColor = false,
        Parent = DropdownFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = DropdownButton})
    
    local DropdownIcon = Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(964, 324),
        ImageRectSize = Vector2.new(36, 36),
        ImageColor3 = Colors.TextSecondary,
        Parent = DropdownButton
    })
    
    local OptionsFrame = Create("ScrollingFrame", {
        Name = "Options",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        Parent = DropdownFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = OptionsFrame})
    
    local OptionsList = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = OptionsFrame
    })
    
    local function ToggleDropdown()
        IsOpen = not IsOpen
        if IsOpen then
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40 + math.min(#options * 35, 140) + 5)
            OptionsFrame.Size = UDim2.new(1, 0, 0, math.min(#options * 35, 140))
            OptionsFrame.Visible = true
            Animate(DropdownIcon, {Rotation = 180}, 0.3)
        else
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            OptionsFrame.Visible = false
            Animate(DropdownIcon, {Rotation = 0}, 0.3)
        end
    end
    
    local function SelectOption(option)
        Selected = option
        DropdownButton.Text = option
        ToggleDropdown()
        if callback then
            callback(option)
        end
    end
    
    -- Criar opções
    for i, option in ipairs(options) do
        local OptionButton = Create("TextButton", {
            Name = option,
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, (i-1)*35),
            BackgroundColor3 = Colors.Secondary,
            Text = option,
            TextColor3 = Colors.Text,
            TextSize = self.IsMobile and 16 or 14,
            Font = Enum.Font.Gotham,
            AutoButtonColor = false,
            Parent = OptionsFrame
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = OptionButton})
        
        OptionButton.MouseButton1Click:Connect(function()
            SelectOption(option)
        end)
        
        -- Efeitos hover
        OptionButton.MouseEnter:Connect(function()
            Animate(OptionButton, {BackgroundColor3 = Colors.AccentHover}, 0.2)
        end)
        
        OptionButton.MouseLeave:Connect(function()
            Animate(OptionButton, {BackgroundColor3 = Colors.Secondary}, 0.2)
        end)
    end
    
    OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, #options * 35)
    
    DropdownButton.MouseButton1Click:Connect(ToggleDropdown)
    
    Dropdown.Set = function(option)
        if table.find(options, option) then
            Selected = option
            DropdownButton.Text = option
        end
    end
    
    Dropdown.Get = function()
        return Selected
    end
    
    return Dropdown
end

-- Destruir UI
function PhoenixUI:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- Mostrar/Esconder UI
function PhoenixUI:Toggle()
    if self.ScreenGui then
        local isEnabled = self.ScreenGui.Enabled
        self.ScreenGui.Enabled = not isEnabled
        
        if not isEnabled then
            -- Efeito de entrada
            self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
            self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            Animate(self.MainFrame, {
                Size = UDim2.new(0, self.MainFrame.Size.X.Offset, 0, self.MainFrame.Size.Y.Offset),
                Position = UDim2.new(0.5, -self.MainFrame.Size.X.Offset/2, 0.5, -self.MainFrame.Size.Y.Offset/2)
            }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    end
end

return PhoenixUI
