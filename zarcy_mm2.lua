--[[
    zarcy's MM2 Hub
    Executor : Delta (mobile)
    Game     : Murder Mystery 2
    Load     : loadstring(game:HttpGet("YOUR_RAW_URL"))()
    Host on  : https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/zarcy_mm2.lua
]]

-- ── GUARD ────────────────────────────────────────────────────────────────────
if getgenv().ZarcyActive then return end
getgenv().ZarcyActive = true
pcall(function() game:GetService("CoreGui"):FindFirstChild("ZarcyHub"):Destroy() end)

-- ── SERVICES ─────────────────────────────────────────────────────────────────
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local Lighting   = game:GetService("Lighting")
local TweenSvc   = game:GetService("TweenService")
local TeleportSvc= game:GetService("TeleportService")

local LP  = Players.LocalPlayer
local Cam = workspace.CurrentCamera

-- ── CHARACTER ────────────────────────────────────────────────────────────────
local Char, HRP, Hum
local Conns = {}

local function BindChar(c)
    Char = c
    HRP  = c:WaitForChild("HumanoidRootPart", 8)
    Hum  = c:WaitForChild("Humanoid", 8)
end
BindChar(LP.Character or LP.CharacterAdded:Wait())
table.insert(Conns, LP.CharacterAdded:Connect(BindChar))

-- ── CONFIG ───────────────────────────────────────────────────────────────────
local C = {
    ESP = false, ESPRoles = true, ESPDist = true, ESPTracers = false,
    GunESP = false, RoleReveal = false,
    Aimbot = false, HitboxExpand = false, HitboxSize = 15,
    Noclip = false, InfJump = false, SpeedOn = false, Speed = 16,
    CoinFarm = false, AntiKill = false,
    Fullbright = false, NoFog = false, ThirdPerson = false,
}

-- ── ROLE DETECT ──────────────────────────────────────────────────────────────
local function GetRole(plr)
    for _, cont in ipairs({plr.Character, plr:FindFirstChild("Backpack")}) do
        if cont then
            for _, t in ipairs(cont:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    if n:find("knife") then return "Murderer" end
                    if n:find("gun") or n:find("sheriff") then return "Sheriff" end
                end
            end
        end
    end
    return "Innocent"
end

local RoleCol = {
    Murderer = Color3.fromRGB(255,55,55),
    Sheriff  = Color3.fromRGB(55,120,255),
    Innocent = Color3.fromRGB(80,240,130),
}

-- ── ESP DRAWING ──────────────────────────────────────────────────────────────
local function NewText(size)
    local t = Drawing.new("Text")
    t.Size = size or 13; t.Font = Drawing.Fonts.UI
    t.Center = true; t.Outline = true
    t.OutlineColor = Color3.fromRGB(0,0,0)
    t.Visible = false; return t
end
local function NewLine()
    local l = Drawing.new("Line")
    l.Thickness = 1; l.Visible = false; return l
end

local ESPPool = {}
local function MakeESP(plr)
    ESPPool[plr] = { name=NewText(13), role=NewText(11), dist=NewText(10), tracer=NewLine() }
end
local function KillESP(plr)
    if ESPPool[plr] then
        for _,d in pairs(ESPPool[plr]) do d:Remove() end
        ESPPool[plr] = nil
    end
end

for _,p in ipairs(Players:GetPlayers()) do if p~=LP then MakeESP(p) end end
Players.PlayerAdded:Connect(MakeESP)
Players.PlayerRemoving:Connect(KillESP)

local GunDraw = NewText(13)
GunDraw.Text = "[ GUN ]"; GunDraw.Color = Color3.fromRGB(60,200,255)

table.insert(Conns, RunService.RenderStepped:Connect(function()
    for plr, obj in pairs(ESPPool) do
        local chr   = plr.Character
        local head  = chr and chr:FindFirstChild("Head")
        local root  = chr and chr:FindFirstChild("HumanoidRootPart")
        if C.ESP and head and root and HRP then
            local role  = GetRole(plr)
            local col   = RoleCol[role]
            local dist  = math.floor((HRP.Position-root.Position).Magnitude)
            local sp,on = Cam:WorldToViewportPoint(head.Position + Vector3.new(0,0.6,0))
            local s2    = Vector2.new(sp.X, sp.Y)
            if on then
                obj.name.Position = s2
                obj.name.Text     = plr.Name
                obj.name.Color    = col
                obj.name.Visible  = true
                obj.role.Position = Vector2.new(s2.X, s2.Y+14)
                obj.role.Text     = "["..role.."]"
                obj.role.Color    = col
                obj.role.Visible  = C.ESPRoles
                obj.dist.Position = Vector2.new(s2.X, s2.Y+26)
                obj.dist.Text     = dist.."m"
                obj.dist.Color    = Color3.fromRGB(200,200,200)
                obj.dist.Visible  = C.ESPDist
                if C.ESPTracers then
                    local vp = Cam.ViewportSize
                    obj.tracer.From    = Vector2.new(vp.X/2, vp.Y)
                    obj.tracer.To      = s2
                    obj.tracer.Color   = col
                    obj.tracer.Visible = true
                else obj.tracer.Visible = false end
            else
                for _,d in pairs(obj) do d.Visible = false end
            end
        else
            for _,d in pairs(obj) do d.Visible = false end
        end
    end

    -- gun esp
    GunDraw.Visible = false
    if C.GunESP then
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") then
                local n = obj.Name:lower()
                if n:find("gun") or n:find("sheriff") then
                    local h = obj:FindFirstChild("Handle")
                    if h then
                        local sp,on = Cam:WorldToViewportPoint(h.Position+Vector3.new(0,1.2,0))
                        if on then
                            GunDraw.Position = Vector2.new(sp.X, sp.Y)
                            GunDraw.Visible  = true
                            break
                        end
                    end
                end
            end
        end
    end

    -- aimbot
    if C.Aimbot then
        local best, bd = nil, math.huge
        local vp = Cam.ViewportSize
        local center = Vector2.new(vp.X/2, vp.Y/2)
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LP and plr.Character then
                local hd = plr.Character:FindFirstChild("Head")
                if hd then
                    local sp,on = Cam:WorldToViewportPoint(hd.Position)
                    if on then
                        local d = (Vector2.new(sp.X,sp.Y)-center).Magnitude
                        if d<200 and d<bd then bd=d; best=hd end
                    end
                end
            end
        end
        if best then Cam.CFrame = CFrame.new(Cam.CFrame.Position, best.Position) end
    end
end))

-- ── MECHANICS ────────────────────────────────────────────────────────────────
table.insert(Conns, RunService.Stepped:Connect(function()
    if C.Noclip and Char then
        for _,p in pairs(Char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
    if C.SpeedOn and Hum then Hum.WalkSpeed = C.Speed end
    if C.HitboxExpand then
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LP and plr.Character then
                local r = plr.Character:FindFirstChild("HumanoidRootPart")
                if r then r.Size = Vector3.new(C.HitboxSize,C.HitboxSize,C.HitboxSize) end
            end
        end
    end
end))

table.insert(Conns, UIS.JumpRequest:Connect(function()
    if C.InfJump and Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

-- anti-kill loop
local function startAntiKill()
    getgenv().ZarcyAKConn = RunService.Heartbeat:Connect(function()
        if not C.AntiKill then getgenv().ZarcyAKConn:Disconnect(); return end
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h and h.Health < h.MaxHealth * 0.2 then h.Health = h.MaxHealth end
    end)
end

-- coin farm
local CoinConn
local function startCoinFarm()
    if CoinConn then return end
    CoinConn = RunService.Heartbeat:Connect(function()
        if not C.CoinFarm or not HRP then return end
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("coin") then
                if (HRP.Position-obj.Position).Magnitude < 200 then
                    local sv = HRP.CFrame
                    HRP.CFrame = CFrame.new(obj.Position)
                    task.wait()
                    if HRP and HRP.Parent then HRP.CFrame = sv end
                end
            end
        end
    end)
end

-- lighting
local origAmb, origBri, origFog = Lighting.Ambient, Lighting.Brightness, Lighting.FogEnd
local function applyFB(on)
    Lighting.Ambient = on and Color3.fromRGB(178,178,178) or origAmb
    Lighting.Brightness = on and 2 or origBri
end
local function applyFog(on) Lighting.FogEnd = on and 9e8 or origFog end
local origMin
local function applyTP(on)
    if on then origMin = LP.CameraMinZoomDistance; LP.CameraMinZoomDistance = 8; LP.CameraMaxZoomDistance = 16
    else LP.CameraMinZoomDistance = origMin or 0.5; LP.CameraMaxZoomDistance = 400 end
end

-- ── UI CONSTANTS ─────────────────────────────────────────────────────────────
local FB   = Enum.Font.GothamBold
local FN   = Enum.Font.Gotham
local cBG  = Color3.fromRGB(8,3,20)
local cHDR = Color3.fromRGB(26,7,58)
local cROW = Color3.fromRGB(13,4,30)
local cSEC = Color3.fromRGB(18,5,42)
local cPRP = Color3.fromRGB(109,40,217)
local cLPP = Color3.fromRGB(192,132,252)
local cTXT = Color3.fromRGB(210,175,255)
local cON  = Color3.fromRGB(124,58,237)
local cOFF = Color3.fromRGB(30,8,60)

local function corner(p,r) local c=Instance.new("UICorner",p); c.CornerRadius=UDim.new(0,r or 6); return c end
local function stroke(p,col,th) local s=Instance.new("UIStroke",p); s.Color=col; s.Thickness=th or 1; return s end
local function pad(p,l,r,t,b)
    local u=Instance.new("UIPadding",p)
    u.PaddingLeft=UDim.new(0,l or 0); u.PaddingRight=UDim.new(0,r or 0)
    u.PaddingTop=UDim.new(0,t or 0); u.PaddingBottom=UDim.new(0,b or 0)
end

-- ── ROOT GUI ─────────────────────────────────────────────────────────────────
local SG = Instance.new("ScreenGui")
SG.Name="ZarcyHub"; SG.ResetOnSpawn=false; SG.IgnoreGuiInset=true
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
pcall(function() SG.Parent=game:GetService("CoreGui") end)
if not SG.Parent then SG.Parent=LP.PlayerGui end

-- main frame
local Main = Instance.new("Frame")
Main.Name="Main"; Main.Size=UDim2.new(0,282,0,430)
Main.Position=UDim2.new(0,8,0.5,-215)
Main.BackgroundColor3=cBG; Main.BorderSizePixel=0
Main.Active=true; Main.Parent=SG
corner(Main,14); stroke(Main,Color3.fromRGB(52,14,108))

-- shadow
local Shad=Instance.new("Frame",Main)
Shad.Size=UDim2.new(1,14,1,14); Shad.Position=UDim2.new(0,-7,0,-7)
Shad.ZIndex=Main.ZIndex-1; Shad.BackgroundColor3=Color3.fromRGB(80,10,180)
Shad.BackgroundTransparency=0.82; Shad.BorderSizePixel=0
corner(Shad,18)

-- header
local Hdr=Instance.new("Frame",Main)
Hdr.Name="Hdr"; Hdr.Size=UDim2.new(1,0,0,46)
Hdr.BackgroundColor3=cHDR; Hdr.BorderSizePixel=0
corner(Hdr,14)
-- fill bottom corners of header
local HdrFill=Instance.new("Frame",Hdr)
HdrFill.Size=UDim2.new(1,0,0,14); HdrFill.Position=UDim2.new(0,0,1,-14)
HdrFill.BackgroundColor3=cHDR; HdrFill.BorderSizePixel=0

local TitleLbl=Instance.new("TextLabel",Hdr)
TitleLbl.Size=UDim2.new(1,-88,1,0); TitleLbl.Position=UDim2.new(0,13,0,0)
TitleLbl.BackgroundTransparency=1; TitleLbl.Font=FB; TitleLbl.TextSize=14
TitleLbl.TextColor3=cLPP; TitleLbl.TextXAlignment=Enum.TextXAlignment.Left
TitleLbl.Text="✦  zarcy's hub  ·  mm2"

local MinBtn=Instance.new("TextButton",Hdr)
MinBtn.Size=UDim2.new(0,38,0,38); MinBtn.Position=UDim2.new(1,-80,0,4)
MinBtn.BackgroundTransparency=1; MinBtn.Font=FB; MinBtn.TextSize=16
MinBtn.TextColor3=cLPP; MinBtn.Text="—"; MinBtn.BorderSizePixel=0

local ClsBtn=Instance.new("TextButton",Hdr)
ClsBtn.Size=UDim2.new(0,38,0,38); ClsBtn.Position=UDim2.new(1,-42,0,4)
ClsBtn.BackgroundTransparency=1; ClsBtn.Font=FB; ClsBtn.TextSize=16
ClsBtn.TextColor3=cLPP; ClsBtn.Text="✕"; ClsBtn.BorderSizePixel=0

-- tab bar
local TabBar=Instance.new("Frame",Main)
TabBar.Size=UDim2.new(1,0,0,34); TabBar.Position=UDim2.new(0,0,0,46)
TabBar.BackgroundColor3=Color3.fromRGB(10,3,26); TabBar.BorderSizePixel=0
local TBL=Instance.new("UIListLayout",TabBar)
TBL.FillDirection=Enum.FillDirection.Horizontal
TBL.HorizontalAlignment=Enum.HorizontalAlignment.Center
TBL.VerticalAlignment=Enum.VerticalAlignment.Center
TBL.Padding=UDim.new(0,3)

-- content host
local Content=Instance.new("Frame",Main)
Content.Size=UDim2.new(1,0,1,-(46+34)); Content.Position=UDim2.new(0,0,0,46+34)
Content.BackgroundTransparency=1; Content.BorderSizePixel=0; Content.ClipsDescendants=true

-- ── WIDGET BUILDERS ──────────────────────────────────────────────────────────
local function ToggleRow(parent, label, key, cb, ord)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,46); row.BackgroundColor3=cROW
    row.BorderSizePixel=0; row.LayoutOrder=ord or 0

    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-72,1,0); lbl.Position=UDim2.new(0,13,0,0)
    lbl.BackgroundTransparency=1; lbl.Font=FN; lbl.TextSize=13
    lbl.TextColor3=cTXT; lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.Text=label

    local bg=Instance.new("Frame",row)
    bg.Size=UDim2.new(0,44,0,24); bg.Position=UDim2.new(1,-54,0.5,-12)
    bg.BackgroundColor3=C[key] and cON or cOFF; corner(bg,12)

    local knob=Instance.new("Frame",bg)
    knob.Size=UDim2.new(0,18,0,18)
    knob.Position=C[key] and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
    knob.BackgroundColor3=C[key] and cLPP or Color3.fromRGB(90,50,160); corner(knob,9)

    local hit=Instance.new("TextButton",row)
    hit.Size=UDim2.new(1,0,1,0); hit.BackgroundTransparency=1; hit.Text=""
    hit.ZIndex=row.ZIndex+4

    hit.MouseButton1Click:Connect(function()
        C[key]=not C[key]; local on=C[key]
        TweenSvc:Create(bg,  TweenInfo.new(0.14),{BackgroundColor3=on and cON or cOFF}):Play()
        TweenSvc:Create(knob,TweenInfo.new(0.14),{
            Position=on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9),
            BackgroundColor3=on and cLPP or Color3.fromRGB(90,50,160)
        }):Play()
        if cb then cb(on) end
    end)
    return row
end

local function SliderRow(parent, label, key, min, max, ord, cb)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,58); row.BackgroundColor3=cROW
    row.BorderSizePixel=0; row.LayoutOrder=ord or 0

    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-68,0,26); lbl.Position=UDim2.new(0,13,0,2)
    lbl.BackgroundTransparency=1; lbl.Font=FN; lbl.TextSize=13
    lbl.TextColor3=cTXT; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label

    local vLbl=Instance.new("TextLabel",row)
    vLbl.Size=UDim2.new(0,52,0,26); vLbl.Position=UDim2.new(1,-62,0,2)
    vLbl.BackgroundTransparency=1; vLbl.Font=FB; vLbl.TextSize=12
    vLbl.TextColor3=cLPP; vLbl.TextXAlignment=Enum.TextXAlignment.Right
    vLbl.Text=tostring(C[key])

    local track=Instance.new("Frame",row)
    track.Size=UDim2.new(1,-24,0,4); track.Position=UDim2.new(0,12,0,40)
    track.BackgroundColor3=Color3.fromRGB(25,8,52); corner(track,2)

    local ratio=(C[key]-min)/(max-min)
    local fill=Instance.new("Frame",track)
    fill.Size=UDim2.new(ratio,0,1,0); fill.BackgroundColor3=cPRP
    fill.BorderSizePixel=0; corner(fill,2)

    local knob=Instance.new("TextButton",track)
    knob.Size=UDim2.new(0,16,0,16); knob.Position=UDim2.new(ratio,-8,0.5,-8)
    knob.BackgroundColor3=cLPP; knob.Text=""; knob.BorderSizePixel=0; corner(knob,8)

    local hold=false
    knob.MouseButton1Down:Connect(function() hold=true end)
    knob.TouchLongPress:Connect(function() hold=true end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            hold=false end end)
    UIS.InputChanged:Connect(function(i)
        if not hold then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
            local tAbs=track.AbsolutePosition; local tSz=track.AbsoluteSize
            local r=math.clamp((i.Position.X-tAbs.X)/tSz.X,0,1)
            local v=math.round(min+(max-min)*r)
            C[key]=v; vLbl.Text=tostring(v)
            fill.Size=UDim2.new(r,0,1,0); knob.Position=UDim2.new(r,-8,0.5,-8)
            if cb then cb(v) end
        end
    end)
    return row
end

local function BtnRow(parent, label, btnTxt, cb, ord)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,46); row.BackgroundColor3=cROW
    row.BorderSizePixel=0; row.LayoutOrder=ord or 0

    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-108,1,0); lbl.Position=UDim2.new(0,13,0,0)
    lbl.BackgroundTransparency=1; lbl.Font=FN; lbl.TextSize=13
    lbl.TextColor3=cTXT; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label

    local btn=Instance.new("TextButton",row)
    btn.Size=UDim2.new(0,88,0,30); btn.Position=UDim2.new(1,-96,0.5,-15)
    btn.BackgroundColor3=Color3.fromRGB(52,14,108); btn.Font=FB; btn.TextSize=12
    btn.TextColor3=cLPP; btn.Text=btnTxt or "Run"; btn.BorderSizePixel=0
    corner(btn,6); stroke(btn,cPRP)

    btn.MouseButton1Click:Connect(function()
        TweenSvc:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=cPRP}):Play()
        task.delay(0.15,function() TweenSvc:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(52,14,108)}):Play() end)
        if cb then pcall(cb) end
    end)
    return row
end

local function SecHead(parent, text, ord)
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(1,0,0,26); f.BackgroundColor3=cSEC
    f.BorderSizePixel=0; f.LayoutOrder=ord or 0
    local l=Instance.new("TextLabel",f)
    l.Size=UDim2.new(1,-13,1,0); l.Position=UDim2.new(0,13,0,0)
    l.BackgroundTransparency=1; l.Font=FB; l.TextSize=11
    l.TextColor3=Color3.fromRGB(139,92,246); l.TextXAlignment=Enum.TextXAlignment.Left
    l.Text=text
    return f
end

local function Sep(parent, ord)
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(1,0,0,1); f.BackgroundColor3=Color3.fromRGB(28,8,58)
    f.BorderSizePixel=0; f.LayoutOrder=ord or 0
    return f
end

-- ── TAB SYSTEM ───────────────────────────────────────────────────────────────
local TABS   = { "ESP", "Combat", "Move", "MM2", "Visual" }
local TBtns  = {}
local TPages = {}

for _,name in ipairs(TABS) do
    local btn=Instance.new("TextButton",TabBar)
    btn.Size=UDim2.new(0,50,0,26); btn.Font=FB; btn.TextSize=11
    btn.BackgroundColor3=cOFF; btn.TextColor3=Color3.fromRGB(140,100,200)
    btn.BorderSizePixel=0; btn.Text=name; corner(btn,7)
    TBtns[name]=btn

    local page=Instance.new("ScrollingFrame",Content)
    page.Size=UDim2.new(1,0,1,0); page.BackgroundTransparency=1
    page.BorderSizePixel=0; page.ScrollBarThickness=2
    page.ScrollBarImageColor3=cPRP; page.Visible=false
    page.CanvasSize=UDim2.new(0,0,0,0); page.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local pl=Instance.new("UIListLayout",page); pl.Padding=UDim.new(0,0)
    TPages[name]=page

    btn.MouseButton1Click:Connect(function()
        for n,p in pairs(TPages) do
            p.Visible=(n==name)
        end
        for n,b in pairs(TBtns) do
            b.BackgroundColor3 = n==name and cPRP or cOFF
            b.TextColor3 = n==name and Color3.fromRGB(240,220,255) or Color3.fromRGB(140,100,200)
        end
    end)
end

-- ── POPULATE: ESP ────────────────────────────────────────────────────────────
do local p=TPages["ESP"]
    SecHead(p,"▸  PLAYER ESP",1)
    ToggleRow(p,"Player ESP",         "ESP",        nil,2)
    ToggleRow(p,"Show Roles",         "ESPRoles",   nil,3)
    ToggleRow(p,"Show Distance",      "ESPDist",    nil,4)
    ToggleRow(p,"Tracers",            "ESPTracers", nil,5)
    Sep(p,6)
    SecHead(p,"▸  ITEMS",7)
    ToggleRow(p,"Gun ESP",            "GunESP",     nil,8)
    Sep(p,9)
    SecHead(p,"▸  ROLE PANEL",10)
    ToggleRow(p,"Role Reveal",        "RoleReveal", nil,11)

    -- live role list
    local rl=Instance.new("Frame",p)
    rl.Size=UDim2.new(1,0,0,0); rl.AutomaticSize=Enum.AutomaticSize.Y
    rl.BackgroundColor3=Color3.fromRGB(9,3,22); rl.BorderSizePixel=0; rl.LayoutOrder=12
    local rll=Instance.new("UIListLayout",rl); rll.Padding=UDim.new(0,2)
    pad(rl,8,8,4,4)

    task.spawn(function()
        while SG.Parent do
            for _,c in pairs(rl:GetChildren()) do if c:IsA("Frame") or c:IsA("TextLabel") then c:Destroy() end end
            if C.RoleReveal then
                for _,plr in ipairs(Players:GetPlayers()) do
                    local role=GetRole(plr)
                    local lbl=Instance.new("TextLabel",rl)
                    lbl.Size=UDim2.new(1,0,0,30); lbl.BackgroundTransparency=1
                    lbl.Font=FB; lbl.TextSize=12; lbl.TextColor3=RoleCol[role]
                    lbl.TextXAlignment=Enum.TextXAlignment.Left
                    lbl.Text="  "..plr.Name.."  ─  "..role
                end
            end
            task.wait(1.5)
        end
    end)
end

-- ── POPULATE: COMBAT ─────────────────────────────────────────────────────────
do local p=TPages["Combat"]
    SecHead(p,"▸  AIMBOT",1)
    ToggleRow(p,"Aimbot (FOV lock)",  "Aimbot",      nil,2)
    Sep(p,3)
    SecHead(p,"▸  HITBOX",4)
    ToggleRow(p,"Hitbox Expander",    "HitboxExpand",nil,5)
    SliderRow(p,"Hitbox Size",        "HitboxSize",  4,50,6)
    Sep(p,7)
    SecHead(p,"▸  SURVIVAL",8)
    ToggleRow(p,"Anti Kill",          "AntiKill",    function(on) if on then startAntiKill() end end,9)
end

-- ── POPULATE: MOVE ───────────────────────────────────────────────────────────
do local p=TPages["Move"]
    SecHead(p,"▸  MOVEMENT",1)
    ToggleRow(p,"Speed Hack",  "SpeedOn", function(on) if not on and Hum then Hum.WalkSpeed=16 end end,2)
    SliderRow(p,"Walk Speed",  "Speed",   8,120,3,function(v) if C.SpeedOn and Hum then Hum.WalkSpeed=v end end)
    ToggleRow(p,"Infinite Jump","InfJump",nil,4)
    ToggleRow(p,"No Clip",     "Noclip",  nil,5)
    Sep(p,6)
    SecHead(p,"▸  TELEPORT",7)
    BtnRow(p,"TP → Spawn",     "Go", function()
        local sp=workspace:FindFirstChildWhichIsA("SpawnLocation")
        if sp and HRP then HRP.CFrame=sp.CFrame+Vector3.new(0,4,0) end
    end,8)
    BtnRow(p,"TP → Murderer",  "Go", function()
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LP and GetRole(pl)=="Murderer" and pl.Character then
                local r=pl.Character:FindFirstChild("HumanoidRootPart")
                if r and HRP then HRP.CFrame=r.CFrame+Vector3.new(3,0,0) end; return end
        end
    end,9)
    BtnRow(p,"TP → Sheriff Gun","Go", function()
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") then
                local n=obj.Name:lower()
                if n:find("gun") or n:find("sheriff") then
                    local h=obj:FindFirstChild("Handle")
                    if h and HRP then HRP.CFrame=CFrame.new(h.Position+Vector3.new(0,4,0)) end; return
                end
            end
        end
    end,10)
    BtnRow(p,"TP → Nearest Coin","Go", function()
        if not HRP then return end
        local best,bd=nil,math.huge
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("coin") then
                local d=(HRP.Position-obj.Position).Magnitude
                if d<bd then bd=d; best=obj end
            end
        end
        if best then HRP.CFrame=CFrame.new(best.Position+Vector3.new(0,3,0)) end
    end,11)
end

-- ── POPULATE: MM2 ────────────────────────────────────────────────────────────
do local p=TPages["MM2"]
    SecHead(p,"▸  FARM",1)
    ToggleRow(p,"Coin Farm (auto TP)", "CoinFarm", function(on)
        if on then startCoinFarm()
        elseif CoinConn then CoinConn:Disconnect(); CoinConn=nil end
    end,2)
    BtnRow(p,"Collect All Coins Now","Run", function()
        task.spawn(function()
            if not HRP then return end
            for _,obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("coin") then
                    local sv=HRP.CFrame; HRP.CFrame=CFrame.new(obj.Position)
                    task.wait(0.04); if HRP and HRP.Parent then HRP.CFrame=sv end
                end
            end
        end)
    end,3)
    Sep(p,4)
    SecHead(p,"▸  TOOLS",5)
    BtnRow(p,"Print All Workspace Objects","Log",function()
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Tool") then print(v.Name,v.ClassName,v:GetFullName()) end
        end
    end,6)
    BtnRow(p,"Print My Role","Check",function()
        print("[zarcy] Your role:", GetRole(LP))
    end,7)
    BtnRow(p,"Kill Murderer (TP touch)","Go",function()
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LP and GetRole(pl)=="Murderer" and pl.Character then
                local r=pl.Character:FindFirstChild("HumanoidRootPart")
                if r and HRP then
                    local wasNC=C.Noclip; C.Noclip=true
                    HRP.CFrame=r.CFrame; task.wait(0.15); C.Noclip=wasNC
                end; return
            end
        end
    end,8)
    Sep(p,9)
    SecHead(p,"▸  MISC",10)
    BtnRow(p,"Rejoin","Go",function()
        TeleportSvc:Teleport(game.PlaceId, LP)
    end,11)
    BtnRow(p,"Print Players","Log",function()
        for _,pl in ipairs(Players:GetPlayers()) do print(pl.Name, GetRole(pl)) end
    end,12)
end

-- ── POPULATE: VISUAL ─────────────────────────────────────────────────────────
do local p=TPages["Visual"]
    SecHead(p,"▸  LIGHTING",1)
    ToggleRow(p,"Fullbright",   "Fullbright",   function(on) applyFB(on) end,2)
    ToggleRow(p,"Remove Fog",   "NoFog",        function(on) applyFog(on) end,3)
    ToggleRow(p,"Third Person", "ThirdPerson",  function(on) applyTP(on) end,4)
    Sep(p,5)
    SecHead(p,"▸  MISC",6)
    BtnRow(p,"Reset Character","Reset",function()
        if Hum then Hum.Health=0 end
    end,7)
    BtnRow(p,"Screenshot Info","Log",function()
        print("Place:",game.PlaceId,"Job:",game.JobId)
    end,8)
end

-- open on ESP by default
TBtns["ESP"]:MouseButton1Click:Fire()

-- ── DRAG ─────────────────────────────────────────────────────────────────────
local drg,drs,dsp=false,nil,nil
Hdr.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        drg=true; drs=i.Position; dsp=Main.Position
    end
end)
Hdr.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drg=false end
end)
table.insert(Conns,UIS.InputChanged:Connect(function(i)
    if not drg then return end
    if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
        local d=i.Position-drs
        Main.Position=UDim2.new(dsp.X.Scale,dsp.X.Offset+d.X,dsp.Y.Scale,dsp.Y.Offset+d.Y)
    end
end))

-- ── CLOSE / MINIMIZE ─────────────────────────────────────────────────────────
ClsBtn.MouseButton1Click:Connect(function()
    SG:Destroy()
    GunDraw:Remove()
    for _,obj in pairs(ESPPool) do for _,d in pairs(obj) do d:Remove() end end
    for _,c in ipairs(Conns) do c:Disconnect() end
    if CoinConn then CoinConn:Disconnect() end
    getgenv().ZarcyActive=false
end)

local mini=false
MinBtn.MouseButton1Click:Connect(function()
    mini=not mini
    TabBar.Visible=not mini; Content.Visible=not mini
    TweenSvc:Create(Main,TweenInfo.new(0.15),{Size=mini and UDim2.new(0,282,0,46) or UDim2.new(0,282,0,430)}):Play()
end)

-- ── FAB ──────────────────────────────────────────────────────────────────────
local Fab=Instance.new("TextButton",SG)
Fab.Size=UDim2.new(0,52,0,52); Fab.Position=UDim2.new(1,-64,1,-72)
Fab.BackgroundColor3=Color3.fromRGB(76,29,149); Fab.Font=FB; Fab.TextSize=18
Fab.TextColor3=cLPP; Fab.Text="✦"; Fab.BorderSizePixel=0; Fab.ZIndex=12
corner(Fab,26); stroke(Fab,cLPP)

Fab.MouseButton1Click:Connect(function()
    Main.Visible=not Main.Visible
end)

print("[zarcy] MM2 hub loaded — "..#Players:GetPlayers().." players in server")
