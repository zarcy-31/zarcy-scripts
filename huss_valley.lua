--[[
    zarcy's Huss Valley Hub v1
    Game     : Huss Valley (Escape Huss Valley)
    Executor : Delta (mobile)
    PlaceId  : 107535308163741
]]

if getgenv().ZarcyHVLoaded then
    pcall(function() game:GetService("CoreGui"):FindFirstChild("ZarcyHV"):Destroy() end)
    pcall(function() game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ZarcyHV"):Destroy() end)
end
getgenv().ZarcyHVLoaded = true

local ok, err = pcall(function()

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local Lighting   = game:GetService("Lighting")
local TweenSvc   = game:GetService("TweenService")
local TeleportSvc= game:GetService("TeleportService")
local LP         = Players.LocalPlayer
local Cam        = workspace.CurrentCamera

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
    SpeedOn     = false, Speed     = 16,
    JumpOn      = false, JumpPow   = 50,
    Fly         = false,
    Noclip      = false,
    GodMode     = false,
    InfStamina  = false,
    InfJump     = false,
    AutoSprint  = false,
    AntiKnock   = false,
    AntiVoid    = false,
    ESP         = false,
    Fullbright  = false,
    NoFog       = false,
    ThirdPerson = false,
    NoShake     = false,
}

-- ── COLORS ───────────────────────────────────────────────────────────────────
local cBG   = Color3.fromRGB(6,2,18)
local cHDR  = Color3.fromRGB(20,5,50)
local cROW  = Color3.fromRGB(11,3,28)
local cSEC  = Color3.fromRGB(16,4,38)
local cPRP  = Color3.fromRGB(120,40,230)
local cLPP  = Color3.fromRGB(200,140,255)
local cGLOW = Color3.fromRGB(160,60,255)
local cTXT  = Color3.fromRGB(215,180,255)
local cON   = Color3.fromRGB(130,50,240)
local cOFF  = Color3.fromRGB(28,6,55)
local FB    = Enum.Font.GothamBold
local FN    = Enum.Font.Gotham

local function corner(p,r) local c=Instance.new("UICorner",p); c.CornerRadius=UDim.new(0,r or 6) end
local function stroke(p,col,th) local s=Instance.new("UIStroke",p); s.Color=col or cPRP; s.Thickness=th or 1; return s end
local function pad(p,l,r,t,b)
    local u=Instance.new("UIPadding",p)
    u.PaddingLeft=UDim.new(0,l or 0); u.PaddingRight=UDim.new(0,r or 0)
    u.PaddingTop=UDim.new(0,t or 0); u.PaddingBottom=UDim.new(0,b or 0)
end

-- ── GUI ───────────────────────────────────────────────────────────────────────
local SG = Instance.new("ScreenGui")
SG.Name="ZarcyHV"; SG.ResetOnSpawn=false; SG.IgnoreGuiInset=true
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; SG.DisplayOrder=999
local pok=pcall(function() SG.Parent=game:GetService("CoreGui") end)
if not pok or not SG.Parent then SG.Parent=LP:WaitForChild("PlayerGui") end

-- notify
local Notif=Instance.new("Frame",SG)
Notif.Size=UDim2.new(0,240,0,40); Notif.Position=UDim2.new(0.5,-120,0,14)
Notif.BackgroundColor3=cHDR; Notif.BorderSizePixel=0; Notif.ZIndex=99
corner(Notif,10); stroke(Notif,cLPP)
local NL=Instance.new("TextLabel",Notif)
NL.Size=UDim2.new(1,0,1,0); NL.BackgroundTransparency=1
NL.Font=FB; NL.TextSize=13; NL.TextColor3=cLPP
NL.Text="✦  zarcy's huss valley hub"
task.delay(2.5,function()
    TweenSvc:Create(Notif,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
    TweenSvc:Create(NL,TweenInfo.new(0.4),{TextTransparency=1}):Play()
    task.wait(0.45); Notif:Destroy()
end)

-- ── GLOW LAYERS ──────────────────────────────────────────────────────────────
-- outer glow — 3 expanding frames, animated pulse
local W,H = 265,420
local Main=Instance.new("Frame",SG)
Main.Name="Main"; Main.Size=UDim2.new(0,W,0,H)
Main.Position=UDim2.new(0,6,0.5,-H/2)
Main.BackgroundColor3=cBG; Main.BorderSizePixel=0; Main.Active=true
corner(Main,12)

-- glow frame (behind main)
local GlowOuter=Instance.new("Frame",SG)
GlowOuter.Size=UDim2.new(0,W+20,0,H+20)
GlowOuter.Position=UDim2.new(0,-4,0.5,-(H/2)-10)
GlowOuter.BackgroundColor3=cGLOW; GlowOuter.BackgroundTransparency=0.88
GlowOuter.BorderSizePixel=0; GlowOuter.ZIndex=Main.ZIndex-2
corner(GlowOuter,18)

local GlowMid=Instance.new("Frame",SG)
GlowMid.Size=UDim2.new(0,W+10,0,H+10)
GlowMid.Position=UDim2.new(0,-2,0.5,-(H/2)-5)
GlowMid.BackgroundColor3=cGLOW; GlowMid.BackgroundTransparency=0.82
GlowMid.BorderSizePixel=0; GlowMid.ZIndex=Main.ZIndex-1
corner(GlowMid,15)

-- animated border stroke
local BorderStroke = stroke(Main, cGLOW, 1.5)

-- glow pulse animation
local glowUp = true
local glowT  = 0
table.insert(Conns, RunService.Heartbeat:Connect(function(dt)
    glowT = glowT + dt * 0.9
    local pulse = (math.sin(glowT * math.pi) + 1) / 2  -- 0 to 1
    local t1 = 0.82 + (1 - pulse) * 0.06
    local t2 = 0.88 + (1 - pulse) * 0.05
    local th  = 1.2 + pulse * 1.0
    GlowOuter.BackgroundTransparency = t2
    GlowMid.BackgroundTransparency   = t1
    BorderStroke.Thickness = th
    -- shift glow color slightly
    local h2 = 0.75 + pulse * 0.04
    BorderStroke.Color = Color3.fromHSV(h2, 0.85, 1)
    GlowOuter.BackgroundColor3 = Color3.fromHSV(h2, 0.85, 0.9)
    GlowMid.BackgroundColor3   = Color3.fromHSV(h2, 0.85, 0.95)
end))

-- sync glow position with Main
table.insert(Conns, RunService.RenderStepped:Connect(function()
    if not Main or not Main.Parent then return end
    local p = Main.Position
    GlowOuter.Position = UDim2.new(p.X.Scale, p.X.Offset-10, p.Y.Scale, p.Y.Offset-10)
    GlowMid.Position   = UDim2.new(p.X.Scale, p.X.Offset-5,  p.Y.Scale, p.Y.Offset-5)
    GlowOuter.Size = UDim2.new(0,W+20,0,Main.Size.Y.Offset+20)
    GlowMid.Size   = UDim2.new(0,W+10,0,Main.Size.Y.Offset+10)
end))

-- ── HEADER ───────────────────────────────────────────────────────────────────
local HDR_H = 40
local Hdr=Instance.new("Frame",Main)
Hdr.Size=UDim2.new(1,0,0,HDR_H); Hdr.BackgroundColor3=cHDR
Hdr.BorderSizePixel=0; Hdr.Active=true; corner(Hdr,12)
local HFill=Instance.new("Frame",Hdr)
HFill.Size=UDim2.new(1,0,0,12); HFill.Position=UDim2.new(0,0,1,-12)
HFill.BackgroundColor3=cHDR; HFill.BorderSizePixel=0

local TitleLbl=Instance.new("TextLabel",Hdr)
TitleLbl.Size=UDim2.new(1,-78,1,0); TitleLbl.Position=UDim2.new(0,10,0,0)
TitleLbl.BackgroundTransparency=1; TitleLbl.Font=FB; TitleLbl.TextSize=13
TitleLbl.TextColor3=cLPP; TitleLbl.TextXAlignment=Enum.TextXAlignment.Left
TitleLbl.Text="✦  zarcy  ·  huss valley"

local MinBtn=Instance.new("TextButton",Hdr)
MinBtn.Size=UDim2.new(0,32,0,32); MinBtn.Position=UDim2.new(1,-68,0,4)
MinBtn.BackgroundTransparency=1; MinBtn.Font=FB; MinBtn.TextSize=16
MinBtn.TextColor3=cLPP; MinBtn.Text="—"; MinBtn.BorderSizePixel=0

local ClsBtn=Instance.new("TextButton",Hdr)
ClsBtn.Size=UDim2.new(0,32,0,32); ClsBtn.Position=UDim2.new(1,-36,0,4)
ClsBtn.BackgroundTransparency=1; ClsBtn.Font=FB; ClsBtn.TextSize=16
ClsBtn.TextColor3=cLPP; ClsBtn.Text="✕"; ClsBtn.BorderSizePixel=0

-- ── TAB BAR ──────────────────────────────────────────────────────────────────
local TAB_H = 32
local TabBar=Instance.new("Frame",Main)
TabBar.Size=UDim2.new(1,0,0,TAB_H); TabBar.Position=UDim2.new(0,0,0,HDR_H)
TabBar.BackgroundColor3=Color3.fromRGB(8,2,22); TabBar.BorderSizePixel=0
local TBL=Instance.new("UIListLayout",TabBar)
TBL.FillDirection=Enum.FillDirection.Horizontal
TBL.HorizontalAlignment=Enum.HorizontalAlignment.Center
TBL.VerticalAlignment=Enum.VerticalAlignment.Center
TBL.Padding=UDim.new(0,3)

-- ── CONTENT ──────────────────────────────────────────────────────────────────
local Content=Instance.new("Frame",Main)
Content.Size=UDim2.new(1,0,1,-(HDR_H+TAB_H))
Content.Position=UDim2.new(0,0,0,HDR_H+TAB_H)
Content.BackgroundTransparency=1; Content.ClipsDescendants=true

-- ── WIDGET BUILDERS ──────────────────────────────────────────────────────────
local function ToggleRow(parent,label,key,cb,ord)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,44); row.BackgroundColor3=cROW
    row.BorderSizePixel=0; row.LayoutOrder=ord or 0
    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-68,1,0); lbl.Position=UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency=1; lbl.Font=FN; lbl.TextSize=12
    lbl.TextColor3=cTXT; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label
    local bg=Instance.new("Frame",row)
    bg.Size=UDim2.new(0,42,0,24); bg.Position=UDim2.new(1,-50,0.5,-12)
    bg.BackgroundColor3=C[key] and cON or cOFF; corner(bg,12)
    local knob=Instance.new("Frame",bg)
    knob.Size=UDim2.new(0,18,0,18)
    knob.Position=C[key] and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
    knob.BackgroundColor3=C[key] and cLPP or Color3.fromRGB(80,40,140); corner(knob,9)
    local hit=Instance.new("TextButton",row)
    hit.Size=UDim2.new(1,0,1,0); hit.BackgroundTransparency=1
    hit.Text=""; hit.ZIndex=row.ZIndex+4
    hit.MouseButton1Click:Connect(function()
        C[key]=not C[key]; local on=C[key]
        TweenSvc:Create(bg,  TweenInfo.new(0.14),{BackgroundColor3=on and cON or cOFF}):Play()
        TweenSvc:Create(knob,TweenInfo.new(0.14),{
            Position=on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9),
            BackgroundColor3=on and cLPP or Color3.fromRGB(80,40,140)
        }):Play()
        if cb then pcall(cb,on) end
    end)
end

local function SliderRow(parent,label,key,min,max,ord,cb)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,56); row.BackgroundColor3=cROW
    row.BorderSizePixel=0; row.LayoutOrder=ord or 0
    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-64,0,26); lbl.Position=UDim2.new(0,10,0,2)
    lbl.BackgroundTransparency=1; lbl.Font=FN; lbl.TextSize=12
    lbl.TextColor3=cTXT; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label
    local vLbl=Instance.new("TextLabel",row)
    vLbl.Size=UDim2.new(0,52,0,26); vLbl.Position=UDim2.new(1,-58,0,2)
    vLbl.BackgroundTransparency=1; vLbl.Font=FB; vLbl.TextSize=11
    vLbl.TextColor3=cLPP; vLbl.TextXAlignment=Enum.TextXAlignment.Right
    vLbl.Text=tostring(C[key])
    local track=Instance.new("Frame",row)
    track.Size=UDim2.new(1,-20,0,5); track.Position=UDim2.new(0,10,0,38)
    track.BackgroundColor3=Color3.fromRGB(20,6,45); corner(track,2)
    local ratio=(C[key]-min)/(max-min)
    local fill=Instance.new("Frame",track)
    fill.Size=UDim2.new(ratio,0,1,0); fill.BackgroundColor3=cPRP
    fill.BorderSizePixel=0; corner(fill,2)
    local knob=Instance.new("TextButton",track)
    knob.Size=UDim2.new(0,18,0,18); knob.Position=UDim2.new(ratio,-9,0.5,-9)
    knob.BackgroundColor3=cLPP; knob.Text=""; knob.BorderSizePixel=0; corner(knob,9)
    local hold=false
    knob.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then hold=true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then hold=false end
    end)
    UIS.InputChanged:Connect(function(i)
        if not hold then return end
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement then
            local tAbs=track.AbsolutePosition; local tSz=track.AbsoluteSize
            local r=math.clamp((i.Position.X-tAbs.X)/tSz.X,0,1)
            local v=math.round(min+(max-min)*r)
            C[key]=v; vLbl.Text=tostring(v)
            fill.Size=UDim2.new(r,0,1,0); knob.Position=UDim2.new(r,-9,0.5,-9)
            if cb then pcall(cb,v) end
        end
    end)
end

local function BtnRow(parent,label,btnTxt,cb,ord)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,44); row.BackgroundColor3=cROW
    row.BorderSizePixel=0; row.LayoutOrder=ord or 0
    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-106,1,0); lbl.Position=UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency=1; lbl.Font=FN; lbl.TextSize=12
    lbl.TextColor3=cTXT; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label
    local btn=Instance.new("TextButton",row)
    btn.Size=UDim2.new(0,88,0,30); btn.Position=UDim2.new(1,-94,0.5,-15)
    btn.BackgroundColor3=Color3.fromRGB(45,10,95); btn.Font=FB; btn.TextSize=11
    btn.TextColor3=cLPP; btn.Text=btnTxt or "Run"; btn.BorderSizePixel=0
    corner(btn,6); stroke(btn,cPRP)
    btn.MouseButton1Click:Connect(function()
        TweenSvc:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=cPRP}):Play()
        task.delay(0.15,function() TweenSvc:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(45,10,95)}):Play() end)
        if cb then pcall(cb) end
    end)
end

local function SecHead(parent,text,ord)
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(1,0,0,24); f.BackgroundColor3=cSEC
    f.BorderSizePixel=0; f.LayoutOrder=ord or 0
    local l=Instance.new("TextLabel",f)
    l.Size=UDim2.new(1,-10,1,0); l.Position=UDim2.new(0,10,0,0)
    l.BackgroundTransparency=1; l.Font=FB; l.TextSize=10
    l.TextColor3=Color3.fromRGB(160,80,255)
    l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=text
end

local function Sep(parent,ord)
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(1,0,0,1); f.BackgroundColor3=Color3.fromRGB(24,6,50)
    f.BorderSizePixel=0; f.LayoutOrder=ord or 0
end

-- ── TABS ─────────────────────────────────────────────────────────────────────
local TABS={"Move","Combat","Visual","Misc"}
local TBtns={}; local TPages={}

for _,name in ipairs(TABS) do
    local btn=Instance.new("TextButton",TabBar)
    btn.Size=UDim2.new(0,58,0,26); btn.Font=FB; btn.TextSize=10
    btn.BackgroundColor3=cOFF; btn.TextColor3=Color3.fromRGB(140,90,210)
    btn.BorderSizePixel=0; btn.Text=name; corner(btn,6)
    TBtns[name]=btn
    local page=Instance.new("ScrollingFrame",Content)
    page.Size=UDim2.new(1,0,1,0); page.BackgroundTransparency=1
    page.BorderSizePixel=0; page.ScrollBarThickness=2
    page.ScrollBarImageColor3=cPRP; page.Visible=false
    page.CanvasSize=UDim2.new(0,0,0,0); page.AutomaticCanvasSize=Enum.AutomaticSize.Y
    Instance.new("UIListLayout",page).Padding=UDim.new(0,0)
    TPages[name]=page
    btn.MouseButton1Click:Connect(function()
        for n,p in pairs(TPages) do p.Visible=(n==name) end
        for n,b in pairs(TBtns) do
            b.BackgroundColor3=n==name and cPRP or cOFF
            b.TextColor3=n==name and Color3.fromRGB(240,215,255) or Color3.fromRGB(140,90,210)
        end
    end)
end

-- ── MOVE TAB ─────────────────────────────────────────────────────────────────
do local p=TPages["Move"]
    SecHead(p,"▸  SPEED",1)
    ToggleRow(p,"Speed Hack","SpeedOn",function(on)
        if not on and Hum then Hum.WalkSpeed=16 end
    end,2)
    SliderRow(p,"Walk Speed","Speed",16,300,3,function(v)
        if C.SpeedOn and Hum then Hum.WalkSpeed=v end
    end)
    Sep(p,4)
    SecHead(p,"▸  JUMP",5)
    ToggleRow(p,"Jump Power","JumpOn",function(on)
        if not on and Hum then Hum.JumpPower=50 end
    end,6)
    SliderRow(p,"Jump Power","JumpPow",50,500,7,function(v)
        if C.JumpOn and Hum then Hum.JumpPower=v end
    end)
    ToggleRow(p,"Infinite Jump","InfJump",nil,8)
    Sep(p,9)
    SecHead(p,"▸  MOVEMENT",10)
    ToggleRow(p,"Fly","Fly",function(on)
        if not on then
            if Hum then Hum.PlatformStand=false end
            if HRP then
                local bg=HRP:FindFirstChild("ZarcyFlyBG")
                if bg then bg:Destroy() end
            end
        end
    end,11)
    ToggleRow(p,"No Clip","Noclip",nil,12)
    ToggleRow(p,"Auto Sprint","AutoSprint",function(on)
        if on and Hum then Hum.WalkSpeed=math.max(C.Speed,32) end
        if not on and not C.SpeedOn and Hum then Hum.WalkSpeed=16 end
    end,13)
    ToggleRow(p,"Anti Knockback","AntiKnock",nil,14)
    ToggleRow(p,"Anti Void","AntiVoid",nil,15)
    Sep(p,16)
    SecHead(p,"▸  TELEPORT",17)
    BtnRow(p,"TP → Spawn","Go",function()
        local sp=workspace:FindFirstChildWhichIsA("SpawnLocation")
        if sp and HRP then HRP.CFrame=sp.CFrame+Vector3.new(0,5,0) end
    end,18)
    BtnRow(p,"TP → Nearest Player","Go",function()
        local best,bd=nil,math.huge
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LP and pl.Character then
                local r=pl.Character:FindFirstChild("HumanoidRootPart")
                if r and HRP then
                    local d=(HRP.Position-r.Position).Magnitude
                    if d<bd then bd=d; best=r end
                end
            end
        end
        if best and HRP then HRP.CFrame=best.CFrame+Vector3.new(3,0,0) end
    end,19)
    BtnRow(p,"TP → Map Center","Go",function()
        if HRP then HRP.CFrame=CFrame.new(0,50,0) end
    end,20)
end

-- ── COMBAT TAB ───────────────────────────────────────────────────────────────
do local p=TPages["Combat"]
    SecHead(p,"▸  SURVIVAL",1)
    ToggleRow(p,"God Mode","GodMode",function(on)
        if on then
            if Hum then Hum.MaxHealth=math.huge; Hum.Health=math.huge end
        else
            if Hum then Hum.MaxHealth=100; Hum.Health=100 end
        end
    end,2)
    ToggleRow(p,"Infinite Stamina","InfStamina",nil,3)
    Sep(p,4)
    SecHead(p,"▸  TOOLS",5)
    BtnRow(p,"Reset Character","Reset",function()
        if Hum then Hum.Health=0 end
    end,6)
    BtnRow(p,"Print Player Stats","Log",function()
        if Hum then
            print("[zarcy] WalkSpeed:",Hum.WalkSpeed)
            print("[zarcy] JumpPower:",Hum.JumpPower)
            print("[zarcy] Health:",Hum.Health,"/",Hum.MaxHealth)
        end
        -- try to find coins / stats in leaderstats
        local ls=LP:FindFirstChild("leaderstats")
        if ls then
            for _,v in pairs(ls:GetChildren()) do
                print("[zarcy] STAT:",v.Name,"=",v.Value)
            end
        end
        -- check PlayerGui for coin/stat UI
        for _,v in pairs(LP.PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") and (v.Name:lower():find("coin") or v.Name:lower():find("huss") or v.Name:lower():find("cash")) then
                print("[zarcy] UI STAT:",v.Name,"=",v.Text)
            end
        end
    end,7)
    BtnRow(p,"Auto Collect Coins","Run",function()
        task.spawn(function()
            if not HRP then return end
            for _,obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                    local n=obj.Name:lower()
                    if n:find("coin") or n:find("huss") or n:find("cash") or n:find("pickup") then
                        local sv=HRP.CFrame
                        HRP.CFrame=CFrame.new(obj.Position+Vector3.new(0,2,0))
                        task.wait(0.06)
                        if HRP and HRP.Parent then HRP.CFrame=sv end
                    end
                end
            end
        end)
    end,8)
end

-- ── VISUAL TAB ───────────────────────────────────────────────────────────────
local origAmb=Lighting.Ambient
local origBri=Lighting.Brightness
local origFog=Lighting.FogEnd
local origMin

do local p=TPages["Visual"]
    SecHead(p,"▸  LIGHTING",1)
    ToggleRow(p,"Fullbright","Fullbright",function(on)
        Lighting.Ambient=on and Color3.fromRGB(178,178,178) or origAmb
        Lighting.Brightness=on and 2 or origBri
    end,2)
    ToggleRow(p,"Remove Fog","NoFog",function(on)
        Lighting.FogEnd=on and 9e8 or origFog
    end,3)
    ToggleRow(p,"No Camera Shake","NoShake",function(on)
        local cam=workspace.CurrentCamera
        if on then
            cam.CameraType=Enum.CameraType.Custom
        end
    end,4)
    Sep(p,5)
    SecHead(p,"▸  CAMERA",6)
    ToggleRow(p,"Third Person","ThirdPerson",function(on)
        if on then
            origMin=LP.CameraMinZoomDistance
            LP.CameraMinZoomDistance=8
            LP.CameraMaxZoomDistance=20
        else
            LP.CameraMinZoomDistance=origMin or 0.5
            LP.CameraMaxZoomDistance=400
        end
    end,7)
    Sep(p,8)
    SecHead(p,"▸  PLAYERS",9)
    ToggleRow(p,"Player ESP","ESP",nil,10)
    BtnRow(p,"List All Players","Log",function()
        for _,pl in ipairs(Players:GetPlayers()) do
            local ls=pl:FindFirstChild("leaderstats")
            local stats=""
            if ls then
                for _,v in pairs(ls:GetChildren()) do stats=stats..v.Name.."="..tostring(v.Value).." " end
            end
            print("[zarcy]",pl.Name,"|",stats)
        end
    end,11)
end

-- ── MISC TAB ─────────────────────────────────────────────────────────────────
do local p=TPages["Misc"]
    SecHead(p,"▸  GAME",1)
    BtnRow(p,"Rejoin","Go",function()
        TeleportSvc:Teleport(game.PlaceId,LP)
    end,2)
    BtnRow(p,"Copy Server ID","Copy",function()
        setclipboard(game.JobId)
    end,3)
    BtnRow(p,"Server Info","Log",function()
        print("[zarcy] PlaceId:",game.PlaceId)
        print("[zarcy] JobId:",game.JobId)
        print("[zarcy] Players:",#Players:GetPlayers())
    end,4)
    Sep(p,5)
    SecHead(p,"▸  MAP EXPLORE",6)
    BtnRow(p,"Print Workspace","Log",function()
        print("── TOP LEVEL ──")
        for _,v in pairs(workspace:GetChildren()) do
            print(" ",v.ClassName, v.Name)
            for _,c in pairs(v:GetChildren()) do
                print("   └",c.ClassName,c.Name)
            end
        end
    end,7)
    BtnRow(p,"Find Coins/Pickups","Log",function()
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local n=obj.Name:lower()
                if n:find("coin") or n:find("huss") or n:find("pickup") or n:find("collect") then
                    print("[zarcy] PICKUP:",obj.Name,obj.ClassName,obj:GetFullName())
                end
            end
        end
    end,8)
    BtnRow(p,"Find Checkpoints","Log",function()
        for _,obj in pairs(workspace:GetDescendants()) do
            local n=obj.Name:lower()
            if n:find("check") or n:find("stage") or n:find("start") or n:find("finish") or n:find("gate") then
                print("[zarcy] CHECKPOINT:",obj.Name,obj:GetFullName())
            end
        end
    end,9)
    Sep(p,10)
    SecHead(p,"▸  LEADERSTATS",11)
    BtnRow(p,"Print All Stats","Log",function()
        local ls=LP:FindFirstChild("leaderstats")
        if ls then
            for _,v in pairs(ls:GetChildren()) do
                print("[zarcy] LEADERSTAT:",v.Name,"=",tostring(v.Value))
            end
        else
            print("[zarcy] no leaderstats found")
            -- check other stat locations
            for _,v in pairs(LP:GetChildren()) do
                print("[zarcy] LP child:",v.ClassName,v.Name)
            end
        end
    end,12)
end

-- open Move by default
TBtns["Move"].MouseButton1Click:Fire()

-- ── MOD LOGIC LOOPS ──────────────────────────────────────────────────────────
-- fly
local flyBG = nil
local flyConn = nil
local function startFly()
    if flyConn then return end
    flyConn = RunService.Heartbeat:Connect(function(dt)
        if not C.Fly or not HRP or not Hum then
            if flyBG then flyBG:Destroy(); flyBG=nil end
            flyConn:Disconnect(); flyConn=nil; return
        end
        if not flyBG or not flyBG.Parent then
            flyBG=Instance.new("BodyVelocity",HRP)
            flyBG.Name="ZarcyFlyBG"; flyBG.MaxForce=Vector3.new(1e5,1e5,1e5)
            flyBG.Velocity=Vector3.zero
        end
        local vel=Vector3.zero
        local cf=Cam.CFrame
        if UIS:IsKeyDown(Enum.KeyCode.W) or UIS:GetFocusedTextBox()==nil then
            -- use camera direction for fly
            local hm=Hum.MoveDirection
            if hm.Magnitude>0 then
                vel=cf.LookVector*C.Speed*0.6+Vector3.new(0,0,0)
            end
        end
        -- space = up, shift = down on mobile check touch
        flyBG.Velocity=vel+Vector3.new(0,0,0)
        Hum.PlatformStand=true
    end)
end

-- anti-void save pos
local lastSafePos = Vector3.new(0,50,0)
local lastSafeTick = 0

-- main stepped loop
table.insert(Conns, RunService.Stepped:Connect(function()
    if not Hum or not HRP then return end

    if C.SpeedOn  then Hum.WalkSpeed=C.Speed end
    if C.JumpOn   then Hum.JumpPower=C.JumpPow end
    if C.AutoSprint then Hum.WalkSpeed=math.max(C.Speed,48) end

    if C.Noclip then
        if Char then
            for _,p in pairs(Char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide=false end
            end
        end
    end

    if C.AntiKnock then
        HRP.Velocity=Vector3.new(
            math.clamp(HRP.Velocity.X,-80,80),
            HRP.Velocity.Y,
            math.clamp(HRP.Velocity.Z,-80,80)
        )
    end

    if C.AntiVoid then
        if HRP.Position.Y > 5 then
            lastSafePos=HRP.Position
        elseif HRP.Position.Y < -60 then
            HRP.CFrame=CFrame.new(lastSafePos+Vector3.new(0,5,0))
        end
    end

    if C.Fly and not flyConn then startFly() end
end))

-- god mode heartbeat
local gHB = nil
table.insert(Conns, RunService.Heartbeat:Connect(function()
    if C.GodMode and Hum then
        Hum.Health=Hum.MaxHealth
    end
    -- inf stamina — look for stamina value
    if C.InfStamina then
        for _,v in pairs(LP.Character and LP.Character:GetDescendants() or {}) do
            if v:IsA("NumberValue") and (v.Name:lower():find("stamina") or v.Name:lower():find("energy")) then
                v.Value=v.Parent and (v:GetAttribute("Max") or 100) or 100
            end
        end
        for _,v in pairs(LP:GetDescendants()) do
            if v:IsA("NumberValue") and v.Name:lower():find("stamina") then
                v.Value=9999
            end
        end
    end
end))

-- inf jump
table.insert(Conns, UIS.JumpRequest:Connect(function()
    if C.InfJump and Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

-- ESP drawing
local ESPPool={}
local function MakeESP(plr)
    if plr==LP then return end
    if ESPPool[plr] then return end
    local t=Drawing.new("Text")
    t.Size=13; t.Font=Drawing.Fonts.UI; t.Center=true
    t.Outline=true; t.OutlineColor=Color3.new(0,0,0); t.Visible=false
    ESPPool[plr]=t
end
local function KillESP(plr)
    if ESPPool[plr] then ESPPool[plr]:Remove(); ESPPool[plr]=nil end
end
for _,pl in ipairs(Players:GetPlayers()) do MakeESP(pl) end
Players.PlayerAdded:Connect(MakeESP)
Players.PlayerRemoving:Connect(KillESP)

table.insert(Conns, RunService.RenderStepped:Connect(function()
    for plr,draw in pairs(ESPPool) do
        local chr=plr.Character
        local head=chr and chr:FindFirstChild("Head")
        local root=chr and chr:FindFirstChild("HumanoidRootPart")
        if C.ESP and head and root and HRP then
            local dist=math.floor((HRP.Position-root.Position).Magnitude)
            local sp,on=Cam:WorldToViewportPoint(head.Position+Vector3.new(0,0.6,0))
            if on then
                draw.Position=Vector2.new(sp.X,sp.Y)
                draw.Text=plr.Name.." ["..dist.."m]"
                draw.Color=Color3.fromRGB(200,140,255)
                draw.Visible=true
            else
                draw.Visible=false
            end
        else
            draw.Visible=false
        end
    end
end))

-- ── DRAG ─────────────────────────────────────────────────────────────────────
local dragging,dragStart,startPos=false,nil,nil
Hdr.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true; dragStart=i.Position; startPos=Main.Position
    end
end)
Hdr.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then
        local d=i.Position-dragStart
        Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)
Hdr.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=false
    end
end)
table.insert(Conns,UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then
        local d=i.Position-dragStart
        Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end))
table.insert(Conns,UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=false
    end
end))

-- ── MINIMIZE ─────────────────────────────────────────────────────────────────
local mini=false
MinBtn.MouseButton1Click:Connect(function()
    mini=not mini
    if mini then
        TabBar.Visible=false; Content.Visible=false
        TweenSvc:Create(Main,TweenInfo.new(0.18),{Size=UDim2.new(0,W,0,HDR_H)}):Play()
        MinBtn.Text="+"
    else
        TweenSvc:Create(Main,TweenInfo.new(0.18),{Size=UDim2.new(0,W,0,H)}):Play()
        task.wait(0.18); TabBar.Visible=true; Content.Visible=true; MinBtn.Text="—"
    end
end)

-- ── CLOSE ────────────────────────────────────────────────────────────────────
ClsBtn.MouseButton1Click:Connect(function()
    for _,c in ipairs(Conns) do pcall(function() c:Disconnect() end) end
    for _,d in pairs(ESPPool) do pcall(function() d:Remove() end) end
    if flyBG then pcall(function() flyBG:Destroy() end) end
    pcall(function() GlowOuter:Destroy() end)
    pcall(function() GlowMid:Destroy() end)
    getgenv().ZarcyHVLoaded=false; SG:Destroy()
end)

-- ── FAB ──────────────────────────────────────────────────────────────────────
local Fab=Instance.new("TextButton",SG)
Fab.Size=UDim2.new(0,50,0,50); Fab.Position=UDim2.new(0.5,-25,1,-86)
Fab.BackgroundColor3=Color3.fromRGB(70,20,150); Fab.Font=FB; Fab.TextSize=18
Fab.TextColor3=cLPP; Fab.Text="✦"; Fab.BorderSizePixel=0; Fab.ZIndex=12
corner(Fab,25); stroke(Fab,cLPP,1.5)
Fab.MouseButton1Click:Connect(function() Main.Visible=not Main.Visible end)

print("[zarcy] huss valley hub loaded")

end)
if not ok then warn("[zarcy] error: "..tostring(err)) end
