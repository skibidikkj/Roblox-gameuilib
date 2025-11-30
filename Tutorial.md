🐉 Phoenix UI - Library para Roblox

https://img.shields.io/badge/Version-1.0.0-blue
https://img.shields.io/badge/Roblox-Luau-red
https://img.shields.io/badge/License-MIT-green

Uma UI library moderna para criar interfaces incríveis no Roblox! 🔥

🚀 COMO USAR (SUPER FÁCIL)

Passo 1: Pegue o Código da Library

```lua
-- COLE ESTA LINHA EM UM LOCALSCRIPT:
local PhoenixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidikkj/Roblox-gameuilib/main/PHOENIX%20UI.lua"))()
```

Passo 2: Crie sua Interface

```lua
-- Cria a janela principal
local MinhaJanela = PhoenixUI:CreateWindow("Meu Script")

-- Cria uma aba
local AbaPrincipal = MinhaJanela:CreateTab("Principal")

-- Cria uma seção
local SecaoPlayer = MinhaJanela:CreateSection(AbaPrincipal, "Player")

-- Adiciona um botão
MinhaJanela:CreateButton(SecaoPlayer, "Teleportar Base", function()
    print("Teleportado para a base!")
end)
```

Passo 3: Execute e Pronto!

Apenas rode o jogo e sua UI aparecerá na tela! 🎉

---

🎯 EXEMPLOS PRONTOS

Script Básico de Farm

```lua
local PhoenixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidikkj/Roblox-gameuilib/main/PHOENIX%20UI.lua"))()

local Window = PhoenixUI:CreateWindow("Farm Bot")

local FarmTab = Window:CreateTab("Farm")
local AutoSection = Window:CreateSection(FarmTab, "Auto Farm")

-- Toggle para farm automático
Window:CreateToggle(AutoSection, "Auto Farm", false, function(ativo)
    if ativo then
        print("Farm automático ATIVADO!")
    else
        print("Farm automático DESATIVADO!")
    end
end)

-- Botão para coletar tudo
Window:CreateButton(AutoSection, "Coletar Tudo", function()
    print("Coletando todos os itens...")
end)
```

Script de Hacks

```lua
local PhoenixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidikkj/Roblox-gameuilib/main/PHOENIX%20UI.lua"))()

local Window = PhoenixUI:CreateWindow("Hacks Menu")

local MoveTab = Window:CreateTab("Movement")
local MoveSection = Window:CreateSection(MoveTab, "Hacks")

-- Fly Hack
Window:CreateToggle(MoveSection, "Fly", false, function(ativo)
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
