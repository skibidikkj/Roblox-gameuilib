-- Phoenix UI Premium - Toggle Executor System
local PhoenixUI = {}
PhoenixUI.__index = PhoenixUI

-- Serviços
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Cores tema fênix premium melhorado
local Colors = {
    Main = Color3.fromRGB(12, 8, 18),
    Secondary = Color3.fromRGB(25, 18, 35),
    Accent = Color3.fromRGB(255, 65, 0),
    AccentHover = Color3.fromRGB(255, 100, 30),
    Success = Color3.fromRGB(0, 230, 80),
    Warning = Color3.fromRGB(255, 180, 0),
    Error = Color3.fromRGB(230, 40, 40),
    Text = Color3.fromRGB(245, 245, 245),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Dark = Color3.fromRGB(8, 4, 12)
}

-- Cache de instâncias para performance
local InstanceCache = {}
local ActiveTweens = {}

-- Função para criar instâncias rapidamente com cache
local function Create(className, props)
    local instance = Instance.new(className)
    for prop, value in pairs(props) do
        if prop == "Children" then
            for _, child in ipairs(value) do
                child.Parent = instance
            end
        else
            pcall(function() instance[prop] = value end)
        end
    end
    return instance
end

-- Sistema de animação otimizado
local function Animate(object, props, duration, easingStyle, easingDirection)
    -- Cancelar tween anterior se existir
    if ActiveTweens[object] then
        ActiveTweens[object]:Cancel()
    end
    
    local tweenInfo = TweenInfo.new(
        duration or 0.25,
        easingStyle or Enum.EasingStyle.Quint,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, props)
    ActiveTweens[object] = tween
    tween:Play()
    
    tween.Completed:Connect(function()
        ActiveTweens[object] = nil
    end)
    
    return tween
end

-- Sistema de execução de scripts melhorado
local ScriptExecutor = {
    ExecutedScripts = {},
    ActiveToggles = {},
    ScriptEnvironments = {}
}

function ScriptExecutor:ExecuteScript(scriptCode, toggleName)
    local success, result = pcall(function()
        -- Criar environment seguro
        local env = {}
        setmetatable(env, {
            __index = function(_, key)
                return getfenv()[key]
            end
        })
        
        -- Executar script
        local func, err = loadstring(scriptCode)
        if not func then
            error("Erro de sintaxe: " .. tostring(err))
        end
        
        setfenv(func, env)
        return func()
    end)
    
    if success then
        self.ExecutedScripts[toggleName] = true
        self.ScriptEnvironments[toggleName] = result
        return true, "✅ Script executado!"
    else
        self.ExecutedScripts[toggleName] = false
        return false, "❌ Erro: " .. tostring(result)
    end
end

function ScriptExecutor:StopScript(toggleName)
    self.ExecutedScripts[toggleName] = false
    self.ScriptEnvironments[toggleName] = nil
    return true, "⏹️ Script parado!"
end

-- Detectar dispositivo e ajustes
local function IsMobile()
    return UserInputService.TouchEnabled
end

local MOBILE_ADJUSTMENTS = {
    Scale = 1.4,
    FontSizeMultiplier = 1.3,
    ButtonHeight = 50,
    TabHeight = 55,
    HeaderHeight = 65
}

-- Criar janela principal SUPER OTIMIZADA
function PhoenixUI:CreateWindow(title, subtitle, config)
    local self = setmetatable({}, PhoenixUI)
    
    self.Elements = {}
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsMobile = IsMobile()
    self.Config = config or {}
    
    -- Configurações com defaults
    local scale = self.IsMobile and MOBILE_ADJUSTMENTS.Scale or 1
    local width = (self.Config.width or 500) * scale
    local height = (self.Config.height or 450) * scale
    
    -- GUI principal
    self.ScreenGui = Create("ScreenGui", {
        Name = "PhoenixUIPremium",
        ResetOnSpawn = false,
        DisplayOrder = 999,
        Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    })
    
    -- Frame principal com design moderno
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
    local corner = Create("UICorner", {CornerRadius = UDim.new(0, 14)})
    corner.Parent = self.MainFrame
    
    local stroke = Create("UIStroke", {
        Color = Colors.Accent,
        Thickness = 2.5,
        Transparency = 0.3,
    })
    stroke.Parent = self.MainFrame
    
    -- Cabeçalho premium
    local headerHeight = self.IsMobile and MOBILE_ADJUSTMENTS.HeaderHeight or 55
    local Header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, headerHeight),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 14)}).Parent = Header
    
    -- Gradiente sutil no header
    local headerGradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Colors.Secondary),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 25, 45))
        }),
        Rotation = 90
    })
    headerGradient.Parent = Header
    
    -- Título e subtítulo
    local TitleContainer = Create("Frame", {
        Name = "TitleContainer",
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Parent = Header
    })
    
    local Title = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0.6, 0),
        BackgroundTransparency = 1,
        Text = title or "PHOENIX UI",
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 22 or 20,
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
        Text = subtitle or "Premium Executor",
        TextColor3 = Colors.TextSecondary,
        TextSize = self.IsMobile and 14 or 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = TitleContainer
    })
    
    -- Botões de controle (VERDE E VERMELHO)
    local ControlButtons = Create("Frame", {
        Name = "ControlButtons",
        Size = UDim2.new(0.25, 0, 1, 0),
        Position = UDim2.new(0.75, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = Header
    })
    
    -- Botão minimizar (VERDE)
    local MinimizeBtn = Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0.5, -40, 0.5, -16),
        BackgroundColor3 = Colors.Success,
        TextColor3 = Colors.Text,
        Text = "─",
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = ControlButtons
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}).Parent = MinimizeBtn
    
    -- Botão fechar (VERMELHO)
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -37, 0.5, -16),
        BackgroundColor3 = Colors.Error,
        TextColor3 = Colors.Text,
        Text = "×",
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = ControlButtons
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}).Parent = CloseBtn
    
    -- Container de abas
    self.TabContainer = Create("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 150, 1, -headerHeight),
        Position = UDim2.new(0, 0, 0, headerHeight),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 14)}).Parent = self.TabContainer
    
    -- Container de conteúdo
    self.ContentContainer = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -150, 1, -headerHeight),
        Position = UDim2.new(0, 150, 0, headerHeight),
        BackgroundColor3 = Colors.Main,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 14)}).Parent = self.ContentContainer
    
    -- Lista de abas
    self.TabList = Create("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, -15, 1, -20),
        Position = UDim2.new(0, 8, 0, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.TabContainer
    })
    
    local tabListLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
    })
    tabListLayout.Parent = self.TabList
    
    -- Funções dos botões
    MinimizeBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Efeitos hover otimizados
    local function SetupButtonEffects(button, normalColor, hoverColor)
        button.MouseEnter:Connect(function()
            Animate(button, {BackgroundColor3 = hoverColor, Size = UDim2.new(0, 34, 0, 34)}, 0.15)
        end)
        
        button.MouseLeave:Connect(function()
            Animate(button, {BackgroundColor3 = normalColor, Size = UDim2.new(0, 32, 0, 32)}, 0.15)
        end)
    end
    
    SetupButtonEffects(MinimizeBtn, Colors.Success, Color3.fromRGB(80, 255, 120))
    SetupButtonEffects(CloseBtn, Colors.Error, Color3.fromRGB(255, 80, 80))
    
    -- Sistema de arrastar melhorado
    local dragging = false
    local dragStart, startPos
    
    local function Update(input)
        if not dragging then return end
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
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Update(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Atalho de teclado (F9)
    local toggleConnection
    toggleConnection = UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F9 then
            self:Toggle()
        end
    end)
    
    self.Destroy = function()
        if toggleConnection then
            toggleConnection:Disconnect()
        end
        if self.ScreenGui then
            self.ScreenGui:Destroy()
        end
    end
    
    return self
end

-- Criar aba otimizada
function PhoenixUI:CreateTab(name, icon)
    local Tab = {}
    
    local tabHeight = self.IsMobile and MOBILE_ADJUSTMENTS.TabHeight or 48
    
    -- Botão da aba
    local TabButton = Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, -10, 0, tabHeight),
        BackgroundColor3 = Colors.Secondary,
        AutoButtonColor = false,
        Text = "",
        Parent = self.TabList
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 10)}).Parent = TabButton
    
    -- Conteúdo do botão
    local ButtonContent = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = TabButton
    })
    
    local TabText = Create("TextLabel", {
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
    
    local ActiveIndicator = Create("Frame", {
        Size = UDim2.new(0, 4, 0.6, 0),
        Position = UDim2.new(1, -8, 0.2, 0),
        BackgroundColor3 = Colors.Accent,
        Visible = false,
        Parent = ButtonContent
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}).Parent = ActiveIndicator
    
    -- Frame de conteúdo
    local TabFrame = Create("ScrollingFrame", {
        Name = name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        Parent = self.ContentContainer
    })
    
    local UIListLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 15),
    })
    UIListLayout.Parent = TabFrame
    
    -- Atualizar canvas size
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Função para mostrar aba
    local function ShowTab()
        if self.CurrentTab then
            Animate(self.CurrentTab.Button, {BackgroundColor3 = Colors.Secondary}, 0.25)
            Animate(self.CurrentTab.Button:FindFirstChildOfClass("TextLabel"), {TextColor3 = Colors.TextSecondary}, 0.25)
            self.CurrentTab.Button:FindFirstChild("ActiveIndicator").Visible = false
            self.CurrentTab.Frame.Visible = false
        end
        
        Animate(TabButton, {BackgroundColor3 = Color3.fromRGB(40, 28, 50)}, 0.25)
        Animate(TabText, {TextColor3 = Colors.Text}, 0.25)
        ActiveIndicator.Visible = true
        TabFrame.Visible = true
        self.CurrentTab = Tab
    end
    
    -- Efeitos hover
    TabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= Tab then
            Animate(TabButton, {BackgroundColor3 = Color3.fromRGB(35, 25, 42)}, 0.2)
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
    
    table.insert(self.Tabs, Tab)
    
    -- Mostrar primeira aba
    if #self.Tabs == 1 then
        task.wait(0.1) -- Pequeno delay para animação
        ShowTab()
    end
    
    -- Atualizar canvas
    self.TabList.CanvasSize = UDim2.new(0, 0, 0, #self.Tabs * (tabHeight + 10))
    
    return Tab
end

-- Criar seção melhorada
function PhoenixUI:CreateSection(tab, name)
    local Section = {}
    
    local SectionFrame = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, -20, 0, 55),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        LayoutOrder = #tab.Frame:GetChildren(),
        Parent = tab.Frame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 12)}).Parent = SectionFrame
    
    Create("UIStroke", {
        Color = Color3.fromRGB(60, 45, 75),
        Thickness = 1.5,
    }).Parent = SectionFrame
    
    -- Header da seção
    local SectionHeader = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundTransparency = 1,
        Parent = SectionFrame
    })
    
    local SectionTitle = Create("TextLabel", {
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
        Position = UDim2.new(0, 5, 1, 8),
        BackgroundTransparency = 1,
        Parent = SectionFrame
    })
    
    local ElementsList = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
    })
    ElementsList.Parent = ElementsContainer
    
    Section.Frame = ElementsContainer
    
    return Section
end

-- 🎯 **TOGGLE EXECUTOR MELHORADO**
function PhoenixUI:CreateToggleExecutor(section, name, scriptCode, description)
    local Toggle = {}
    local State = false
    local ToggleName = name
    
    local ToggleFrame = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundTransparency = 1,
        Parent = section.Frame
    })
    
    -- Container principal
    local ToggleContainer = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Colors.Secondary,
        Parent = ToggleFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 10)}).Parent = ToggleContainer
    Create("UIStroke", {
        Color = Color3.fromRGB(60, 45, 75),
        Thickness = 1,
    }).Parent = ToggleContainer
    
    -- Informações
    local InfoFrame = Create("Frame", {
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = ToggleContainer
    })
    
    local ToggleText = Create("TextLabel", {
        Size = UDim2.new(1, -15, 0, 28),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 16 or 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = InfoFrame
    })
    
    local ToggleDesc = Create("TextLabel", {
        Size = UDim2.new(1, -15, 0, 20),
        Position = UDim2.new(0, 12, 0, 36),
        BackgroundTransparency = 1,
        Text = description or "Click to execute/stop",
        TextColor3 = Colors.TextSecondary,
        TextSize = self.IsMobile and 12 or 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = InfoFrame
    })
    
    -- Botão toggle (VERMELHO/VERDE)
    local ToggleButton = Create("TextButton", {
        Size = UDim2.new(0, 85, 0, 38),
        Position = UDim2.new(1, -92, 0.5, -19),
        BackgroundColor3 = Colors.Error, -- Vermelho quando off
        AutoButtonColor = false,
        Text = "OFF",
        TextColor3 = Colors.Text,
        TextSize = self.IsMobile and 14 or 12,
        Font = Enum.Font.GothamBold,
        Parent = ToggleContainer
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}).Parent = ToggleButton
    Create("UIStroke", {
        Color = Colors.Text,
        Thickness = 2,
    }).Parent = ToggleButton
    
    -- Indicador de status
    local StatusIndicator = Create("Frame", {
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = Colors.Error,
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}).Parent = StatusIndicator
    StatusIndicator.Parent = ToggleContainer
    
    local function UpdateToggle()
        if State then
            -- Ligado - VERDE
            Animate(ToggleButton, {BackgroundColor3 = Colors.Success}, 0.3)
            Animate(StatusIndicator, {BackgroundColor3 = Colors.Success}, 0.3)
            ToggleButton.Text = "ON"
            
            -- Executar script
            local success, message = ScriptExecutor:ExecuteScript(scriptCode, ToggleName)
            if not success then
                warn("❌ Erro em '" .. ToggleName .. "': " .. message)
                State = false
                UpdateToggle()
            end
        else
            -- Desligado - VERMELHO
            Animate(ToggleButton, {BackgroundColor3 = Colors.Error}, 0.3)
            Animate(StatusIndicator, {BackgroundColor3 = Colors.Error}, 0.3)
            ToggleButton.Text = "OFF"
            
            -- Parar script
            ScriptExecutor:StopScript(ToggleName)
        end
    end
    
    local function ToggleState()
        State = not State
        UpdateToggle()
    end
    
    -- Efeitos hover
    ToggleButton.MouseEnter:Connect(function()
        Animate(ToggleButton, {Size = UDim2.new(0, 88, 0, 40)}, 0.15)
    end)
    
    ToggleButton.MouseLeave:Connect(function()
        Animate(ToggleButton, {Size = UDim2.new(0, 85, 0, 38)}, 0.15)
    end)
    
    ToggleButton.MouseButton1Click:Connect(ToggleState)
    
    -- Métodos públicos
    Toggle.Set = function(value)
        State = value
        UpdateToggle()
    end
    
    Toggle.Get = function()
        return State
    end
    
    Toggle.Execute = function()
        if not State then
            ToggleState()
        end
    end
    
    Toggle.Stop = function()
        if State then
            ToggleState()
        end
    end
    
    UpdateToggle()
    return Toggle
end

-- Botão de script rápido
function PhoenixUI:CreateScriptButton(section, name, scriptCode, description)
    local buttonHeight = self.IsMobile and MOBILE_ADJUSTMENTS.ButtonHeight or 42
    
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
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}).Parent = Button
    
    -- Efeitos hover
    Button.MouseEnter:Connect(function()
        Animate(Button, {BackgroundColor3 = Colors.AccentHover, Size = UDim2.new(1, 4, 0, buttonHeight + 2)}, 0.2)
    end)
    
    Button.MouseLeave:Connect(function()
        Animate(Button, {BackgroundColor3 = Colors.Accent, Size = UDim2.new(1, 0, 0, buttonHeight)}, 0.2)
    end)
    
    -- Executar script
    Button.MouseButton1Click:Connect(function()
        Animate(Button, {BackgroundColor3 = Colors.Success}, 0.1)
        local success, message = ScriptExecutor:ExecuteScript(scriptCode, name)
        if success then
            task.wait(0.3)
            Animate(Button, {BackgroundColor3 = Colors.Accent}, 0.2)
        else
            Animate(Button, {BackgroundColor3 = Colors.Error}, 0.3)
            task.wait(0.5)
            Animate(Button, {BackgroundColor3 = Colors.Accent}, 0.2)
        end
    end)
    
    return Button
end

-- Mostrar/Esconder UI com animação
function PhoenixUI:Toggle()
    if self.ScreenGui then
        local isEnabled = self.ScreenGui.Enabled
        self.ScreenGui.Enabled = not isEnabled
    end
end

return PhoenixUI
