--[[
╔═══════════════════════════════════════════════════════╗
║            CoiledTom Hub  |  WindUI v2               ║
║   ESP Box2D + Chams + Tracers + Distance + Health     ║
║   Anti-AFK · Anti-Kick · Anti-Void · Performance     ║
║              PC & Mobile Ready                        ║
╚═══════════════════════════════════════════════════════╝
]]

-- ═══════════════════════════════════
--  LOAD WindUI v2
-- ═══════════════════════════════════
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

-- ═══════════════════════════════════
--  SERVICES
-- ═══════════════════════════════════
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local TeleportService  = game:GetService("TeleportService")
local StarterGui       = game:GetService("StarterGui")
local Lighting         = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

-- ═══════════════════════════════════
--  ESTADO GLOBAL
-- ═══════════════════════════════════
local State = {
    TouchFling    = false,
    AntiFling     = false,
    GodMode       = false,
    _godConn      = nil,
    AntiVoid      = false,
    AntiStun      = false,
    DeleteRagdoll = false,
    AutoRejoin    = false,
    AntiAFK       = false,
    AntiKick      = false,
    WalkSpeed     = 16,
    JumpPower     = 50,
    InfiniteJump  = false,
    AimbotEnabled = false,
    TeamCheck     = false,
    AimbotFOV     = 120,
    AimbotSmooth  = 5,
    ESPEnabled    = false,
    ESPColor      = Color3.fromRGB(255, 50, 50),
    ESPFill       = false,
    ESPFillAlpha  = 0.15,
    ChamEnabled   = false,
    ChamColor     = Color3.fromRGB(255, 100, 0),
    TracerEnabled = false,
    TracerColor   = Color3.fromRGB(0, 255, 128),
    DistESP       = false,
    HealthESP     = false,
    HitboxEnabled = false,
    HitboxSize    = 5,
    HitboxAlpha   = 0.5,
    HitboxPart    = "HumanoidRootPart",
    AntiLag          = false,
    FPSBoost         = false,
    DisableParticles = false,
    TextureLow       = false,
    RemoveDecals     = false,
    DynRender        = false,
    EntityLimiter    = false,
    LightingClean    = false,
    LowPoly          = false,
}

-- ═══════════════════════════════════
--  HELPERS
-- ═══════════════════════════════════
local function getChar()
    return LocalPlayer.Character
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function getRoot()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function isEnemy(p)
    if not State.TeamCheck then return true end
    return p.Team ~= LocalPlayer.Team
end

-- ═══════════════════════════════════
--  WINDOW
-- ═══════════════════════════════════
local Window = WindUI:CreateWindow({
    Title       = "CoiledTom Hub",
    Icon        = "solar:planet-bold",
    Author      = "by CoiledTom",
    Folder      = "CoiledTomHub",
    Size        = UDim2.fromOffset(600, 500),
    Theme       = "Dark",
    Transparent = true,
})

-- ═══════════════════════════════════
--  TABS
-- ═══════════════════════════════════
local TabLogs    = Window:Tab({ Title = "Logs",       Icon = "solar:document-text-bold"  })
local TabUseful  = Window:Tab({ Title = "Useful",     Icon = "solar:bomb-bold"           })
local TabScripts = Window:Tab({ Title = "Scripts",    Icon = "solar:code-square-bold"    })
local TabPlayer  = Window:Tab({ Title = "Player",     Icon = "solar:running-round-bold"  })
local TabCombat  = Window:Tab({ Title = "Combat",     Icon = "solar:target-bold"         })
local TabPerf    = Window:Tab({ Title = "Desempenho", Icon = "solar:cpu-bolt-bold"       })
local TabSettings= Window:Tab({ Title = "Settings",   Icon = "solar:settings-bold"       })

-- ══════════════════════════════════════════════════════
--  ABA: LOGS
-- ══════════════════════════════════════════════════════
do
    TabLogs:Section({ Title = "💬 Suporte" })

    TabLogs:Section({
        Title = "Aqui está o Discord caso ache um bug ou erro:",
    })

    TabLogs:Button({
        Title = "Copiar link do Discord",
        Desc  = "discord.gg/xzHe9QeqVv",
        Icon  = "link",
        Callback = function()
            setclipboard("https://discord.gg/xzHe9QeqVv")
            WindUI:Notify({
                Title    = "Discord",
                Content  = "Link copiado! discord.gg/xzHe9QeqVv",
                Duration = 3,
            })
        end,
    })

    TabLogs:Section({ Title = "📋 Histórico de Atualizações" })

    local changelog = {
        {
            ver   = "v3.0  —  Mega Update",
            items = {
                "[NOVO] Nome: CoiledTom Hub",
                "[NOVO] Aba Logs com Discord + changelog",
                "[NOVO] WindUI v2 (latest release)",
                "[NOVO] Anti-AFK, Anti-Kick / Anti-Ban",
                "[NOVO] God Mode (vida infinita)",
                "[NOVO] Chams, Tracers, Distance ESP, Health ESP",
                "[NOVO] Anti-Void, Anti-Stun, Delete Ragdoll",
                "[NOVO] Auto Rejoin, Server Hopper inteligente",
                "[NOVO] Aba Desempenho — 9 toggles",
                "[MELHORIA] ESP Box 2D mais preciso",
                "[MELHORIA] Compatibilidade mobile melhorada",
            },
        },
        {
            ver   = "v2.0",
            items = {
                "[NOVO] ESP Box 2D com Drawing API",
                "[NOVO] Aimbot com FOV Circle",
                "[NOVO] Hitbox Expander com fill",
            },
        },
        {
            ver   = "v1.0  —  Lançamento",
            items = {
                "[NOVO] Hub base com WindUI",
                "[NOVO] WalkSpeed / JumpPower / InfiniteJump",
                "[NOVO] Tools e GUIs via loadstring",
            },
        },
    }

    for _, entry in ipairs(changelog) do
        TabLogs:Section({ Title = "🔖 " .. entry.ver })
        local txt = ""
        for _, item in ipairs(entry.items) do
            txt = txt .. item .. "\n"
        end
        TabLogs:Section({ Title = txt })
    end
end

-- ══════════════════════════════════════════════════════
--  SISTEMAS
-- ══════════════════════════════════════════════════════

-- Touch Fling
local touchConn = nil
local function startFling()
    if touchConn then return end
    touchConn = RunService.Heartbeat:Connect(function()
        local root = getRoot()
        if not root then return end
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and p ~= root
               and (p.Position - root.Position).Magnitude < 5 then
                local bv    = Instance.new("BodyVelocity")
                bv.Velocity = (p.Position - root.Position).Unit * -500
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.P        = 1e9
                bv.Parent   = p
                game:GetService("Debris"):AddItem(bv, 0.1)
            end
        end
    end)
end
local function stopFling()
    if touchConn then touchConn:Disconnect(); touchConn = nil end
end

-- Anti-Fling
local antiFlingConn = nil
local function startAntiFling()
    if antiFlingConn then return end
    antiFlingConn = RunService.Heartbeat:Connect(function()
        local char = getChar()
        if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart")
               and p.AssemblyLinearVelocity.Magnitude > 200 then
                p.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end
local function stopAntiFling()
    if antiFlingConn then antiFlingConn:Disconnect(); antiFlingConn = nil end
end

-- God Mode
local function applyGodMode(hum)
    if State._godConn then State._godConn:Disconnect() end
    hum.MaxHealth = math.huge
    hum.Health    = math.huge
    State._godConn = hum.HealthChanged:Connect(function()
        if State.GodMode then hum.Health = math.huge end
    end)
end
local function removeGodMode(hum)
    if State._godConn then State._godConn:Disconnect(); State._godConn = nil end
    hum.MaxHealth = 100
    hum.Health    = 100
end

-- Anti-Void
local antiVoidConn = nil
local safePos      = Vector3.new(0, 50, 0)
local function startAntiVoid()
    if antiVoidConn then return end
    antiVoidConn = RunService.Heartbeat:Connect(function()
        local root = getRoot()
        if not root then return end
        if root.Position.Y > -50 then
            safePos = root.Position
        else
            root.CFrame = CFrame.new(safePos)
        end
    end)
end
local function stopAntiVoid()
    if antiVoidConn then antiVoidConn:Disconnect(); antiVoidConn = nil end
end

-- Anti-Stun
local antiStunConn = nil
local function startAntiStun()
    if antiStunConn then return end
    antiStunConn = RunService.Heartbeat:Connect(function()
        local hum = getHum()
        if not hum then return end
        local s = hum:GetState()
        if s == Enum.HumanoidStateType.Stunned
           or s == Enum.HumanoidStateType.FallingDown then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end
local function stopAntiStun()
    if antiStunConn then antiStunConn:Disconnect(); antiStunConn = nil end
end

-- Delete Ragdoll
local function deleteRagdoll()
    local char = getChar()
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint")
           or v.Name == "Ragdoll" or v.Name == "RagdollConstraint" then
            v:Destroy()
        end
    end
end

-- Anti-AFK
local antiAFKConn = nil
local function startAntiAFK()
    if antiAFKConn then return end
    LocalPlayer.Idled:Connect(function()
        if State.AntiAFK then
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "Anti-AFK", Text = "Kick evitado!", Duration = 2,
                })
            end)
        end
    end)
    antiAFKConn = RunService.Heartbeat:Connect(function()
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            vim:SendKeyEvent(true,  Enum.KeyCode.W, false, game)
            vim:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        end)
    end)
end
local function stopAntiAFK()
    if antiAFKConn then antiAFKConn:Disconnect(); antiAFKConn = nil end
end

-- Anti-Kick
local kickHooked = false
local function hookAntiKick()
    if kickHooked then return end
    kickHooked = true
    local mt = getrawmetatable and getrawmetatable(game)
    if not mt then return end
    local oldNC = mt.__namecall
    pcall(setreadonly, mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod and getnamecallmethod() or ""
        if method == "Kick" and self == LocalPlayer and State.AntiKick then
            WindUI:Notify({ Title="Anti-Kick", Content="Kick bloqueado!", Duration=3 })
            return
        end
        return oldNC(self, ...)
    end)
    pcall(setreadonly, mt, true)
end

-- Auto Rejoin
local function setupAutoRejoin()
    LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed and State.AutoRejoin then
            task.wait(3)
            TeleportService:TeleportToPlaceInstance(
                game.PlaceId, game.JobId, LocalPlayer
            )
        end
    end)
end

-- Server Hopper
local hopperActive = false
local function startServerHop()
    if hopperActive then return end
    hopperActive = true
    task.spawn(function()
        local ok, data = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(
                "https://games.roblox.com/v1/games/"
                .. game.PlaceId
                .. "/servers/Public?sortOrder=Asc&limit=25"
            ))
        end)
        if ok and data and data.data then
            local best, bestPing = nil, math.huge
            for _, s in ipairs(data.data) do
                local ping = s.ping or 9999
                if s.id ~= game.JobId and s.playing and s.maxPlayers
                   and s.playing < s.maxPlayers and ping < bestPing then
                    best = s; bestPing = ping
                end
            end
            if best then
                WindUI:Notify({
                    Title = "Server Hopper", Content = "Conectando...", Duration = 3,
                })
                task.wait(2)
                TeleportService:TeleportToPlaceInstance(
                    game.PlaceId, best.id, LocalPlayer
                )
            else
                WindUI:Notify({
                    Title = "Server Hopper", Content = "Nenhum server melhor.", Duration = 3,
                })
            end
        end
        hopperActive = false
    end)
end

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if State.InfiniteJump then
        local hum = getHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ══════════════════════════════════════════════════════
--  PERFORMANCE
-- ══════════════════════════════════════════════════════
local removedDecals   = {}
local origMaterials   = {}
local dynConn         = nil
local entityConn      = nil

local function disableParticles(on)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Smoke")
           or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = not on
        end
    end
end

local function setTextureLow(on)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            if on then
                origMaterials[v] = v.Material
                v.Material = Enum.Material.SmoothPlastic
            elseif origMaterials[v] then
                pcall(function() v.Material = origMaterials[v] end)
            end
        end
    end
end

local function removeDecals(on)
    if on then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then
                table.insert(removedDecals, { obj = v, par = v.Parent })
                v.Parent = nil
            end
        end
    else
        for _, e in ipairs(removedDecals) do
            pcall(function() e.obj.Parent = e.par end)
        end
        removedDecals = {}
    end
end

local function cleanLighting(on)
    if on then
        Lighting.GlobalShadows = false
        Lighting.FogEnd        = 1e6
        Lighting.FogStart      = 1e6
        Lighting.Brightness    = 2
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect")
               or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect")
               or v:IsA("BloomEffect") then
                v.Enabled = false
            end
        end
    else
        Lighting.GlobalShadows = true
        for _, v in ipairs(Lighting:GetChildren()) do
            pcall(function() v.Enabled = true end)
        end
    end
end

local function setLowPoly(on)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("MeshPart") then
            pcall(function() v.LODFactor = on and 0.25 or 1 end)
        end
    end
end

local function setDynRender(on)
    if dynConn then dynConn:Disconnect(); dynConn = nil end
    if on then
        dynConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                settings().Rendering.QualityLevel =
                    (LocalPlayer.NetworkPing or 0) > 0.15 and 1 or 5
            end)
        end)
    else
        pcall(function() settings().Rendering.QualityLevel = 5 end)
    end
end

local function setEntityLimiter(on)
    if entityConn then entityConn:Disconnect(); entityConn = nil end
    if on then
        entityConn = RunService.Heartbeat:Connect(function()
            local n = 0
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Model") and not Players:GetPlayerFromCharacter(v) then
                    n = n + 1
                    if n > 80 then v:Destroy() end
                end
            end
        end)
    end
end

local function applyFPSBoost(on)
    pcall(function()
        settings().Rendering.QualityLevel = on and 1 or 5
    end)
    if on then cleanLighting(true); disableParticles(true) end
end

local function applyAntiLag(on)
    if on then
        pcall(function()
            settings().Physics.PhysicsEnvironmentalThrottle =
                Enum.EnviromentalPhysicsThrottle.Disabled
        end)
    end
end

-- ══════════════════════════════════════════════════════
--  ESP — Drawing Objects
-- ══════════════════════════════════════════════════════
local espObjects = {}

local function mkLine(col, thick)
    local l = Drawing.new("Line")
    l.Visible   = false
    l.Color     = col   or Color3.fromRGB(255, 50, 50)
    l.Thickness = thick or 1.5
    return l
end

local function mkText(size, col)
    local t = Drawing.new("Text")
    t.Visible = false
    t.Size    = size or 14
    t.Outline = true
    t.Color   = col or Color3.fromRGB(255, 255, 255)
    t.Text    = ""
    return t
end

local function mkQuad()
    local q = Drawing.new("Quad")
    q.Visible      = false
    q.Filled       = true
    q.Color        = Color3.fromRGB(255, 50, 50)
    q.Transparency = 0.85
    return q
end

local function cleanESP(player)
    local o = espObjects[player]
    if not o then return end
    for _, l in ipairs(o.lines) do l:Remove() end
    o.label:Remove(); o.fill:Remove()
    o.tracer:Remove(); o.dist:Remove()
    o.hpBg:Remove();  o.hpBar:Remove()
    for _, sb in ipairs(o.chams) do
        pcall(function() sb:Destroy() end)
    end
    espObjects[player] = nil
end

local function buildESP(player)
    cleanESP(player)
    local lines = {}
    for _ = 1, 4 do table.insert(lines, mkLine()) end
    espObjects[player] = {
        lines  = lines,
        label  = mkText(14),
        fill   = mkQuad(),
        tracer = mkLine(State.TracerColor, 1.5),
        dist   = mkText(12, Color3.fromRGB(255, 220, 80)),
        hpBg   = mkLine(Color3.fromRGB(40, 40, 40), 4),
        hpBar  = mkLine(Color3.fromRGB(0, 220, 80),  4),
        chams  = {},
    }
end

local function applyCham(player)
    local o = espObjects[player]
    if not o then return end
    for _, sb in ipairs(o.chams) do pcall(function() sb:Destroy() end) end
    o.chams = {}
    local char = player.Character
    if not char then return end
    local sb = Instance.new("SelectionBox")
    sb.Color3              = State.ChamColor
    sb.LineThickness       = 0.05
    sb.SurfaceColor3       = State.ChamColor
    sb.SurfaceTransparency = 0.5
    sb.Adornee             = char
    sb.Parent              = workspace
    table.insert(o.chams, sb)
end

local function removeCham(player)
    local o = espObjects[player]
    if not o then return end
    for _, sb in ipairs(o.chams) do pcall(function() sb:Destroy() end) end
    o.chams = {}
end

-- Calcula bounding box 2D universal — funciona em R6, R15 e custom rigs
local function getBox(char)
    -- Coleta TODAS as BaseParts do character visíveis
    local parts = {}
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.Transparency < 1 then
            table.insert(parts, v)
        end
    end
    -- Fallback: sem partes visíveis, tenta qualquer BasePart
    if #parts == 0 then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                table.insert(parts, v)
            end
        end
    end
    if #parts == 0 then return nil end

    -- Projeta todas as partes na tela e calcula bounding box 2D real
    local minX, minY = math.huge,  math.huge
    local maxX, maxY = -math.huge, -math.huge
    local anyVisible = false

    for _, part in ipairs(parts) do
        -- Projeta os 8 cantos da part para cobrir rotações
        local sz = part.Size * 0.5
        local cf = part.CFrame
        local corners = {
            cf * Vector3.new( sz.X,  sz.Y,  sz.Z),
            cf * Vector3.new(-sz.X,  sz.Y,  sz.Z),
            cf * Vector3.new( sz.X, -sz.Y,  sz.Z),
            cf * Vector3.new(-sz.X, -sz.Y,  sz.Z),
            cf * Vector3.new( sz.X,  sz.Y, -sz.Z),
            cf * Vector3.new(-sz.X,  sz.Y, -sz.Z),
            cf * Vector3.new( sz.X, -sz.Y, -sz.Z),
            cf * Vector3.new(-sz.X, -sz.Y, -sz.Z),
        }
        for _, corner in ipairs(corners) do
            local sp, onScreen = Camera:WorldToViewportPoint(corner)
            if onScreen then
                anyVisible = true
                if sp.X < minX then minX = sp.X end
                if sp.Y < minY then minY = sp.Y end
                if sp.X > maxX then maxX = sp.X end
                if sp.Y > maxY then maxY = sp.Y end
            end
        end
    end

    if not anyVisible then return nil end

    -- Margem pequena
    local pad = 2
    minX = minX - pad; minY = minY - pad
    maxX = maxX + pad; maxY = maxY + pad

    local cx = (minX + maxX) / 2
    return {
        tl  = Vector2.new(minX, minY),
        tr  = Vector2.new(maxX, minY),
        br  = Vector2.new(maxX, maxY),
        bl  = Vector2.new(minX, maxY),
        cx  = cx,
        top = minY,
        bot = maxY,
    }
end

-- ══════════════════════════════════════════════════════
--  HITBOX UNIVERSAL
-- ══════════════════════════════════════════════════════
local hitboxParts = {}

-- Mapa de partes — tenta R15 primeiro, depois R6, depois qualquer coisa
local HITBOX_PARTS = {
    ["Corpo Inteiro (Root)"] = {
        r15 = "HumanoidRootPart",
        r6  = "HumanoidRootPart",
    },
    ["Cabeça"] = {
        r15 = "Head",
        r6  = "Head",
    },
    ["Torso"] = {
        r15 = "UpperTorso",
        r6  = "Torso",
    },
    ["Torso Inferior"] = {
        r15 = "LowerTorso",
        r6  = "Torso",
    },
    ["Braço Esquerdo"] = {
        r15 = "LeftUpperArm",
        r6  = "Left Arm",
    },
    ["Braço Direito"] = {
        r15 = "RightUpperArm",
        r6  = "Right Arm",
    },
    ["Perna Esquerda"] = {
        r15 = "LeftUpperLeg",
        r6  = "Left Leg",
    },
    ["Perna Direita"] = {
        r15 = "RightUpperLeg",
        r6  = "Right Leg",
    },
}

-- Detecta o rig do personagem (R6, R15 ou custom)
local function detectRig(char)
    if char:FindFirstChild("UpperTorso") then
        return "r15"
    elseif char:FindFirstChild("Torso") then
        return "r6"
    else
        return "custom"
    end
end

-- Encontra a melhor part para ancorar o hitbox
local function findAnchorPart(char, selectedName)
    local rig = detectRig(char)
    local entry = HITBOX_PARTS[selectedName]

    -- Tenta a parte mapeada para o rig
    if entry then
        local name = entry[rig] or entry.r15 or entry.r6
        local found = char:FindFirstChild(name)
        if found then return found end
    end

    -- Fallbacks universais em ordem de prioridade
    local fallbacks = {
        "HumanoidRootPart", "Torso", "UpperTorso",
        "LowerTorso", "Head",
    }
    for _, fb in ipairs(fallbacks) do
        local p = char:FindFirstChild(fb)
        if p and p:IsA("BasePart") then return p end
    end

    -- Último recurso: qualquer BasePart
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then return v end
    end
    return nil
end

local function removeHitbox(player)
    local tbl = hitboxParts[player]
    if not tbl then return end
    for _, p in ipairs(tbl) do
        pcall(function() p:Destroy() end)
    end
    hitboxParts[player] = nil
end

local function applyHitbox(player)
    removeHitbox(player)
    local char = player.Character
    if not char then return end

    local selectedName = State.HitboxPart or "Corpo Inteiro (Root)"
    local anchor = findAnchorPart(char, selectedName)
    if not anchor then return end

    -- Se "Corpo Inteiro", aplica em TODAS as BaseParts principais
    local targets = {}
    if selectedName == "Corpo Inteiro (Root)" then
        local mainParts = {
            "HumanoidRootPart","Head","Torso","UpperTorso","LowerTorso",
            "Left Arm","Right Arm","Left Leg","Right Leg",
            "LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm",
            "LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg",
        }
        for _, name in ipairs(mainParts) do
            local part = char:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                table.insert(targets, part)
            end
        end
        -- Se nenhuma encontrada (custom rig), pega tudo
        if #targets == 0 then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    table.insert(targets, v)
                end
            end
        end
    else
        table.insert(targets, anchor)
    end

    hitboxParts[player] = {}

    for _, target in ipairs(targets) do
        local p        = Instance.new("Part")
        p.Size         = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
        p.Anchored     = false
        p.CanCollide   = false
        p.Massless     = true
        p.Transparency = State.HitboxAlpha
        p.BrickColor   = BrickColor.new("Bright red")
        p.Material     = Enum.Material.ForceField
        p.Parent       = char

        -- Usa Motor6D se WeldConstraint falhar (alguns custom rigs)
        local ok = pcall(function()
            local w = Instance.new("WeldConstraint")
            w.Part0 = target
            w.Part1 = p
            w.Parent = p
        end)
        if not ok then
            pcall(function()
                local w  = Instance.new("Weld")
                w.Part0  = target
                w.Part1  = p
                w.C0     = CFrame.new()
                w.Parent = p
            end)
        end

        table.insert(hitboxParts[player], p)
    end
end

local function refreshHitboxes()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            if State.HitboxEnabled then
                applyHitbox(pl)
            else
                removeHitbox(pl)
            end
        end
    end
end

-- ══════════════════════════════════════════════════════
--  FOV CIRCLE + AIMBOT TARGET
-- ══════════════════════════════════════════════════════
local fovCircle     = Drawing.new("Circle")
fovCircle.Visible   = false
fovCircle.Radius    = State.AimbotFOV
fovCircle.Color     = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1.5
fovCircle.Filled    = false

local function getTarget()
    local best, bestD = nil, math.huge
    local cx = Camera.ViewportSize.X / 2
    local cy = Camera.ViewportSize.Y / 2
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        if not isEnemy(pl) then continue end
        local ch = pl.Character
        if not ch then continue end
        local hd = ch:FindFirstChild("Head")
        if not hd then continue end
        local sp, on = Camera:WorldToViewportPoint(hd.Position)
        if not on then continue end
        local d = math.sqrt((sp.X-cx)^2 + (sp.Y-cy)^2)
        if d < State.AimbotFOV and d < bestD then
            best = hd; bestD = d
        end
    end
    return best
end

-- ══════════════════════════════════════════════════════
--  RENDER LOOP
-- ══════════════════════════════════════════════════════
RunService.RenderStepped:Connect(function()
    local vcx = Camera.ViewportSize.X / 2
    local vcy = Camera.ViewportSize.Y / 2

    -- FOV circle
    fovCircle.Position = Vector2.new(vcx, vcy)
    fovCircle.Radius   = State.AimbotFOV
    fovCircle.Visible  = State.AimbotEnabled

    -- Aimbot
    if State.AimbotEnabled then
        local tgt = getTarget()
        if tgt then
            local alpha = 1 / (State.AimbotSmooth + 1)
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.lookAt(Camera.CFrame.Position, tgt.Position), alpha
            )
        end
    end

    -- ESP loop
    local bottomY = Camera.ViewportSize.Y
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local o = espObjects[player]
        if not o then continue end

        local char = player.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local anyOn = State.ESPEnabled or State.TracerEnabled
                   or State.DistESP   or State.HealthESP

        if not char or not anyOn then
            for _, l in ipairs(o.lines) do l.Visible = false end
            o.label.Visible = false; o.fill.Visible   = false
            o.tracer.Visible= false; o.dist.Visible   = false
            o.hpBg.Visible  = false; o.hpBar.Visible  = false
            continue
        end

        local box = getBox(char)
        if not box then
            for _, l in ipairs(o.lines) do l.Visible = false end
            o.label.Visible = false; o.fill.Visible   = false
            o.tracer.Visible= false; o.dist.Visible   = false
            o.hpBg.Visible  = false; o.hpBar.Visible  = false
            continue
        end

        local col = State.ESPColor

        -- Box
        if State.ESPEnabled then
            local corners = { box.tl, box.tr, box.br, box.bl }
            for i = 1, 4 do
                o.lines[i].From    = corners[i]
                o.lines[i].To      = corners[(i % 4) + 1]
                o.lines[i].Color   = col
                o.lines[i].Visible = true
            end
            o.label.Text     = player.Name
            o.label.Color    = col
            o.label.Position = Vector2.new(box.cx, box.top - 16)
            o.label.Visible  = true
            o.fill.PointA    = box.tl; o.fill.PointB = box.tr
            o.fill.PointC    = box.br; o.fill.PointD = box.bl
            o.fill.Color     = col
            o.fill.Transparency = 1 - State.ESPFillAlpha
            o.fill.Visible   = State.ESPFill
        else
            for _, l in ipairs(o.lines) do l.Visible = false end
            o.label.Visible = false; o.fill.Visible = false
        end

        -- Tracer
        if State.TracerEnabled and root then
            local sp, on = Camera:WorldToViewportPoint(root.Position)
            if on then
                o.tracer.From    = Vector2.new(vcx, bottomY)
                o.tracer.To      = Vector2.new(sp.X, sp.Y)
                o.tracer.Color   = State.TracerColor
                o.tracer.Visible = true
            else
                o.tracer.Visible = false
            end
        else
            o.tracer.Visible = false
        end

        -- Distance
        if State.DistESP and root then
            local myRoot = getRoot()
            if myRoot then
                local d = math.floor((root.Position - myRoot.Position).Magnitude)
                o.dist.Text     = d .. " studs"
                o.dist.Position = Vector2.new(box.cx, box.bot + 3)
                o.dist.Visible  = true
            else
                o.dist.Visible = false
            end
        else
            o.dist.Visible = false
        end

        -- Health bar
        if State.HealthESP and hum then
            local ratio  = hum.MaxHealth > 0 and (hum.Health / hum.MaxHealth) or 0
            local barX   = box.tl.X - 5
            local barH   = box.bot - box.top
            o.hpBg.From  = Vector2.new(barX, box.top)
            o.hpBg.To    = Vector2.new(barX, box.bot)
            o.hpBg.Visible = true
            o.hpBar.From   = Vector2.new(barX, box.bot)
            o.hpBar.To     = Vector2.new(barX, box.bot - barH * ratio)
            o.hpBar.Color  = Color3.fromRGB(
                math.floor(255 * (1 - ratio)),
                math.floor(255 * ratio),
                50
            )
            o.hpBar.Visible = true
        else
            o.hpBg.Visible  = false
            o.hpBar.Visible = false
        end
    end
end)

-- ══════════════════════════════════════════════════════
--  PLAYER EVENTS
-- ══════════════════════════════════════════════════════
for _, pl in ipairs(Players:GetPlayers()) do
    if pl ~= LocalPlayer then buildESP(pl) end
end

Players.PlayerAdded:Connect(function(pl)
    buildESP(pl)
    pl.CharacterAdded:Connect(function()
        task.wait(1)
        if State.HitboxEnabled then applyHitbox(pl) end
        if State.ChamEnabled   then applyCham(pl)   end
    end)
end)

Players.PlayerRemoving:Connect(function(pl)
    cleanESP(pl); removeHitbox(pl)
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = State.WalkSpeed
        hum.JumpPower = State.JumpPower
        if State.GodMode then applyGodMode(hum) end
    end
    if State.HitboxEnabled then refreshHitboxes() end
    if State.DeleteRagdoll then task.wait(0.3); deleteRagdoll() end
end)

setupAutoRejoin()

-- ══════════════════════════════════════════════════════
--  ABA: USEFUL
-- ══════════════════════════════════════════════════════
do
    TabUseful:Section({ Title = "Fling" })

    TabUseful:Toggle({
        Title = "Touch Fling",
        Desc  = "Aplica força em objetos próximos",
        Value = false,
        Callback = function(v)
            State.TouchFling = v
            if v then startFling() else stopFling() end
        end,
    })

    TabUseful:Button({
        Title = "Anti-Fling (toggle)",
        Desc  = "Bloqueia velocity anormal",
        Icon  = "shield",
        Callback = function()
            State.AntiFling = not State.AntiFling
            if State.AntiFling then startAntiFling() else stopAntiFling() end
            WindUI:Notify({
                Title   = "Anti-Fling",
                Content = State.AntiFling and "ATIVADO ✅" or "DESATIVADO ❌",
                Duration = 2,
            })
        end,
    })

    TabUseful:Section({ Title = "Proteções" })

    TabUseful:Toggle({
        Title = "God Mode",
        Desc  = "Vida infinita — difícil de matar",
        Value = false,
        Callback = function(v)
            State.GodMode = v
            local hum = getHum()
            if not hum then return end
            if v then applyGodMode(hum) else removeGodMode(hum) end
        end,
    })

    TabUseful:Toggle({
        Title = "Anti-Void",
        Desc  = "Salva ao cair no void",
        Value = false,
        Callback = function(v)
            State.AntiVoid = v
            if v then startAntiVoid() else stopAntiVoid() end
        end,
    })

    TabUseful:Toggle({
        Title = "Anti-Stun",
        Desc  = "Remove stun e knock-down",
        Value = false,
        Callback = function(v)
            State.AntiStun = v
            if v then startAntiStun() else stopAntiStun() end
        end,
    })

    TabUseful:Button({
        Title = "Delete Ragdoll",
        Desc  = "Remove constraints de ragdoll",
        Icon  = "trash-2",
        Callback = function()
            deleteRagdoll()
            WindUI:Notify({ Title = "Ragdoll", Content = "Deletado!", Duration = 2 })
        end,
    })

    TabUseful:Section({ Title = "Tools" })

    local tools = {
        { "Instant Interact", "zap",    "https://pastefy.app/vg1Ap8MO/raw" },
        { "Destroy Tool",     "trash-2","https://rawscripts.net/raw/Universal-Script-destroy-tool-31432" },
        { "Fly Tool",         "wind",   "https://raw.githubusercontent.com/CoiledTom/Fly-tween-CoiledTom-/refs/heads/main/fly%20tween" },
        { "F3X Tool",         "box",    "https://rawscripts.net/raw/Universal-Script-F3X-Tool-44387" },
        { "Shift Lock",       "lock",   "https://raw.githubusercontent.com/CoiledTom/Shift-Lock-CoiledTom-/refs/heads/main/shift%20Lock%20CoiledTom" },
    }
    for _, t in ipairs(tools) do
        TabUseful:Button({
            Title    = t[1],
            Icon     = t[2],
            Callback = function() loadstring(game:HttpGet(t[3]))() end,
        })
    end
end

-- ══════════════════════════════════════════════════════
--  ABA: SCRIPTS
-- ══════════════════════════════════════════════════════
do
    TabScripts:Section({ Title = "GUIs Externas" })

    local guis = {
        { "Fly GUI",        "airplay",  "https://raw.githubusercontent.com/CoiledTom/Fly-gui/refs/heads/main/%25" },
        { "Refast GUI",     "activity", "https://raw.githubusercontent.com/CoiledTom/Refast-CoiledTom-/refs/heads/main/refast%20CoiledTom" },
        { "Speed GUI",      "zap",      "https://raw.githubusercontent.com/CoiledTom/Speed-CoiledTom-/refs/heads/main/speed%20CoiledTom" },
        { "Waypoint GUI",   "map-pin",  "https://raw.githubusercontent.com/CoiledTom/Way-point-universal-/refs/heads/main/Teleport%2Btween" },
        { "Speed X Hub",    "rocket",   "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua" },
        { "Infinite Yield", "terminal", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source" },
        { "Reverse",        "refresh-cw","https://raw.githubusercontent.com/CoiledTom/Reverse/refs/heads/main/reverse%20script%20by%20CoiledTom" },
        { "Speed CoiledTom","zap",      "https://raw.githubusercontent.com/CoiledTom/Speed-CoiledTom-/refs/heads/main/speed%20CoiledTom" },
        { "Plataforma",     "layers",   "https://raw.githubusercontent.com/CoiledTom/CoiledTom-plataforma/refs/heads/main/By%2520CoiledTom" },
    }
    for _, g in ipairs(guis) do
        TabScripts:Button({
            Title    = g[1],
            Icon     = g[2],
            Callback = function() loadstring(game:HttpGet(g[3]))() end,
        })
    end
end

-- ══════════════════════════════════════════════════════
--  ABA: PLAYER
-- ══════════════════════════════════════════════════════
do
    TabPlayer:Section({ Title = "Movimento" })

    TabPlayer:Slider({
        Title = "WalkSpeed",
        Desc  = "Velocidade de caminhada",
        Step  = 1,
        Value = { Min = 0, Max = 500, Default = 16 },
        Callback = function(v)
            State.WalkSpeed = v
            local hum = getHum()
            if hum then hum.WalkSpeed = v end
        end,
    })

    TabPlayer:Slider({
        Title = "JumpPower",
        Desc  = "Força do pulo",
        Step  = 1,
        Value = { Min = 0, Max = 500, Default = 50 },
        Callback = function(v)
            State.JumpPower = v
            local hum = getHum()
            if hum then hum.JumpPower = v end
        end,
    })

    TabPlayer:Section({ Title = "Pulo" })

    TabPlayer:Toggle({
        Title = "Infinite Jump",
        Desc  = "Pula no ar indefinidamente",
        Value = false,
        Callback = function(v) State.InfiniteJump = v end,
    })
end

-- ══════════════════════════════════════════════════════
--  ABA: COMBAT
-- ══════════════════════════════════════════════════════
do
    TabCombat:Section({ Title = "Aimbot" })

    TabCombat:Toggle({
        Title = "Aimbot",
        Desc  = "Mira automática no alvo mais próximo",
        Value = false,
        Callback = function(v) State.AimbotEnabled = v end,
    })

    TabCombat:Toggle({
        Title = "Team Check",
        Desc  = "Ignora jogadores do mesmo time",
        Value = false,
        Callback = function(v) State.TeamCheck = v end,
    })

    TabCombat:Slider({
        Title = "FOV",
        Desc  = "Raio de alcance em pixels",
        Step  = 1,
        Value = { Min = 10, Max = 600, Default = 120 },
        Callback = function(v) State.AimbotFOV = v end,
    })

    TabCombat:Slider({
        Title = "Smooth",
        Desc  = "Suavidade da mira",
        Step  = 1,
        Value = { Min = 1, Max = 30, Default = 5 },
        Callback = function(v) State.AimbotSmooth = v end,
    })

    TabCombat:Section({ Title = "ESP — Box 2D" })

    TabCombat:Toggle({
        Title = "ESP Box",
        Desc  = "Retângulo 2D em volta do corpo",
        Value = false,
        Callback = function(v) State.ESPEnabled = v end,
    })

    TabCombat:Toggle({
        Title = "Fill",
        Desc  = "Preenchimento semitransparente",
        Value = false,
        Callback = function(v) State.ESPFill = v end,
    })

    TabCombat:Colorpicker({
        Title    = "Cor do ESP",
        Default  = Color3.fromRGB(255, 50, 50),
        Callback = function(c) State.ESPColor = c end,
    })

    TabCombat:Slider({
        Title = "Opacidade Fill",
        Step  = 0.05,
        Value = { Min = 0.05, Max = 1, Default = 0.15 },
        Callback = function(v) State.ESPFillAlpha = v end,
    })

    TabCombat:Section({ Title = "Chams" })

    TabCombat:Toggle({
        Title = "Chams",
        Desc  = "Highlight colorido no corpo dos players",
        Value = false,
        Callback = function(v)
            State.ChamEnabled = v
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= LocalPlayer then
                    if v then applyCham(pl) else removeCham(pl) end
                end
            end
        end,
    })

    TabCombat:Colorpicker({
        Title    = "Cor dos Chams",
        Default  = Color3.fromRGB(255, 100, 0),
        Callback = function(c)
            State.ChamColor = c
            if State.ChamEnabled then
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl ~= LocalPlayer then applyCham(pl) end
                end
            end
        end,
    })

    TabCombat:Section({ Title = "Tracers" })

    TabCombat:Toggle({
        Title = "Tracers",
        Desc  = "Linha do centro da tela até cada player",
        Value = false,
        Callback = function(v) State.TracerEnabled = v end,
    })

    TabCombat:Colorpicker({
        Title    = "Cor dos Tracers",
        Default  = Color3.fromRGB(0, 255, 128),
        Callback = function(c) State.TracerColor = c end,
    })

    TabCombat:Section({ Title = "Info Extra" })

    TabCombat:Toggle({
        Title = "Distance ESP",
        Desc  = "Distância em studs abaixo do box",
        Value = false,
        Callback = function(v) State.DistESP = v end,
    })

    TabCombat:Toggle({
        Title = "Health ESP",
        Desc  = "Barra de vida à esquerda do box",
        Value = false,
        Callback = function(v) State.HealthESP = v end,
    })

    TabCombat:Section({ Title = "Hitbox Expander" })

    TabCombat:Toggle({
        Title = "Hitbox Expander",
        Desc  = "Aumenta a hitbox dos players na parte selecionada",
        Value = false,
        Callback = function(v)
            State.HitboxEnabled = v
            refreshHitboxes()
        end,
    })

    TabCombat:Dropdown({
        Title  = "Parte do Corpo",
        Desc   = "Seleciona onde o hitbox expandido será aplicado",
        Values = {
            "Corpo Inteiro (Root)",
            "Cabeça",
            "Torso",
            "Torso Inferior",
            "Braço Esquerdo",
            "Braço Direito",
            "Perna Esquerda",
            "Perna Direita",
        },
        Value    = "Corpo Inteiro (Root)",
        Callback = function(v)
            State.HitboxPart = v
            if State.HitboxEnabled then refreshHitboxes() end
        end,
    })

    TabCombat:Slider({
        Title = "Tamanho",
        Desc  = "Tamanho do hitbox expandido",
        Step  = 0.5,
        Value = { Min = 1, Max = 30, Default = 5 },
        Callback = function(v)
            State.HitboxSize = v
            if State.HitboxEnabled then refreshHitboxes() end
        end,
    })

    TabCombat:Slider({
        Title = "Transparência",
        Desc  = "0 = visível  |  1 = invisível",
        Step  = 0.05,
        Value = { Min = 0, Max = 1, Default = 0.5 },
        Callback = function(v)
            State.HitboxAlpha = v
            for _, tbl in pairs(hitboxParts) do
                if type(tbl) == "table" then
                    for _, p in ipairs(tbl) do
                        pcall(function() p.Transparency = v end)
                    end
                end
            end
        end,
    })
end

-- ══════════════════════════════════════════════════════
--  ABA: DESEMPENHO
-- ══════════════════════════════════════════════════════
do
    TabPerf:Section({ Title = "⚡ Otimizações" })

    TabPerf:Toggle({
        Title = "Anti-Lag",
        Desc  = "Otimiza física e rendering engine",
        Value = false,
        Callback = function(v) State.AntiLag = v; applyAntiLag(v) end,
    })

    TabPerf:Toggle({
        Title = "FPS Boost",
        Desc  = "Reduz qualidade para mais FPS",
        Value = false,
        Callback = function(v) State.FPSBoost = v; applyFPSBoost(v) end,
    })

    TabPerf:Toggle({
        Title = "Disable Particles",
        Desc  = "Remove fumaça, fogo, faíscas e partículas",
        Value = false,
        Callback = function(v) State.DisableParticles = v; disableParticles(v) end,
    })

    TabPerf:Toggle({
        Title = "Texture Low",
        Desc  = "Substitui materiais por SmoothPlastic",
        Value = false,
        Callback = function(v) State.TextureLow = v; setTextureLow(v) end,
    })

    TabPerf:Toggle({
        Title = "Remove Decals",
        Desc  = "Remove decals e texturas do mapa",
        Value = false,
        Callback = function(v) State.RemoveDecals = v; removeDecals(v) end,
    })

    TabPerf:Toggle({
        Title = "Dynamic Render Distance",
        Desc  = "Ajusta qualidade automaticamente pelo ping",
        Value = false,
        Callback = function(v) State.DynRender = v; setDynRender(v) end,
    })

    TabPerf:Toggle({
        Title = "Entity Limiter",
        Desc  = "Limita modelos no workspace (máx 80)",
        Value = false,
        Callback = function(v) State.EntityLimiter = v; setEntityLimiter(v) end,
    })

    TabPerf:Toggle({
        Title = "Lighting Cleaner",
        Desc  = "Remove fog, bloom, DOF e sombras",
        Value = false,
        Callback = function(v) State.LightingClean = v; cleanLighting(v) end,
    })

    TabPerf:Toggle({
        Title = "Low Poly Mode",
        Desc  = "Reduz LOD de meshes para mais FPS",
        Value = false,
        Callback = function(v) State.LowPoly = v; setLowPoly(v) end,
    })
end

-- ══════════════════════════════════════════════════════
--  ABA: SETTINGS
-- ══════════════════════════════════════════════════════
do
    TabSettings:Section({ Title = "Proteções" })

    TabSettings:Toggle({
        Title = "Anti-AFK",
        Desc  = "Evita kick por inatividade",
        Value = false,
        Callback = function(v)
            State.AntiAFK = v
            if v then startAntiAFK() else stopAntiAFK() end
        end,
    })

    TabSettings:Toggle({
        Title = "Anti-Kick / Anti-Ban",
        Desc  = "Bloqueia kick via metamétodo",
        Value = false,
        Callback = function(v)
            State.AntiKick = v
            if v then hookAntiKick() end
        end,
    })

    TabSettings:Section({ Title = "Servidor" })

    TabSettings:Toggle({
        Title = "Auto Rejoin",
        Desc  = "Caiu? Volta sozinho ao server automaticamente",
        Value = false,
        Callback = function(v) State.AutoRejoin = v end,
    })

    TabSettings:Button({
        Title = "Server Hopper",
        Desc  = "Vai para o server com menor ping disponível",
        Icon  = "wifi",
        Callback = function()
            WindUI:Notify({ Title = "Server Hopper", Content = "Buscando melhor server...", Duration = 3 })
            startServerHop()
        end,
    })

    TabSettings:Section({ Title = "Atalhos" })

    TabSettings:Keybind({
        Title = "Toggle UI",
        Desc  = "Abre/fecha o hub",
        Value = "RightShift",
        Callback = function(v)
            pcall(function()
                Window:SetToggleKey(Enum.KeyCode[v])
            end)
        end,
    })

    TabSettings:Section({ Title = "Configuração" })

    TabSettings:Button({
        Title = "Salvar Config",
        Icon  = "save",
        Desc  = "Salva em CoiledTomHub_Config.json",
        Callback = function()
            local ok, err = pcall(function()
                local data = {
                    WalkSpeed     = State.WalkSpeed,
                    JumpPower     = State.JumpPower,
                    InfiniteJump  = State.InfiniteJump,
                    AimbotEnabled = State.AimbotEnabled,
                    TeamCheck     = State.TeamCheck,
                    AimbotFOV    = State.AimbotFOV,
                    AimbotSmooth  = State.AimbotSmooth,
                    ESPEnabled    = State.ESPEnabled,
                    ESPFill       = State.ESPFill,
                    ESPFillAlpha  = State.ESPFillAlpha,
                    ChamEnabled   = State.ChamEnabled,
                    TracerEnabled = State.TracerEnabled,
                    DistESP       = State.DistESP,
                    HealthESP     = State.HealthESP,
                    HitboxEnabled = State.HitboxEnabled,
                    HitboxSize    = State.HitboxSize,
                    HitboxAlpha   = State.HitboxAlpha,
                    AntiAFK       = State.AntiAFK,
                    AntiKick      = State.AntiKick,
                }
                writefile("CoiledTomHub_Config.json", HttpService:JSONEncode(data))
            end)
            if ok then
                WindUI:Notify({ Title="✅ Config Salva!", Content="CoiledTomHub_Config.json", Duration=3 })
            else
                WindUI:Notify({ Title="❌ Erro", Content=tostring(err), Duration=5 })
            end
        end,
    })
end

-- ══════════════════════════════════════════════════════
--  NOTIFICAÇÃO INICIAL
-- ══════════════════════════════════════════════════════
WindUI:Notify({
    Title    = "CoiledTom Hub",
    Content  = "Carregado! Confira a aba Logs para novidades.",
    Duration = 5,
})
