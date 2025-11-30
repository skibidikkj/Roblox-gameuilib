-- Phoenix UI Library
local PhoenixUI = {}
PhoenixUI.__index = PhoenixUI

-- Serviços
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cores tema fênix (vermelho/laranja)
local Colors = {
    Main = Color3.fromRGB(20, 15, 20),
    Secondary = Color3.fromRGB(35, 25, 35),
    Accent = Color3.fromRGB(255, 80, 0),
    Success = Color3.fromRGB(0, 255, 100),
    Warning = Color3.fromRGB(255, 200, 0),
    Error = Color3.fromRGB(255, 50, 50),
    Text = Color3.fromRGB(255, 255, 255)
}

-- Função para criar instâncias rapidamente
local function Create(className, props)
    local instance = Instance.new(className)
    for prop, value in pairs(props) do
        instance[prop] = value
    end
    return instance
end

-- Animação suave
local function Animate(object, props, duration)
    local tweenInfo = TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, props)
    tween:Play()
    return tween
end

-- Criar janela principal
function PhoenixUI:CreateWindow(title)
    local self = setmetatable({}, PhoenixUI)
    
    self.Elements = {}
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- GUI principal
    self.ScreenGui = Create("ScreenGui", {
        Name = "PhoenixUI",
        ResetOnSpawn = false,
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    })
    
    -- Frame principal
    self.MainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = Colors.Main,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    })
    
    -- Borda arredondada
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = self.MainFrame})
    
    -- Efeito de brilho na borda
    Create("UIStroke", {
        Color = Colors.Accent,
        Thickness = 2,
        Parent = self.MainFrame
    })
    
    -- Cabeçalho
    local Header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Header})
    
    -- Título
    local Title = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "Phoenix UI",
        TextColor3 = Colors.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })
    
    -- Botão fechar
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        BackgroundColor3 = Colors.Error,
        TextColor3 = Colors.Text,
        Text = "X",
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = Header
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = CloseBtn})
    
    CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Efeito hover no botão fechar
    CloseBtn.MouseEnter:Connect(function()
        Animate(CloseBtn, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.2)
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        Animate(CloseBtn, {BackgroundColor3 = Colors.Error}, 0.2)
    end)
    
    -- Container de abas
    self.TabContainer = Create("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 120, 1, -45),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    -- Container de conteúdo
    self.ContentContainer = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -120, 1, -45),
        Position = UDim2.new(0, 120, 0, 45),
        BackgroundColor3 = Colors.Main,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = self.ContentContainer})
    
    -- Lista de abas
    self.TabList = Create("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.TabContainer
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.TabList
    })
    
    -- Sistema de arrastar
    local dragging = false
    local dragInput, dragStart, startPos
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    return self
end

-- Criar nova aba
function PhoenixUI:CreateTab(name)
    local Tab = {}
    
    -- Botão da aba
    local TabButton = Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, -10, 0, 40),
        Position = UDim2.new(0, 5, 0, 5 + (#self.Tabs * 45)),
        BackgroundColor3 = Colors.Secondary,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Parent = self.TabList
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabButton})
    
    -- Frame do conteúdo da aba
    local TabFrame = Create("ScrollingFrame", {
        Name = name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        Parent = self.ContentContainer
    })
    
    local UIListLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = TabFrame
    })
    
    -- Atualizar tamanho do canvas
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Função para mostrar esta aba
    local function ShowTab()
        if self.CurrentTab then
            self.CurrentTab.Button.BackgroundColor3 = Colors.Secondary
            self.CurrentTab.Frame.Visible = false
        end
        
        Animate(TabButton, {BackgroundColor3 = Colors.Accent}, 0.3)
        TabFrame.Visible = true
        self.CurrentTab = Tab
    end
    
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
    self.TabList.CanvasSize = UDim2.new(0, 0, 0, #self.Tabs * 45)
    
    return Tab
end

-- Criar seção
function PhoenixUI:CreateSection(tab, name)
    local Section = {}
    
    -- Frame da seção
    local SectionFrame = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        LayoutOrder = #tab.Frame:GetChildren(),
        Parent = tab.Frame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = SectionFrame})
    
    -- Título da seção
    local SectionTitle = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SectionFrame
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
        Padding = UDim.new(0, 5),
        Parent = ElementsContainer
    })
    
    -- Toggle da seção
    local Expanded = false
    
    local function ToggleSection()
        Expanded = not Expanded
        if Expanded then
            SectionFrame.Size = UDim2.new(1, -20, 0, 40 + ElementsList.AbsoluteContentSize.Y + 10)
            ElementsContainer.Visible = true
            SectionTitle.Text = "▼ " .. name
        else
            SectionFrame.Size = UDim2.new(1, -20, 0, 40)
            ElementsContainer.Visible = false
            SectionTitle.Text = "► " .. name
        end
    end
    
    SectionTitle.MouseButton1Click:Connect(ToggleSection)
    
    -- Atualizar tamanho quando elementos mudarem
    ElementsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if Expanded then
            SectionFrame.Size = UDim2.new(1, -20, 0, 40 + ElementsList.AbsoluteContentSize.Y + 10)
        end
    end)
    
    Section.Frame = ElementsContainer
    Section.Toggle = ToggleSection
    
    return Section
end

-- Criar botão
function PhoenixUI:CreateButton(section, name, callback)
    local Button = Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Colors.Secondary,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        AutoButtonColor = false,
        Parent = section.Frame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Button})
    
    -- Efeitos hover
    Button.MouseEnter:Connect(function()
        Animate(Button, {BackgroundColor3 = Colors.Accent}, 0.2)
    end)
    
    Button.MouseLeave:Connect(function()
        Animate(Button, {BackgroundColor3 = Colors.Secondary}, 0.2)
    end)
    
    -- Click
    Button.MouseButton1Click:Connect(function()
        Animate(Button, {BackgroundColor3 = Colors.Success}, 0.1)
        task.wait(0.1)
        Animate(Button, {BackgroundColor3 = Colors.Secondary}, 0.2)
        
        if callback then
            callback()
        end
    end)
    
    return Button
end

-- Criar toggle
function PhoenixUI:CreateToggle(section, name, default, callback)
    local Toggle = {}
    local State = default or false
    
    local ToggleFrame = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = section.Frame
    })
    
    local ToggleText = Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ToggleFrame
    })
    
    local ToggleButton = Create("Frame", {
        Name = "Toggle",
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -40, 0.5, -10),
        BackgroundColor3 = Colors.Secondary,
        Parent = ToggleFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleButton})
    
    local ToggleDot = Create("Frame", {
        Name = "Dot",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Colors.Text,
        Parent = ToggleButton
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleDot})
    
    local function UpdateToggle()
        if State then
            Animate(ToggleButton, {BackgroundColor3 = Colors.Success}, 0.2)
            Animate(ToggleDot, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
        else
            Animate(ToggleButton, {BackgroundColor3 = Colors.Secondary}, 0.2)
            Animate(ToggleDot, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        State = not State
        UpdateToggle()
        if callback then
            callback(State)
        end
    end)
    
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

-- Criar slider
function PhoenixUI:CreateSlider(section, name, min, max, default, callback)
    local Slider = {}
    local Value = default or min
    
    local SliderFrame = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = section.Frame
    })
    
    local SliderText = Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = name .. ": " .. Value,
        TextColor3 = Colors.Text,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SliderFrame
    })
    
    local SliderTrack = Create("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 1, -15),
        BackgroundColor3 = Colors.Secondary,
        Parent = SliderFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderTrack})
    
    local SliderFill = Create("Frame", {
        Name = "Fill",
        Size = UDim2.new((Value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Colors.Accent,
        Parent = SliderTrack
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderFill})
    
    local SliderButton = Create("TextButton", {
        Name = "Button",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new((Value - min) / (max - min), -8, 0.5, -8),
        BackgroundColor3 = Colors.Text,
        Text = "",
        Parent = SliderTrack
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderButton})
    
    local function UpdateSlider(input)
        local relativeX = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        Value = math.floor(min + (max - min) * relativeX)
        SliderText.Text = name .. ": " .. Value
        
        Animate(SliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.1)
        Animate(SliderButton, {Position = UDim2.new(relativeX, -8, 0.5, -8)}, 0.1)
        
        if callback then
            callback(Value)
        end
    end
    
    SliderButton.MouseButton1Down:Connect(function()
        local connection
        connection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                UpdateSlider(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)
    
    Slider.Set = function(value)
        Value = math.clamp(value, min, max)
        local relativeX = (Value - min) / (max - min)
        SliderText.Text = name .. ": " .. Value
        Animate(SliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.2)
        Animate(SliderButton, {Position = UDim2.new(relativeX, -8, 0.5, -8)}, 0.2)
    end
    
    Slider.Get = function()
        return Value
    end
    
    return Slider
end

-- Criar label
function PhoenixUI:CreateLabel(section, text)
    local Label = Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Colors.Text,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section.Frame
    })
    
    return Label
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
