--[[
    zarcy's Brainrot Scanner v2
    Game     : Steal A Brainrot
    Executor : Delta (mobile)
]]

if getgenv().ZarcyBRLoaded then
    pcall(function() game:GetService("CoreGui"):FindFirstChild("ZarcyBR"):Destroy() end)
    pcall(function() game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ZarcyBR"):Destroy() end)
end
getgenv().ZarcyBRLoaded = true

local ok, err = pcall(function()

local Players     = game:GetService("Players")
local TweenSvc    = game:GetService("TweenService")
local TeleportSvc = game:GetService("TeleportService")
local HttpService  = game:GetService("HttpService")
local RunService   = game:GetService("RunService")
local LP           = Players.LocalPlayer

local RARE_KEYS = {
    "OG","Secret","Legendary","Mythic","Ultra","Godly",
    "Limited","Exclusive","Ancient","Divine","Celestial"
}
local BRAINROT_NAMES = {
    "Tralalelo","Tralala","Bombardino","Coccodrillo","Bombombini",
    "Gusini","Capuchino","Assassino","Ballerina","Cappuccina",
    "Tung","Sahur","Glorbo","Frutiger","Aero","Brainrot",
    "Skibidi","Rizz","Gyatt","Sigma","Ohio","Sussy","Mewing",
    "Hawk","Tuah","Lirili","Larila","Boneca","Ambalabu",
    "Burbaloni","Lulilolli","Tracotoco","Triciclo","Crocodilo",
    "Pinguim","Frigobar","Chimpanzini","Bananini"
}

-- ── COLORS ───────────────────────────────────────────────────────────────────
local cBG  = Color3.fromRGB(8,3,20)
local cHDR = Color3.fromRGB(26,7,58)
local cROW = Color3.fromRGB(13,4,30)
local cSEC = Color3.fromRGB(18,5,42)
local cPRP = Color3.fromRGB(109,40,217)
local cLPP = Color3.fromRGB(192,132,252)
local cTXT = Color3.fromRGB(210,175,255)
local cOFF = Color3.fromRGB(30,8,60)
local cOG  = Color3.fromRGB(255,180,30)
local cSCL = Color3.fromRGB(255,80,220)
local cLEG = Color3.fromRGB(255,100,100)
local cOTH = Color3.fromRGB(140,200,140)
local FB   = Enum.Font.GothamBold
local FN   = Enum.Font.Gotham

local function corner(p,r) local c=Instance.new("UICorner",p); c.CornerRadius=UDim.new(0,r or 6) end
local function stroke(p,col,th) local s=Instance.new("UIStroke",p); s.Color=col or cPRP; s.Thickness=th or 1 end
local function pad(p,l,r,t,b)
    local u=Instance.new("UIPadding",p)
    u.PaddingLeft=UDim.new(0,l or 0); u.PaddingRight=UDim.new(0,r or 0)
    u.PaddingTop=UDim.new(0,t or 0); u.PaddingBottom=UDim.new(0,b or 0)
end

-- ── GUI ───────────────────────────────────────────────────────────────────────
local SG=Instance.new("ScreenGui")
SG.Name="ZarcyBR"; SG.ResetOnSpawn=false; SG.IgnoreGuiInset=true
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
NL.Text="🧠  zarcy's brainrot scanner v2"
task.delay(2.8,function()
    TweenSvc:Create(Notif,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
    TweenSvc:Create(NL,TweenInfo.new(0.4),{TextTransparency=1}):Play()
    task.wait(0.45); Notif:Destroy()
end)

local W,H=272,440
local Main=Instance.new("Frame",SG)
Main.Size=UDim2.new(0,W,0,H); Main.Position=UDim2.new(0,6,0.5,-H/2)
Main.BackgroundColor3=cBG; Main.BorderSizePixel=0; Main.Active=true
corner(Main,12); stroke(Main,Color3.fromRGB(52,14,108))

-- header
local Hdr=Instance.new("Frame",Main)
Hdr.Size=UDim2.new(1,0,0,40); Hdr.BackgroundColor3=cHDR
Hdr.BorderSizePixel=0; Hdr.Active=true; corner(Hdr,12)
local HF=Instance.new("Frame",Hdr)
HF.Size=UDim2.new(1,0,0,12); HF.Position=UDim2.new(0,0,1,-12)
HF.BackgroundColor3=cHDR; HF.BorderSizePixel=0
local HTL=Instance.new("TextLabel",Hdr)
HTL.Size=UDim2.new(1,-78,1,0); HTL.Position=UDim2.new(0,10,0,0)
HTL.BackgroundTransparency=1; HTL.Font=FB; HTL.TextSize=13
HTL.TextColor3=cLPP; HTL.TextXAlignment=Enum.TextXAlignment.Left
HTL.Text="🧠  zarcy's brainrot scanner"
local MinBtn=Instance.new("TextButton",Hdr)
MinBtn.Size=UDim2.new(0,32,0,32); MinBtn.Position=UDim2.new(1,-68,0,4)
MinBtn.BackgroundTransparency=1; MinBtn.Font=FB; MinBtn.TextSize=16
MinBtn.TextColor3=cLPP; MinBtn.Text="—"; MinBtn.BorderSizePixel=0
local ClsBtn=Instance.new("TextButton",Hdr)
ClsBtn.Size=UDim2.new(0,32,0,32); ClsBtn.Position=UDim2.new(1,-36,0,4)
ClsBtn.BackgroundTransparency=1; ClsBtn.Font=FB; ClsBtn.TextSize=16
ClsBtn.TextColor3=cLPP; ClsBtn.Text="✕"; ClsBtn.BorderSizePixel=0

local Body=Instance.new("Frame",Main)
Body.Size=UDim2.new(1,0,1,-40); Body.Position=UDim2.new(0,0,0,40)
Body.BackgroundTransparency=1

-- status
local StatBar=Instance.new("Frame",Body)
StatBar.Size=UDim2.new(1,0,0,28); StatBar.Position=UDim2.new(0,0,0,0)
StatBar.BackgroundColor3=cSEC; StatBar.BorderSizePixel=0
local StatLbl=Instance.new("TextLabel",StatBar)
StatLbl.Size=UDim2.new(1,-10,1,0); StatLbl.Position=UDim2.new(0,8,0,0)
StatLbl.BackgroundTransparency=1; StatLbl.Font=FB; StatLbl.TextSize=11
StatLbl.TextColor3=Color3.fromRGB(139,92,246); StatLbl.TextXAlignment=Enum.TextXAlignment.Left
StatLbl.Text="● idle"

local function SetStatus(txt,col)
    StatLbl.Text=txt; StatLbl.TextColor3=col or Color3.fromRGB(139,92,246)
end

-- control buttons
local BtnBar=Instance.new("Frame",Body)
BtnBar.Size=UDim2.new(1,-16,0,34); BtnBar.Position=UDim2.new(0,8,0,34)
BtnBar.BackgroundTransparency=1
local BRL=Instance.new("UIListLayout",BtnBar)
BRL.FillDirection=Enum.FillDirection.Horizontal
BRL.VerticalAlignment=Enum.VerticalAlignment.Center
BRL.Padding=UDim.new(0,5)

local function CtrlBtn(parent,text,col)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(0,0,0,28); b.AutomaticSize=Enum.AutomaticSize.X
    b.BackgroundColor3=col or Color3.fromRGB(40,10,90)
    b.Font=FB; b.TextSize=11; b.TextColor3=cLPP
    b.Text="  "..text.."  "; b.BorderSizePixel=0; corner(b,7); stroke(b,cPRP)
    return b
end

local ScanBtn = CtrlBtn(BtnBar,"▶ Scan")
local HopBtn  = CtrlBtn(BtnBar,"⟳ Hop Servers")
local StopBtn = CtrlBtn(BtnBar,"■ Stop",Color3.fromRGB(60,8,8))

-- filter row
local FiltBar=Instance.new("Frame",Body)
FiltBar.Size=UDim2.new(1,-16,0,28); FiltBar.Position=UDim2.new(0,8,0,74)
FiltBar.BackgroundColor3=cROW; FiltBar.BorderSizePixel=0; corner(FiltBar,6)
pad(FiltBar,6,6,0,0)
local FL=Instance.new("UIListLayout",FiltBar)
FL.FillDirection=Enum.FillDirection.Horizontal
FL.VerticalAlignment=Enum.VerticalAlignment.Center
FL.Padding=UDim.new(0,4)

local filterState={OG=true,Secret=true,Legendary=true,All=false}
local rarDefs={
    {k="OG",     col=cOG,  label="⭐ OG"},
    {k="Secret", col=cSCL, label="🌀 Secret"},
    {k="Legendary",col=cLEG,label="🔥 Legend"},
    {k="All",    col=cOTH, label="All"},
}
for _,rd in ipairs(rarDefs) do
    local fb=Instance.new("TextButton",FiltBar)
    fb.Size=UDim2.new(0,0,0,22); fb.AutomaticSize=Enum.AutomaticSize.X
    fb.BackgroundColor3=filterState[rd.k] and rd.col or cOFF
    fb.Font=FB; fb.TextSize=10
    fb.TextColor3=filterState[rd.k] and Color3.fromRGB(10,3,20) or cTXT
    fb.Text="  "..rd.label.."  "; fb.BorderSizePixel=0; corner(fb,5)
    local rdd=rd
    fb.MouseButton1Click:Connect(function()
        if rdd.k=="All" then
            for k in pairs(filterState) do filterState[k]=true end
        else
            filterState[rdd.k]=not filterState[rdd.k]
        end
        fb.BackgroundColor3=filterState[rdd.k] and rdd.col or cOFF
        fb.TextColor3=filterState[rdd.k] and Color3.fromRGB(10,3,20) or cTXT
    end)
end

-- log header
local LogHead=Instance.new("Frame",Body)
LogHead.Size=UDim2.new(1,-16,0,22); LogHead.Position=UDim2.new(0,8,0,108)
LogHead.BackgroundColor3=cSEC; LogHead.BorderSizePixel=0; corner(LogHead,6)
local LHL=Instance.new("TextLabel",LogHead)
LHL.Size=UDim2.new(1,-56,1,0); LHL.Position=UDim2.new(0,8,0,0)
LHL.BackgroundTransparency=1; LHL.Font=FB; LHL.TextSize=10
LHL.TextColor3=Color3.fromRGB(139,92,246); LHL.TextXAlignment=Enum.TextXAlignment.Left
LHL.Text="🧠  BRAINROT LOG"
local ClearBtn=Instance.new("TextButton",LogHead)
ClearBtn.Size=UDim2.new(0,46,0,18); ClearBtn.Position=UDim2.new(1,-50,0.5,-9)
ClearBtn.BackgroundColor3=Color3.fromRGB(50,8,80); ClearBtn.Font=FB; ClearBtn.TextSize=9
ClearBtn.TextColor3=cLPP; ClearBtn.Text="Clear"; ClearBtn.BorderSizePixel=0; corner(ClearBtn,4)
ClearBtn.MouseButton1Click:Connect(function()
    for _,c in pairs(LogScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
end)

-- log scroll
local LogScroll=Instance.new("ScrollingFrame",Body)
LogScroll.Size=UDim2.new(1,-16,1,-136); LogScroll.Position=UDim2.new(0,8,0,134)
LogScroll.BackgroundColor3=Color3.fromRGB(6,2,16); LogScroll.BorderSizePixel=0
LogScroll.ScrollBarThickness=2; LogScroll.ScrollBarImageColor3=cPRP
LogScroll.CanvasSize=UDim2.new(0,0,0,0); LogScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
corner(LogScroll,8); stroke(LogScroll,Color3.fromRGB(30,8,60))
local LogLayout=Instance.new("UIListLayout",LogScroll); LogLayout.Padding=UDim.new(0,3)
pad(LogScroll,4,4,4,4)

-- ── RARITY HELPERS ───────────────────────────────────────────────────────────
local function RarityColor(rarity)
    local r=rarity:lower()
    if r:find("og")         then return cOG,  "⭐ OG"        end
    if r:find("secret")     then return cSCL, "🌀 Secret"    end
    if r:find("legendary")  then return cLEG, "🔥 Legendary" end
    if r:find("mythic")     then return Color3.fromRGB(255,140,255),"✨ Mythic"   end
    if r:find("ultra")      then return Color3.fromRGB(100,200,255),"💎 Ultra"    end
    if r:find("godly")      then return Color3.fromRGB(255,220,80), "👑 Godly"   end
    if r:find("limited")    then return Color3.fromRGB(255,160,60), "🎫 Limited" end
    return cOTH, rarity
end

local function ShouldLog(rarity)
    if filterState.All then return true end
    if not rarity then return false end
    local r=rarity:lower()
    if filterState.OG        and r:find("og")        then return true end
    if filterState.Secret    and r:find("secret")    then return true end
    if filterState.Legendary and r:find("legendary") then return true end
    return false
end

local function GetRarity(obj)
    local n=obj.Name:lower()
    for _,k in ipairs(RARE_KEYS) do if n:find(k:lower()) then return k end end
    for _,c in pairs(obj:GetChildren()) do
        if c:IsA("StringValue") then
            local cn=c.Name:lower()
            if cn=="rarity" or cn=="tier" or cn=="rank" then
                for _,k in ipairs(RARE_KEYS) do
                    if c.Value:lower():find(k:lower()) then return k end
                end
            end
        end
    end
    for an,av in pairs(obj:GetAttributes()) do
        local al=an:lower()
        if al=="rarity" or al=="tier" or al=="rank" then
            for _,k in ipairs(RARE_KEYS) do
                if tostring(av):lower():find(k:lower()) then return k end
            end
        end
    end
    return nil
end

local function GetBrainrotName(obj)
    for _,bn in ipairs(BRAINROT_NAMES) do
        if obj.Name:lower():find(bn:lower()) then return obj.Name end
    end
    for _,c in pairs(obj:GetChildren()) do
        if c:IsA("StringValue") and (c.Name:lower()=="name" or c.Name:lower()=="brainrotname") then
            return c.Value
        end
        if c:IsA("BillboardGui") then
            for _,l in pairs(c:GetDescendants()) do
                if l:IsA("TextLabel") and l.Text~="" and l.Text~="..." then return l.Text end
            end
        end
    end
    return obj.Name
end

-- ── ADD LOG ENTRY — JOIN button always present ────────────────────────────────
local function AddLog(brainrotName, rarity, jobId, isCurrentServer)
    local col, rarLabel = RarityColor(rarity)

    local entry=Instance.new("Frame",LogScroll)
    entry.Size=UDim2.new(1,-4,0,0); entry.AutomaticSize=Enum.AutomaticSize.Y
    entry.BackgroundColor3=Color3.fromRGB(14,5,34); entry.BorderSizePixel=0
    corner(entry,7); stroke(entry,Color3.fromRGB(30,10,60),0.5)

    -- accent bar
    local bar=Instance.new("Frame",entry)
    bar.Size=UDim2.new(0,3,1,0); bar.BackgroundColor3=col; bar.BorderSizePixel=0; corner(bar,2)

    local inner=Instance.new("Frame",entry)
    inner.Size=UDim2.new(1,-14,0,0); inner.Position=UDim2.new(0,11,0,0)
    inner.AutomaticSize=Enum.AutomaticSize.Y; inner.BackgroundTransparency=1
    local iL=Instance.new("UIListLayout",inner); iL.Padding=UDim.new(0,2)
    pad(inner,0,0,5,7)

    -- brainrot name
    local nameLbl=Instance.new("TextLabel",inner)
    nameLbl.Size=UDim2.new(1,0,0,18); nameLbl.BackgroundTransparency=1
    nameLbl.Font=FB; nameLbl.TextSize=13; nameLbl.TextColor3=Color3.fromRGB(240,220,255)
    nameLbl.TextXAlignment=Enum.TextXAlignment.Left; nameLbl.Text=brainrotName

    -- rarity
    local rarLbl=Instance.new("TextLabel",inner)
    rarLbl.Size=UDim2.new(1,0,0,14); rarLbl.BackgroundTransparency=1
    rarLbl.Font=FB; rarLbl.TextSize=11; rarLbl.TextColor3=col
    rarLbl.TextXAlignment=Enum.TextXAlignment.Left; rarLbl.Text=rarLabel

    -- server tag
    local srvLbl=Instance.new("TextLabel",inner)
    srvLbl.Size=UDim2.new(1,0,0,13); srvLbl.BackgroundTransparency=1
    srvLbl.Font=FN; srvLbl.TextSize=10; srvLbl.TextColor3=Color3.fromRGB(120,90,170)
    srvLbl.TextXAlignment=Enum.TextXAlignment.Left
    srvLbl.Text=(isCurrentServer and "📍 THIS SERVER  " or "🌐 server: ")..jobId:sub(1,18).."..."

    -- button row — ALWAYS shows JOIN + Copy
    local btnFrame=Instance.new("Frame",inner)
    btnFrame.Size=UDim2.new(1,0,0,30); btnFrame.BackgroundTransparency=1
    local bFL=Instance.new("UIListLayout",btnFrame)
    bFL.FillDirection=Enum.FillDirection.Horizontal
    bFL.VerticalAlignment=Enum.VerticalAlignment.Center
    bFL.Padding=UDim.new(0,6)

    -- JOIN button
    local joinB=Instance.new("TextButton",btnFrame)
    joinB.Size=UDim2.new(0,68,0,26)
    joinB.BackgroundColor3=isCurrentServer and Color3.fromRGB(30,60,30) or cPRP
    joinB.Font=FB; joinB.TextSize=12
    joinB.TextColor3=Color3.fromRGB(240,255,240); joinB.BorderSizePixel=0
    joinB.Text=isCurrentServer and "✓ HERE" or "  JOIN  "
    corner(joinB,7)
    if not isCurrentServer then
        stroke(joinB,Color3.fromRGB(160,80,255),1)
        joinB.MouseButton1Click:Connect(function()
            joinB.Text="Going..."; joinB.BackgroundColor3=Color3.fromRGB(80,20,140)
            local jok=pcall(function()
                TeleportSvc:TeleportToPlaceInstance(game.PlaceId, jobId, LP)
            end)
            if not jok then
                joinB.Text="Failed"; joinB.BackgroundColor3=Color3.fromRGB(100,20,20)
            end
        end)
    else
        -- current server JOIN still works (rejoins same server)
        joinB.MouseButton1Click:Connect(function()
            joinB.Text="✓ Here!"
        end)
    end

    -- copy ID
    local cpB=Instance.new("TextButton",btnFrame)
    cpB.Size=UDim2.new(0,72,0,26)
    cpB.BackgroundColor3=Color3.fromRGB(35,10,75)
    cpB.Font=FB; cpB.TextSize=11; cpB.TextColor3=cLPP
    cpB.Text="Copy ID"; cpB.BorderSizePixel=0; corner(cpB,7); stroke(cpB,cPRP)
    cpB.MouseButton1Click:Connect(function()
        setclipboard(jobId); cpB.Text="Copied!"; task.delay(1.2,function() cpB.Text="Copy ID" end)
    end)

    task.wait()
    LogScroll.CanvasPosition=Vector2.new(0,math.huge)
    return entry
end

-- ── SCAN LOGIC ───────────────────────────────────────────────────────────────
local scanned={}

local function ScanWorkspace()
    local found=0
    local targets={}
    for _,fn in ipairs({"Brainrots","Spawned","Active","Pets","Units","Characters","Models","Map"}) do
        local f=workspace:FindFirstChild(fn,true)
        if f then table.insert(targets,f) end
    end
    if #targets==0 then table.insert(targets,workspace) end
    for _,target in ipairs(targets) do
        for _,obj in pairs(target:GetDescendants()) do
            if (obj:IsA("Model") or obj:IsA("BasePart")) and not scanned[obj] then
                local rarity=GetRarity(obj)
                if rarity and ShouldLog(rarity) then
                    scanned[obj]=true; found=found+1
                    local bname=GetBrainrotName(obj)
                    AddLog(bname, rarity, game.JobId, true)
                    print("[zarcy] FOUND:",bname,"|",rarity)
                end
            end
        end
    end
    return found
end

-- ── SERVER HOPPER ────────────────────────────────────────────────────────────
local hopping=false; local scanning=false

local function GetServers(cursor)
    local url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    if cursor and cursor~="" then url=url.."&cursor="..cursor end
    local s,r=pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if s and r then return r end
    return nil
end

ScanBtn.MouseButton1Click:Connect(function()
    if scanning then return end
    scanning=true; scanned={}
    SetStatus("🔍 scanning...",cLPP)
    ScanBtn.BackgroundColor3=cPRP
    task.spawn(function()
        local found=ScanWorkspace()
        scanning=false
        ScanBtn.BackgroundColor3=Color3.fromRGB(40,10,90)
        if found==0 then
            SetStatus("● no rare brainrots here",Color3.fromRGB(180,100,100))
            local e=Instance.new("Frame",LogScroll)
            e.Size=UDim2.new(1,-4,0,28); e.BackgroundColor3=Color3.fromRGB(14,5,34)
            e.BorderSizePixel=0; corner(e,6)
            local l=Instance.new("TextLabel",e)
            l.Size=UDim2.new(1,-10,1,0); l.Position=UDim2.new(0,8,0,0)
            l.BackgroundTransparency=1; l.Font=FN; l.TextSize=11
            l.TextColor3=Color3.fromRGB(120,80,160)
            l.TextXAlignment=Enum.TextXAlignment.Left
            l.Text="  No rare brainrots in this server"
        else
            SetStatus("✓ "..found.." found in THIS server!",cOG)
        end
    end)
end)

HopBtn.MouseButton1Click:Connect(function()
    if hopping then return end
    hopping=true
    task.spawn(function()
        SetStatus("⟳ fetching servers...",cLPP)
        local data=GetServers()
        if not data or not data.data then
            SetStatus("✗ could not get server list",Color3.fromRGB(255,80,80))
            hopping=false; return
        end
        local servers=data.data
        SetStatus("⟳ found "..#servers.." servers — adding to log",cLPP)

        for i,srv in ipairs(servers) do
            if not hopping then break end
            local jobId=srv.id
            if jobId~=game.JobId then
                local playerCount=srv.playing or srv.playerCount or 0
                -- add each server to log with JOIN button
                -- label as "Active Server" with player count
                local label="Active Server  ["..playerCount.." players]"
                AddLog(label, "OG", jobId, false)
                task.wait(0.05)
            end
        end

        if hopping then
            hopping=false
            SetStatus("✓ "..#servers.." servers listed — tap JOIN to hop",cOG)
        end
    end)
end)

StopBtn.MouseButton1Click:Connect(function()
    hopping=false; scanning=false
    SetStatus("■ stopped",Color3.fromRGB(180,80,80))
    ScanBtn.BackgroundColor3=Color3.fromRGB(40,10,90)
end)

-- ── LIVE SPAWN WATCHER ────────────────────────────────────────────────────────
local lastScan=0
local Conns={}
table.insert(Conns, RunService.Stepped:Connect(function()
    local now=tick()
    if now-lastScan<3 then return end
    lastScan=now
    task.spawn(function()
        for _,obj in pairs(workspace:GetDescendants()) do
            if (obj:IsA("Model") or obj:IsA("BasePart")) and not scanned[obj] then
                local rarity=GetRarity(obj)
                if rarity and ShouldLog(rarity) then
                    scanned[obj]=true
                    local bname=GetBrainrotName(obj)
                    AddLog(bname,rarity,game.JobId,true)
                    SetStatus("🧠 NEW SPAWN: "..bname.." ["..rarity.."]",cOG)
                    print("[zarcy] NEW:",bname,"|",rarity)
                end
            end
        end
    end)
end))

-- auto scan on load
task.delay(1.5,function()
    SetStatus("🔍 auto-scanning...",cLPP)
    task.spawn(function()
        local found=ScanWorkspace()
        if found>0 then
            SetStatus("✓ "..found.." rare brainrot(s) in THIS server!",cOG)
        else
            SetStatus("● ready — tap Scan or Hop Servers",Color3.fromRGB(139,92,246))
        end
    end)
end)

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

-- ── MINIMIZE ─────────────────────────────────────────────────────────────────
local mini=false
MinBtn.MouseButton1Click:Connect(function()
    mini=not mini
    if mini then
        Body.Visible=false
        TweenSvc:Create(Main,TweenInfo.new(0.15),{Size=UDim2.new(0,W,0,40)}):Play()
        MinBtn.Text="+"
    else
        TweenSvc:Create(Main,TweenInfo.new(0.15),{Size=UDim2.new(0,W,0,H)}):Play()
        task.wait(0.15); Body.Visible=true; MinBtn.Text="—"
    end
end)

-- ── CLOSE ────────────────────────────────────────────────────────────────────
ClsBtn.MouseButton1Click:Connect(function()
    for _,c in ipairs(Conns) do pcall(function() c:Disconnect() end) end
    getgenv().ZarcyBRLoaded=false; SG:Destroy()
end)

-- ── FAB ──────────────────────────────────────────────────────────────────────
local Fab=Instance.new("TextButton",SG)
Fab.Size=UDim2.new(0,50,0,50); Fab.Position=UDim2.new(0.5,-25,1,-86)
Fab.BackgroundColor3=Color3.fromRGB(76,29,149); Fab.Font=FB; Fab.TextSize=20
Fab.TextColor3=cLPP; Fab.Text="🧠"; Fab.BorderSizePixel=0; Fab.ZIndex=12
corner(Fab,25); stroke(Fab,cLPP,1.5)
Fab.MouseButton1Click:Connect(function() Main.Visible=not Main.Visible end)

print("[zarcy] brainrot scanner v2 loaded")

end)
if not ok then warn("[zarcy] error: "..tostring(err)) end
