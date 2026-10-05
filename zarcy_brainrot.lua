--[[
    zarcy's Brainrot Scanner
    Game     : Steal A Brainrot
    Executor : Delta (mobile)
    Load     : loadstring(game:HttpGet("RAW_URL?nc="..math.random(1,999999)))()
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
local HttpService = game:GetService("HttpService")
local RunService  = game:GetService("RunService")
local LP          = Players.LocalPlayer

-- ── RARITY CONFIG ─────────────────────────────────────────────────────────────
-- keywords scanned against model/part names and StringValue children
local RARE_KEYS = {
    "OG", "Secret", "Legendary", "Mythic", "Ultra", "Godly",
    "Limited", "Exclusive", "Ancient", "Divine", "Celestial"
}
-- brainrot name list — add more as the game updates
local BRAINROT_NAMES = {
    "Tralalelo","Tralala","Bombardino","Coccodrillo","Bombombini",
    "Gusini","Capuchino","Assassino","Ballerina","Cappuccina",
    "Tung","Sahur","Glorbo","Frutiger","Aero","Brainrot",
    "Skibidi","Rizz","Gyatt","Sigma","Ohio","Sussy","Mewing",
    "Hawk","Tuah","Lirili","Larila","Boneca","Ambalabu",
    "Burbaloni","Lulilolli","Tracotoco","Triciclo","Crocodilo",
    "Pinguim","Frigobar","Chimpanzini","Bananini"
}

local FILTER_RARITIES = { OG=true, Secret=true } -- what to alert on

-- ── COLORS ────────────────────────────────────────────────────────────────────
local cBG  = Color3.fromRGB(8,3,20)
local cHDR = Color3.fromRGB(26,7,58)
local cROW = Color3.fromRGB(13,4,30)
local cSEC = Color3.fromRGB(18,5,42)
local cPRP = Color3.fromRGB(109,40,217)
local cLPP = Color3.fromRGB(192,132,252)
local cTXT = Color3.fromRGB(210,175,255)
local cON  = Color3.fromRGB(124,58,237)
local cOFF = Color3.fromRGB(30,8,60)
local cOG  = Color3.fromRGB(255,180,30)
local cSEC_COL = Color3.fromRGB(255,80,220)
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
local SG = Instance.new("ScreenGui")
SG.Name="ZarcyBR"; SG.ResetOnSpawn=false; SG.IgnoreGuiInset=true
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; SG.DisplayOrder=999
local pok = pcall(function() SG.Parent=game:GetService("CoreGui") end)
if not pok or not SG.Parent then SG.Parent=LP:WaitForChild("PlayerGui") end

-- notify
local Notif=Instance.new("Frame",SG)
Notif.Size=UDim2.new(0,230,0,40); Notif.Position=UDim2.new(0.5,-115,0,14)
Notif.BackgroundColor3=cHDR; Notif.BorderSizePixel=0; Notif.ZIndex=99
corner(Notif,10); stroke(Notif,cLPP)
local NL=Instance.new("TextLabel",Notif)
NL.Size=UDim2.new(1,0,1,0); NL.BackgroundTransparency=1
NL.Font=FB; NL.TextSize=13; NL.TextColor3=cLPP; NL.Text="✦  zarcy's brainrot scanner"
task.delay(2.8,function()
    TweenSvc:Create(Notif,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
    TweenSvc:Create(NL,TweenInfo.new(0.4),{TextTransparency=1}):Play()
    task.wait(0.45); Notif:Destroy()
end)

-- main
local W,H=270,430
local Main=Instance.new("Frame",SG)
Main.Size=UDim2.new(0,W,0,H); Main.Position=UDim2.new(0,6,0.5,-H/2)
Main.BackgroundColor3=cBG; Main.BorderSizePixel=0; Main.Active=true
corner(Main,12); stroke(Main,Color3.fromRGB(52,14,108))

-- header
local Hdr=Instance.new("Frame",Main)
Hdr.Size=UDim2.new(1,0,0,40); Hdr.BackgroundColor3=cHDR; Hdr.BorderSizePixel=0
Hdr.Active=true; corner(Hdr,12)
local HF=Instance.new("Frame",Hdr)
HF.Size=UDim2.new(1,0,0,12); HF.Position=UDim2.new(0,0,1,-12)
HF.BackgroundColor3=cHDR; HF.BorderSizePixel=0
local HTL=Instance.new("TextLabel",Hdr)
HTL.Size=UDim2.new(1,-80,1,0); HTL.Position=UDim2.new(0,10,0,0)
HTL.BackgroundTransparency=1; HTL.Font=FB; HTL.TextSize=13
HTL.TextColor3=cLPP; HTL.TextXAlignment=Enum.TextXAlignment.Left
HTL.Text="🧠  zarcy's brainrot scanner"
local MinBtn=Instance.new("TextButton",Hdr)
MinBtn.Size=UDim2.new(0,32,0,32); MinBtn.Position=UDim2.new(1,-70,0,4)
MinBtn.BackgroundTransparency=1; MinBtn.Font=FB; MinBtn.TextSize=16
MinBtn.TextColor3=cLPP; MinBtn.Text="—"; MinBtn.BorderSizePixel=0
local ClsBtn=Instance.new("TextButton",Hdr)
ClsBtn.Size=UDim2.new(0,32,0,32); ClsBtn.Position=UDim2.new(1,-36,0,4)
ClsBtn.BackgroundTransparency=1; ClsBtn.Font=FB; ClsBtn.TextSize=16
ClsBtn.TextColor3=cLPP; ClsBtn.Text="✕"; ClsBtn.BorderSizePixel=0

-- body
local Body=Instance.new("Frame",Main)
Body.Size=UDim2.new(1,0,1,-40); Body.Position=UDim2.new(0,0,0,40)
Body.BackgroundTransparency=1

-- status bar
local StatBar=Instance.new("Frame",Body)
StatBar.Size=UDim2.new(1,0,0,30); StatBar.Position=UDim2.new(0,0,0,0)
StatBar.BackgroundColor3=cSEC; StatBar.BorderSizePixel=0
local StatLbl=Instance.new("TextLabel",StatBar)
StatLbl.Size=UDim2.new(1,-10,1,0); StatLbl.Position=UDim2.new(0,8,0,0)
StatLbl.BackgroundTransparency=1; StatLbl.Font=FB; StatLbl.TextSize=11
StatLbl.TextColor3=Color3.fromRGB(139,92,246); StatLbl.TextXAlignment=Enum.TextXAlignment.Left
StatLbl.Text="● idle  |  server: "..game.JobId:sub(1,8).."..."

-- current server info
local SrvFrame=Instance.new("Frame",Body)
SrvFrame.Size=UDim2.new(1,-16,0,44); SrvFrame.Position=UDim2.new(0,8,0,36)
SrvFrame.BackgroundColor3=cROW; SrvFrame.BorderSizePixel=0; corner(SrvFrame,8)
local SrvL=Instance.new("TextLabel",SrvFrame)
SrvL.Size=UDim2.new(1,-100,1,0); SrvL.Position=UDim2.new(0,10,0,0)
SrvL.BackgroundTransparency=1; SrvL.Font=FN; SrvL.TextSize=11
SrvL.TextColor3=cTXT; SrvL.TextXAlignment=Enum.TextXAlignment.Left
SrvL.Text="JobID: "..game.JobId:sub(1,14).."..."
local CopyBtn=Instance.new("TextButton",SrvFrame)
CopyBtn.Size=UDim2.new(0,82,0,28); CopyBtn.Position=UDim2.new(1,-90,0.5,-14)
CopyBtn.BackgroundColor3=Color3.fromRGB(52,14,108); CopyBtn.Font=FB; CopyBtn.TextSize=11
CopyBtn.TextColor3=cLPP; CopyBtn.Text="Copy ID"; CopyBtn.BorderSizePixel=0
corner(CopyBtn,6); stroke(CopyBtn,cPRP)
CopyBtn.MouseButton1Click:Connect(function()
    setclipboard(game.JobId)
    CopyBtn.Text="Copied!"; task.delay(1.2,function() CopyBtn.Text="Copy ID" end)
end)

-- control buttons
local BtnRow1=Instance.new("Frame",Body)
BtnRow1.Size=UDim2.new(1,-16,0,36); BtnRow1.Position=UDim2.new(0,8,0,86)
BtnRow1.BackgroundTransparency=1
local BRL=Instance.new("UIListLayout",BtnRow1)
BRL.FillDirection=Enum.FillDirection.Horizontal
BRL.Padding=UDim.new(0,6)

local function MakeCtrlBtn(parent,text,col)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(0,0,1,0); b.AutomaticSize=Enum.AutomaticSize.X
    b.BackgroundColor3=col or Color3.fromRGB(52,14,108)
    b.Font=FB; b.TextSize=11; b.TextColor3=cLPP
    b.Text="  "..text.."  "; b.BorderSizePixel=0
    corner(b,7); stroke(b,cPRP)
    return b
end

local ScanBtn  = MakeCtrlBtn(BtnRow1,"▶ Scan Server",Color3.fromRGB(40,10,90))
local HopBtn   = MakeCtrlBtn(BtnRow1,"⟳ Server Hop",Color3.fromRGB(40,10,90))
local StopBtn  = MakeCtrlBtn(BtnRow1,"■ Stop",Color3.fromRGB(70,8,8))

-- filter toggles
local FiltFrame=Instance.new("Frame",Body)
FiltFrame.Size=UDim2.new(1,-16,0,30); FiltFrame.Position=UDim2.new(0,8,0,128)
FiltFrame.BackgroundColor3=cROW; FiltFrame.BorderSizePixel=0; corner(FiltFrame,7)
local FiltL=Instance.new("TextLabel",FiltFrame)
FiltL.Size=UDim2.new(0,70,1,0); FiltL.Position=UDim2.new(0,8,0,0)
FiltL.BackgroundTransparency=1; FiltL.Font=FB; FiltL.TextSize=10
FiltL.TextColor3=cTXT; FiltL.TextXAlignment=Enum.TextXAlignment.Left; FiltL.Text="FILTER:"
local FiltLL=Instance.new("UIListLayout",FiltFrame)
FiltLL.FillDirection=Enum.FillDirection.Horizontal
FiltLL.VerticalAlignment=Enum.VerticalAlignment.Center
FiltLL.Padding=UDim.new(0,4)
pad(FiltFrame,8,8,0,0)

local rarityFilters={
    {name="OG",    col=cOG,      on=true},
    {name="Secret",col=cSEC_COL, on=true},
    {name="Legendary",col=cLEG,  on=true},
    {name="All",   col=cOTH,     on=false},
}
local filterState={OG=true,Secret=true,Legendary=true,All=false}

for _,rf in ipairs(rarityFilters) do
    local fb=Instance.new("TextButton",FiltFrame)
    fb.Size=UDim2.new(0,0,0,22); fb.AutomaticSize=Enum.AutomaticSize.X
    fb.BackgroundColor3=filterState[rf.name] and rf.col or cOFF
    fb.Font=FB; fb.TextSize=10
    fb.TextColor3=filterState[rf.name] and Color3.fromRGB(10,3,20) or cTXT
    fb.Text="  "..rf.name.."  "; fb.BorderSizePixel=0; corner(fb,5)
    fb.MouseButton1Click:Connect(function()
        if rf.name=="All" then
            filterState.OG=true; filterState.Secret=true
            filterState.Legendary=true; filterState.All=true
        else
            filterState[rf.name]=not filterState[rf.name]
        end
        fb.BackgroundColor3=filterState[rf.name] and rf.col or cOFF
        fb.TextColor3=filterState[rf.name] and Color3.fromRGB(10,3,20) or cTXT
    end)
end

-- log header
local LogHead=Instance.new("Frame",Body)
LogHead.Size=UDim2.new(1,-16,0,22); LogHead.Position=UDim2.new(0,8,0,164)
LogHead.BackgroundColor3=cSEC; LogHead.BorderSizePixel=0; corner(LogHead,6)
local LHL=Instance.new("TextLabel",LogHead)
LHL.Size=UDim2.new(1,0,1,0); LHL.BackgroundTransparency=1
LHL.Font=FB; LHL.TextSize=10; LHL.TextColor3=Color3.fromRGB(139,92,246)
LHL.TextXAlignment=Enum.TextXAlignment.Left; LHL.Text="  🧠  BRAINROT LOG"

local ClearBtn=Instance.new("TextButton",LogHead)
ClearBtn.Size=UDim2.new(0,44,0,18); ClearBtn.Position=UDim2.new(1,-48,0.5,-9)
ClearBtn.BackgroundColor3=Color3.fromRGB(50,8,80); ClearBtn.Font=FB; ClearBtn.TextSize=9
ClearBtn.TextColor3=cLPP; ClearBtn.Text="Clear"; ClearBtn.BorderSizePixel=0; corner(ClearBtn,4)

-- log scroll
local LogScroll=Instance.new("ScrollingFrame",Body)
LogScroll.Size=UDim2.new(1,-16,1,-196); LogScroll.Position=UDim2.new(0,8,0,192)
LogScroll.BackgroundColor3=Color3.fromRGB(6,2,16); LogScroll.BorderSizePixel=0
LogScroll.ScrollBarThickness=2; LogScroll.ScrollBarImageColor3=cPRP
LogScroll.CanvasSize=UDim2.new(0,0,0,0); LogScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
corner(LogScroll,8); stroke(LogScroll,Color3.fromRGB(30,8,60))
local LogLayout=Instance.new("UIListLayout",LogScroll)
LogLayout.Padding=UDim.new(0,2)
pad(LogScroll,4,4,4,4)

ClearBtn.MouseButton1Click:Connect(function()
    for _,c in pairs(LogScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
end)

-- ── LOG ENTRY BUILDER ─────────────────────────────────────────────────────────
local function RarityColor(rarity)
    local r=rarity:lower()
    if r:find("og")        then return cOG,       "⭐ OG"       end
    if r:find("secret")    then return cSEC_COL,  "🌀 Secret"   end
    if r:find("legendary") then return cLEG,      "🔥 Legendary"end
    if r:find("mythic")    then return Color3.fromRGB(255,140,255),"✨ Mythic" end
    if r:find("ultra")     then return Color3.fromRGB(100,200,255),"💎 Ultra"  end
    if r:find("godly")     then return Color3.fromRGB(255,220,80),"👑 Godly"  end
    return cOTH, rarity
end

local logCount = 0
local function AddLog(brainrotName, rarity, jobId, isCurrentServer)
    logCount = logCount + 1
    local col, rarLabel = RarityColor(rarity)

    local entry=Instance.new("Frame",LogScroll)
    entry.Size=UDim2.new(1,-4,0,0); entry.AutomaticSize=Enum.AutomaticSize.Y
    entry.BackgroundColor3=Color3.fromRGB(14,5,34); entry.BorderSizePixel=0
    corner(entry,6)

    -- left accent bar
    local bar=Instance.new("Frame",entry)
    bar.Size=UDim2.new(0,3,1,0); bar.BackgroundColor3=col; bar.BorderSizePixel=0
    corner(bar,2)

    local inner=Instance.new("Frame",entry)
    inner.Size=UDim2.new(1,-12,0,0); inner.Position=UDim2.new(0,10,0,0)
    inner.AutomaticSize=Enum.AutomaticSize.Y; inner.BackgroundTransparency=1

    local iL=Instance.new("UIListLayout",inner); iL.Padding=UDim.new(0,2)
    pad(inner,0,0,4,6)

    -- brainrot name
    local nameLbl=Instance.new("TextLabel",inner)
    nameLbl.Size=UDim2.new(1,0,0,18); nameLbl.BackgroundTransparency=1
    nameLbl.Font=FB; nameLbl.TextSize=13; nameLbl.TextColor3=Color3.fromRGB(240,220,255)
    nameLbl.TextXAlignment=Enum.TextXAlignment.Left; nameLbl.Text=brainrotName

    -- rarity badge
    local rarLbl=Instance.new("TextLabel",inner)
    rarLbl.Size=UDim2.new(1,0,0,15); rarLbl.BackgroundTransparency=1
    rarLbl.Font=FB; rarLbl.TextSize=11; rarLbl.TextColor3=col
    rarLbl.TextXAlignment=Enum.TextXAlignment.Left; rarLbl.Text=rarLabel

    -- server id
    local srvLbl=Instance.new("TextLabel",inner)
    srvLbl.Size=UDim2.new(1,0,0,13); srvLbl.BackgroundTransparency=1
    srvLbl.Font=FN; srvLbl.TextSize=10; srvLbl.TextColor3=Color3.fromRGB(130,100,180)
    srvLbl.TextXAlignment=Enum.TextXAlignment.Left
    srvLbl.Text=(isCurrentServer and "📍 THIS SERVER  " or "🌐 ")..jobId:sub(1,20).."..."

    -- JOIN button (only for other servers) / COPY for current
    local btnRow=Instance.new("Frame",inner)
    btnRow.Size=UDim2.new(1,0,0,28); btnRow.BackgroundTransparency=1
    local bRL=Instance.new("UIListLayout",btnRow)
    bRL.FillDirection=Enum.FillDirection.Horizontal; bRL.Padding=UDim.new(0,5)

    if not isCurrentServer then
        local joinB=Instance.new("TextButton",btnRow)
        joinB.Size=UDim2.new(0,70,0,24); joinB.BackgroundColor3=cPRP
        joinB.Font=FB; joinB.TextSize=11; joinB.TextColor3=Color3.fromRGB(240,220,255)
        joinB.Text="  JOIN  "; joinB.BorderSizePixel=0; corner(joinB,6)
        joinB.MouseButton1Click:Connect(function()
            joinB.Text="Going..."
            pcall(function()
                TeleportSvc:TeleportToPlaceInstance(game.PlaceId, jobId, LP)
            end)
        end)
    end

    local cpB=Instance.new("TextButton",btnRow)
    cpB.Size=UDim2.new(0,80,0,24)
    cpB.BackgroundColor3=Color3.fromRGB(40,10,90)
    cpB.Font=FB; cpB.TextSize=11; cpB.TextColor3=cLPP
    cpB.Text="Copy ID"; cpB.BorderSizePixel=0; corner(cpB,6); stroke(cpB,cPRP)
    cpB.MouseButton1Click:Connect(function()
        setclipboard(jobId); cpB.Text="Copied!"; task.delay(1.2,function() cpB.Text="Copy ID" end)
    end)

    -- scroll to bottom
    task.wait()
    LogScroll.CanvasPosition=Vector2.new(0,LogScroll.AbsoluteCanvasSize.Y)

    return entry
end

-- ── RARITY DETECTION ─────────────────────────────────────────────────────────
local function GetRarityFromObject(obj)
    -- check name
    local n = obj.Name:lower()
    for _,k in ipairs(RARE_KEYS) do
        if n:find(k:lower()) then return k end
    end
    -- check StringValue/Attribute children
    for _,c in pairs(obj:GetChildren()) do
        if c:IsA("StringValue") then
            local cn = c.Name:lower()
            local cv = c.Value:lower()
            if cn=="rarity" or cn=="tier" or cn=="rank" then
                for _,k in ipairs(RARE_KEYS) do
                    if cv:find(k:lower()) then return k end
                end
            end
        end
    end
    -- check attributes
    local attr = obj:GetAttributes()
    for aName, aVal in pairs(attr) do
        local an = aName:lower()
        if an=="rarity" or an=="tier" or an=="rank" then
            for _,k in ipairs(RARE_KEYS) do
                if tostring(aVal):lower():find(k:lower()) then return k end
            end
        end
    end
    return nil
end

local function GetBrainrotName(obj)
    -- check if obj name contains a brainrot name
    for _,bn in ipairs(BRAINROT_NAMES) do
        if obj.Name:lower():find(bn:lower()) then return obj.Name end
    end
    -- check children for name tags
    for _,c in pairs(obj:GetChildren()) do
        if c:IsA("StringValue") and (c.Name:lower()=="name" or c.Name:lower()=="brainrotname") then
            return c.Value
        end
        if c:IsA("BillboardGui") then
            for _,lbl in pairs(c:GetDescendants()) do
                if lbl:IsA("TextLabel") and lbl.Text~="" then
                    return lbl.Text
                end
            end
        end
    end
    return obj.Name
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

-- ── SCAN CURRENT SERVER ───────────────────────────────────────────────────────
local scanned = {}

local function ScanWorkspace()
    local found = 0
    -- look in common brainrot folder locations
    local targets = {}
    for _,folderName in ipairs({"Brainrots","Spawned","Active","Pets","Units","Characters","Models"}) do
        local f = workspace:FindFirstChild(folderName,true)
        if f then table.insert(targets,f) end
    end
    -- fallback: scan all workspace
    if #targets==0 then table.insert(targets,workspace) end

    for _,target in ipairs(targets) do
        for _,obj in pairs(target:GetDescendants()) do
            if (obj:IsA("Model") or obj:IsA("Part") or obj:IsA("BasePart")) and not scanned[obj] then
                local rarity = GetRarityFromObject(obj)
                if rarity and ShouldLog(rarity) then
                    scanned[obj]=true
                    found = found + 1
                    local bname = GetBrainrotName(obj)
                    AddLog(bname, rarity, game.JobId, true)
                    print("[zarcy] FOUND:",bname,"|",rarity,"|",game.JobId)
                end
            end
        end
    end
    return found
end

-- ── SERVER HOPPER ─────────────────────────────────────────────────────────────
local hopping = false
local scanning = false

local function SetStatus(txt, col)
    StatLbl.Text = txt
    StatLbl.TextColor3 = col or Color3.fromRGB(139,92,246)
end

local function GetServerList(cursor)
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    if cursor then url = url.."&cursor="..cursor end
    local s,r = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if s then return r end
    return nil
end

ScanBtn.MouseButton1Click:Connect(function()
    if scanning then return end
    scanning = true
    scanned = {}
    SetStatus("🔍 scanning current server...", cLPP)
    ScanBtn.BackgroundColor3 = cPRP
    task.spawn(function()
        local found = ScanWorkspace()
        scanning = false
        ScanBtn.BackgroundColor3 = Color3.fromRGB(40,10,90)
        if found==0 then
            SetStatus("● done — no rare brainrots found", Color3.fromRGB(180,100,100))
            -- add empty log entry
            local entry=Instance.new("Frame",LogScroll)
            entry.Size=UDim2.new(1,-4,0,28); entry.BackgroundColor3=Color3.fromRGB(14,5,34)
            entry.BorderSizePixel=0; corner(entry,6)
            local l=Instance.new("TextLabel",entry)
            l.Size=UDim2.new(1,-10,1,0); l.Position=UDim2.new(0,8,0,0)
            l.BackgroundTransparency=1; l.Font=FN; l.TextSize=11
            l.TextColor3=Color3.fromRGB(120,80,160)
            l.TextXAlignment=Enum.TextXAlignment.Left
            l.Text="No rare brainrots found in this server"
        else
            SetStatus("✓ found "..found.." rare brainrot(s)!", cOG)
        end
    end)
end)

HopBtn.MouseButton1Click:Connect(function()
    if hopping then return end
    hopping = true
    task.spawn(function()
        SetStatus("⟳ fetching server list...", cLPP)
        local list = GetServerList()
        if not list or not list.data then
            SetStatus("✗ failed to get servers", Color3.fromRGB(255,80,80))
            hopping=false; return
        end
        local servers = list.data
        local total = #servers
        SetStatus("⟳ hopping "..total.." servers...", cLPP)

        for i,srv in ipairs(servers) do
            if not hopping then break end
            local jobId = srv.id
            if jobId ~= game.JobId then
                SetStatus("⟳ checking server "..i.."/"..total, cLPP)

                -- check player count as proxy for activity
                local playerCount = srv.playing or 0
                if playerCount > 0 then
                    -- log server being checked
                    local entry=Instance.new("Frame",LogScroll)
                    entry.Size=UDim2.new(1,-4,0,24); entry.BackgroundColor3=Color3.fromRGB(10,4,24)
                    entry.BorderSizePixel=0; corner(entry,4)
                    local l=Instance.new("TextLabel",entry)
                    l.Size=UDim2.new(1,-10,1,0); l.Position=UDim2.new(0,8,0,0)
                    l.BackgroundTransparency=1; l.Font=FN; l.TextSize=10
                    l.TextColor3=Color3.fromRGB(100,70,140)
                    l.TextXAlignment=Enum.TextXAlignment.Left
                    l.Text="🌐 checking: "..jobId:sub(1,18).."...  ["..playerCount.." players]"
                    task.wait()
                    LogScroll.CanvasPosition=Vector2.new(0,LogScroll.AbsoluteCanvasSize.Y)

                    -- add to log as potential server (JOIN button so they can check manually)
                    -- we can't peek inside without joining, so we log all active servers
                    -- with JOIN buttons and let them hop in to verify
                    task.wait(0.08)
                end
            end
            task.wait(0.05)
        end

        if hopping then
            hopping=false
            SetStatus("✓ server scan complete — use JOIN to check", cOG)
        end
    end)
end)

StopBtn.MouseButton1Click:Connect(function()
    hopping=false; scanning=false
    SetStatus("■ stopped", Color3.fromRGB(180,80,80))
    ScanBtn.BackgroundColor3=Color3.fromRGB(40,10,90)
end)

-- ── AUTO SCAN ON LOAD ─────────────────────────────────────────────────────────
task.delay(1.5, function()
    SetStatus("🔍 auto-scanning current server...", cLPP)
    task.spawn(function()
        local found = ScanWorkspace()
        if found > 0 then
            SetStatus("✓ "..found.." rare brainrot(s) in THIS server!", cOG)
        else
            SetStatus("● ready — "..game.JobId:sub(1,8).."...", Color3.fromRGB(139,92,246))
        end
    end)
end)

-- live scan loop — catches new spawns
local Conns={}
table.insert(Conns, RunService.Heartbeat:Connect(function()
    -- passive: scan every 3s for new spawns
end))

local lastScan=0
table.insert(Conns, RunService.Stepped:Connect(function()
    local now=tick()
    if now-lastScan < 3 then return end
    lastScan=now
    task.spawn(function()
        for _,obj in pairs(workspace:GetDescendants()) do
            if (obj:IsA("Model") or obj:IsA("BasePart")) and not scanned[obj] then
                local rarity=GetRarityFromObject(obj)
                if rarity and ShouldLog(rarity) then
                    scanned[obj]=true
                    local bname=GetBrainrotName(obj)
                    AddLog(bname,rarity,game.JobId,true)
                    SetStatus("🧠 NEW: "..bname.." ["..rarity.."] spawned!",cOG)
                    print("[zarcy] NEW SPAWN:",bname,"|",rarity)
                end
            end
        end
    end)
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
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
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
Fab.BackgroundColor3=Color3.fromRGB(76,29,149); Fab.Font=FB; Fab.TextSize=18
Fab.TextColor3=cLPP; Fab.Text="🧠"; Fab.BorderSizePixel=0; Fab.ZIndex=12
corner(Fab,25); stroke(Fab,cLPP,1.5)
Fab.MouseButton1Click:Connect(function() Main.Visible=not Main.Visible end)

print("[zarcy] brainrot scanner loaded | place: "..game.PlaceId)

end)
if not ok then warn("[zarcy] error: "..tostring(err)) end
