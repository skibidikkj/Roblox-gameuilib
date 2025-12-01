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
