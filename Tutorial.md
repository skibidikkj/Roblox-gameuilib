🐉 Phoenix UI - Advanced Roblox Library

https://img.shields.io/badge/Version-2.0.0-blue
https://img.shields.io/badge/Roblox-Luau-red
https://img.shields.io/badge/Lines-1000%2B-green
https://img.shields.io/badge/License-MIT-yellow

Uma biblioteca UI moderna e avançada para desenvolvimento no Roblox, com mais de 1000 linhas de código e recursos profissionais.

✨ Características Principais

· 🎨 4 Temas de Cores - DEFAULT, DARK, LIGHT, NEON
· ⚡ Sistema de Animações - 4 presets diferentes
· 🔧 15+ Elementos UI - Botões, Toggles, Sliders, Dropdowns, etc.
· 📱 Suporte Mobile - Interface adaptativa
· 🎯 Performance Otimizada - Cache e cleanup automático
· 🔒 Seguro - Sistema de execução protegido

🚀 Instalação Rápida

Método 1: Loadstring (Recomendado)

```lua
local PhoenixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/seu-usuario/phoenix-ui/main/PhoenixUI.lua"))()
```

Método 2: ModuleScript

```lua
-- Cole o código em um ModuleScript e require:
local PhoenixUI = require(script.Parent.PhoenixUI)
```

📖 Como Usar

Criação Básica da UI

```lua
-- Carregar a library
local PhoenixUI = loadstring(game:HttpGet("URL_DA_LIBRARY"))()

-- Criar janela principal
local Window = PhoenixUI:CreateWindow("Meu Script", "v2.0")

-- Criar abas
local MainTab = Window:CreateTab("Principal", "🏠")
local CombatTab = Window:CreateTab("Combat", "⚔️")
local VisualTab = Window:CreateTab("Visual", "👁️")

-- Criar seções
local PlayerSection = Window:CreateSection(MainTab, "Player")
local MovementSection = Window:CreateSection(MainTab, "Movement")
```

Adicionar Elementos

Botão Simples

```lua
Window:CreateButton(PlayerSection, "Teleportar Spawn", function()
    print("Teleportado para o spawn!")
end)
```

Toggle com Estado

```lua
local FlyToggle = Window:CreateToggle(MovementSection, "Fly Hack", false, function(state)
    if state then
        print("Fly ativado!")
    else
        print("Fly desativado!")
    end
end)
```

Slider de Valores

```lua
local SpeedSlider = Window:CreateSlider(MovementSection, "Velocidade", 16, 200, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    print("Velocidade alterada para: " .. value)
end)
```

Dropdown/Lista

```lua
local WeaponDropdown = Window:CreateDropdown(CombatTab, "Arma Preferida", {"Espada", "Arco", "Machado", "Lança"}, "Espada", function(selected)
    print("Arma selecionada: " .. selected)
end)
```

Color Picker

```lua
local ColorPicker = Window:CreateColorPicker(VisualTab, "Cor do ESP", Color3.fromRGB(255, 0, 0), function(color)
    print("Cor alterada: " .. tostring(color))
end)
```

Keybind/Tecla

```lua
local TeleportKeybind = Window:CreateKeybind(MovementSection, "Tecla Teleporte", Enum.KeyCode.T, function(key)
    print("Tecla de teleporte: " .. tostring(key))
end)
```

Campo de Texto

```lua
local NameTextbox = Window:CreateTextbox(PlayerSection, "Nome do Player", "Digite seu nome...", function(text)
    print("Texto digitado: " .. text)
end)
```

Toggle Executor (Especial)

```lua
local ScriptToggle = Window:CreateToggleExecutor(CombatTab, "Aimbot", 
    [[
        -- Código do aimbot aqui
        print("Aimbot executado!")
    ]], 
    "Ativa/Desativa sistema de aimbot automático"
)
```

🎨 Personalização Avançada

Temas de Cores

```lua
-- Criar janela com tema personalizado
local Window = PhoenixUI:CreateWindow("Meu Script", {
    theme = "DARK",  -- DEFAULT, DARK, LIGHT, NEON
    width = 600,
    height = 500,
    transparency = 0.1
})

-- Mudar tema dinamicamente
Window:ChangeTheme("NEON")
```

Animações Personalizadas

```lua
-- Os elementos já incluem animações automáticas:
- Hover effects suaves
- Transições de cor
- Animações de toggle
- Efeitos de clique
```

📱 Suporte Mobile

A UI detecta automaticamente se está em dispositivo móvel e ajusta:

· ✅ Tamanhos de fonte maiores
· ✅ Botões mais amplos
· ✅ Layout responsivo
· ✅ Gestos touch

⚡ Performance

Otimizações Incluídas:

· 🗃️ Cache de Instâncias - Elementos reutilizáveis
· 🎯 Tweens Otimizados - Animações com cancelamento
· 🧹 Cleanup Automático - Conexões gerenciadas
· 📦 Memória Eficiente - Coleta de lixo inteligente

Gerenciamento de Memória:

```lua
-- Destruir UI quando não for mais necessária
Window:Destroy()

-- Esconder/Mostrar UI
Window:Toggle()  -- Atalho: F9

-- Fechar completamente
Window:Destroy()
```

🔧 API Completa

Métodos da Janela

Método Descrição Exemplo
CreateWindow() Cria janela principal CreateWindow("Título")
CreateTab() Cria nova aba CreateTab("Nome", "🎮")
CreateSection() Cria seção organizada CreateSection(tab, "Seção")
Toggle() Mostra/esconde UI Toggle()
Destroy() Destrói a UI Destroy()

Elementos UI

Elemento Descrição Parâmetros
CreateButton() Botão clicável texto, callback
CreateToggle() Interruptor texto, padrão, callback
CreateSlider() Controle deslizante texto, min, max, padrão, callback
CreateDropdown() Lista suspensa texto, opções, padrão, callback
CreateColorPicker() Seletor de cores texto, cor padrão, callback
CreateKeybind() Configurador de tecla texto, tecla padrão, callback
CreateTextbox() Campo de texto texto, placeholder, callback
CreateLabel() Texto informativo texto, configurações
CreateToggleExecutor() Executor de scripts texto, código, descrição

🎯 Exemplos Práticos

Sistema de Hacks Completo

```lua
local PhoenixUI = loadstring(game:HttpGet("URL"))()
local Window = PhoenixUI:CreateWindow("Hacks Menu", "v2.0")

-- ABA MOVIMENTO
local MoveTab = Window:CreateTab("Movimento", "🏃")
local SpeedSection = Window:CreateSection(MoveTab, "Velocidade")

Window:CreateToggle(SpeedSection, "Speed Hack", false, function(state)
    if state then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

Window:CreateSlider(SpeedSection, "Velocidade", 16, 100, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- ABA VISUAL
local VisualTab = Window:CreateTab("Visual", "👁️")
local ESPSection = Window:CreateSection(VisualTab, "ESP")

Window:CreateToggle(ESPSection, "Player ESP", false, function(state)
    print("ESP Players: " .. tostring(state))
end)

Window:CreateColorPicker(ESPSection, "Cor ESP", Color3.fromRGB(255, 0, 0), function(color)
    print("Cor do ESP alterada")
end)

-- ABA COMBATE
local CombatTab = Window:CreateTab("Combate", "⚔️")
local AimbotSection = Window:CreateSection(CombatTab, "Aimbot")

Window:CreateToggleExecutor(AimbotSection, "Aimbot Auto", 
    [[
        _G.AimbotEnabled = true
        print("Aimbot ativado!")
    ]],
    "Sistema automático de mira"
)

Window:CreateKeybind(AimbotSection, "Tecla Aimbot", Enum.KeyCode.Q, function(key)
    print("Aimbot tecla: " .. tostring(key))
end)
```

Sistema de Farm Automático

```lua
local FarmTab = Window:CreateTab("Farm", "🤖")
local AutoSection = Window:CreateSection(FarmTab, "Automático")

Window:CreateToggleExecutor(AutoSection, "Auto Farm", 
    [[
        while _G.AutoFarm do
            -- Código de farm aqui
            task.wait(1)
        end
    ]],
    "Farm automático de recursos"
)

Window:CreateSlider(AutoSection, "Delay Farm", 1, 10, 3, function(value)
    _G.FarmDelay = value
end)
```

🐛 Solução de Problemas

Problemas Comuns:

❌ UI não aparece

```lua
-- Verifique:
-- 1. Está em LocalScript, não Script
-- 2. O URL do loadstring está correto
-- 3. O jogo está executando (Play)
```

❌ Elementos não funcionam

```lua
-- Verifique os callbacks:
-- CERTO: function() print("OK") end
-- ERRADO: function print("ERRO") end
```

❌ Erros de performance

```lua
-- Use o cleanup:
Window:Destroy() -- Quando não precisar mais
```

Debugging:

```lua
-- Ative mensagens de debug no Output
print("✅ UI Carregada!")
print("🎯 Elementos criados: " .. #Window.Elements)
```

🔄 Atualizações

v2.0.0 - Atualização Principal

· ✅ +1000 linhas de código
· ✅ 4 temas de cores
· ✅ 15+ elementos UI
· ✅ Suporte mobile nativo
· ✅ Sistema de animações
· ✅ Performance otimizada

Próximas Atualizações

· 🚀 Mais elementos UI
· 🎨 Editor de temas visual
· 📊 Gráficos e métricas
· 🔌 Sistema de plugins

🤝 Contribuindo

1. Fork o repositório
2. Crie uma branch: git checkout -b feature/nova-feature
3. Commit suas mudanças: git commit -m 'Adiciona nova feature'
4. Push para a branch: git push origin feature/nova-feature
5. Abra um Pull Request

📄 Licença

Este projeto está sob licença MIT. Veja o arquivo LICENSE para detalhes.

🎊 Suporte
hentai 
· 📧 Email: juniorcortez856@gmail.com
· 🐛 Issues: GitHub Issues
· 💬 Discord: Nao Temos Ainda!

---

⭐ Comece Agora!

```lua
-- COLE ESTE CÓDIGO E TESTE!
local PhoenixUI = loadstring(game:HttpGet("URL_DA_SUA_LIBRARY"))()

local Window = PhoenixUI:CreateWindow("Minha UI")
local Tab = Window:CreateTab("Teste")
local Section = Window:CreateSection(Tab, "Elementos")

Window:CreateButton(Section, "Testar UI", function()
    print("🎉 Phoenix UI funcionando perfeitamente!")
end)

print("🚀 UI Inicializada com Sucesso!")
```

Desenvolvido com ❤️ para a comunidade RobloxWindow:CreateToggle(MoveSection, "Fly", false, function(ativo)
    if ativo then
        print("Fly ATIVADO - Pressione E para voar!")
    else
        print("Fly DESATIVADO")
    end
end)

-- Speed Hack
Window:CreateSlider(MoveSection, "Velocidade", 16, 200, 16, function(valor)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = valor
    print("Velocidade alterada para: " .. valor)
end)

-- Noclip
Window:CreateToggle(MoveSection, "NoClip", false, function(ativo)
    print("NoClip: " .. (ativo and "ATIVADO" or "DESATIVADO"))
end)
```

Script de ESP/Visual

```lua
local PhoenixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidikkj/Roblox-gameuilib/main/PHOENIX%20UI.lua"))()

local Window = PhoenixUI:CreateWindow("Visual Hacks")

local VisualTab = Window:CreateTab("Visual")
local ESPSection = Window:CreateSection(VisualTab, "ESP")

Window:CreateToggle(ESPSection, "Player ESP", false, function(ativo)
    print("Player ESP: " .. (ativo and "ON" or "OFF"))
end)

Window:CreateToggle(ESPSection, "Item ESP", false, function(ativo)
    print("Item ESP: " .. (ativo and "ON" or "OFF"))
end)

Window:CreateButton(ESPSection, "Remover ESP", function()
    print("Todos ESP removidos!")
end)
```

---

🛠️ COMO CRIAR SEU PRÓPRIO SCRIPT

Estrutura Básica:

```lua
local PhoenixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidikkj/Roblox-gameuilib/main/PHOENIX%20UI.lua"))()

-- 1. Cria janela
local Window = PhoenixUI:CreateWindow("Nome do Seu Script")

-- 2. Cria abas
local Tab1 = Window:CreateTab("Aba 1")
local Tab2 = Window:CreateTab("Aba 2")

-- 3. Cria seções
local SectionA = Window:CreateSection(Tab1, "Seção A")
local SectionB = Window:CreateSection(Tab1, "Seção B")

-- 4. Adiciona elementos
Window:CreateButton(SectionA, "Meu Botão", function()
    -- O que acontece quando clicar
    print("Botão clicado!")
end)

Window:CreateToggle(SectionA, "Meu Toggle", false, function(estado)
    print("Toggle: " .. estado)
end)

Window:CreateSlider(SectionB, "Meu Slider", 0, 100, 50, function(valor)
    print("Slider: " .. valor)
end)
```

---

🎨 ELEMENTOS DISPONÍVEIS

📋 Todos os elementos que você pode usar:

```lua
-- Botão simples
Window:CreateButton(section, "Nome", function()
    -- Código aqui
end)

-- Toggle (liga/desliga)
Window:CreateToggle(section, "Nome", valor_inicial, function(estado)
    print("Toggle: " .. tostring(estado))
end)

-- Slider (valores)
Window:CreateSlider(section, "Nome", min, max, padrão, function(valor)
    print("Valor: " .. valor)
end)

-- Label (texto)
Window:CreateLabel(section, "Texto da label")

-- Dropdown (lista)
Window:CreateDropdown(section, "Nome", {"Opção1", "Opção2"}, function(selecionado)
    print("Selecionado: " .. selecionado)
end)

-- Textbox (input)
Window:CreateTextbox(section, "Nome", function(texto)
    print("Texto digitado: " .. texto)
end)
```

---

⚡ EXEMPLO COMPLETO - SCRIPT DE JOGO

```lua
local PhoenixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidikkj/Roblox-gameuilib/main/PHOENIX%20UI.lua"))()

local Window = PhoenixUI:CreateWindow("Meu Hack Menu")

-- ABA PRINCIPAL
local MainTab = Window:CreateTab("Principal")
local PlayerSection = Window:CreateSection(MainTab, "Player")

Window:CreateButton(PlayerSection, "Curar Vida", function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = char.Humanoid.MaxHealth
        print("Vida curada!")
    end
end)

Window:CreateToggle(PlayerSection, "God Mode", false, function(ativo)
    print("God Mode: " .. (ativo and "ATIVADO" or "DESATIVADO"))
end)

-- ABA MOVIMENTO
local MoveTab = Window:CreateTab("Movimento")
local SpeedSection = Window:CreateSection(MoveTab, "Velocidade")

Window:CreateSlider(SpeedSection, "WalkSpeed", 16, 200, 16, function(valor)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = valor
end)

Window:CreateSlider(SpeedSection, "JumpPower", 50, 200, 50, function(valor)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = valor
end)

-- ABA VISUAL
local VisualTab = Window:CreateTab("Visual")
local CameraSection = Window:CreateSection(VisualTab, "Câmera")

Window:CreateToggle(CameraSection, "FOV Changer", false, function(ativo)
    if ativo then
        game.Workspace.CurrentCamera.FieldOfView = 120
    else
        game.Workspace.CurrentCamera.FieldOfView = 70
    end
end)

print("Script carregado com sucesso! Pressione F9 para abrir/fechar o menu.")
```

---

❓ PERGUNTAS FREQUENTES

❔ A UI não aparece?

· ✅ Verifique se está em um LocalScript
· ✅ Verifique se a URL está correta
· ✅ Execute o jogo (Play)

❔ Botões não funcionam?

```lua
-- CERTO:
function() print("Funciona!") end

-- ERRADO:
function print("Não funciona!") end
```

❔ Como customizar cores?

```lua
-- Adicione ANTES de CreateWindow:
PhoenixUI.Colors.Main = Color3.fromRGB(30, 30, 40)
PhoenixUI.Colors.Accent = Color3.fromRGB(0, 255, 150)
```

---

🎊 PRONTO PARA USAR!

```lua
-- COPIAR E COLAR - FUNCIONA 100%!
local PhoenixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidikkj/Roblox-gameuilib/main/PHOENIX%20UI.lua"))()

local Window = PhoenixUI:CreateWindow("Meu Script")
local Tab = Window:CreateTab("Principal")
local Section = Window:CreateSection(Tab, "Comandos")

Window:CreateButton(Section, "Testar", function()
    print("UI funcionando perfeitamente! 🎉")
end)
```

Agora é só criar e ser feliz! Sua UI profissional está pronta! 😎🔥
