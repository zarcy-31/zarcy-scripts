--[[
    zarcy's Brainrot Carpet Scanner v1
    Game     : Steal A Brainrot
    Executor : Delta (mobile)
]]

if getgenv().ZarcyBRLoaded then
    pcall(function() game:GetService("CoreGui"):FindFirstChild("ZarcyBR"):Destroy() end)
    pcall(function() game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ZarcyBR"):Destroy() end)
end
getgenv().ZarcyBRLoaded = true

local ok, err = pcall(function()

local Players    = game:GetService("Players")
local TweenSvc   = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LP         = Players.LocalPlayer

local RARE_KEYS = {
    "OG","Secret","Legendary","Mythic","Ultra","Godly",
    "Limited","Exclusive","Ancient","Divine","Celestial","Rare","Epic"
}
local BRAINROT_NAMES = {
    "Tralalelo","Tralala","Bombardino","Coccodrillo","Bombombini",
    "Gusini","Capuchino","Assassino","Ballerina","Cappuccina",
    "Tung","Sahur","Glorbo","Frutiger","Aero","Brainrot",
    "Skibidi","Rizz","Gyatt","Sigma","Ohio","Sussy","Mewing",
    "Hawk","Tuah","Lirili","Larila","Boneca","Ambalabu",
    "Burbaloni","Lulilolli","Tracotoco","Triciclo","Crocodilo",
    "Pinguim","Frigobar","Chimpanzini","Bananini","Glorbo",
    "Boykisser","Nerd","Goober","Blud","Rizzer","Skibi",
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
local cOG  = Color3.fromRGB(255,190,30)
local cSCL = Color3.fromRGB(255,80,220)
local cLEG = Color3.fromRGB(255,100,100)
local cMYT = Color3.fromRGB(255,140,255)
local cULT = Color3.fromRGB(100,200,255)
local cGOD = Color3.fromRGB(255,220,80)
local cCOM = Color3.fromRGB(140,200,140)
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
Notif.Size=UDim2.new(0,250,0,40); Notif.Position=UDim2.new(0.5,-125,0,14)
Notif.BackgroundColor3=cHDR; Notif.BorderSizePixel=0; Notif.ZIndex=99
corner(Notif,10); stroke(Notif,cLPP)
local NL=Instance.new("TextLabel",Notif)
NL.Size=UDim2.new(1,0,1,0); NL.BackgroundTransparency=1
NL.Font=FB; NL.TextSize=13; NL.TextColor3=cLPP
NL.Text="🧠  zarcy's carpet scanner"
task.delay(2.5,function()
    TweenSvc:Create(Notif,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
    TweenSvc:Create(NL,TweenInfo.new(0.4),{TextTransparency=1}):Play()
    task.wait(0.45); Notif:Destroy()
end)

local W,H=268,440
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
HTL.Text="🧠  carpet scanner"
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

-- status bar
local StatBar=Instance.new("Frame",Body)
StatBar.Size=UDim2.new(1,0,0,28); StatBar.Position=UDim2.new(0,0,0,0)
StatBar.BackgroundColor3=cSEC; StatBar.BorderSizePixel=0
local StatLbl=Instance.new("TextLabel",StatBar)
StatLbl.Size=UDim2.new(1,-10,1,0); StatLbl.Position=UDim2.new(0,8,0,0)
StatLbl.BackgroundTransparency=1; StatLbl.Font=FB; StatLbl.TextSize=11
StatLbl.TextColor3=Color3.fromRGB(139,92,246)
StatLbl.TextXAlignment=Enum.TextXAlignment.Left
StatLbl.Text="● scanning carpet..."

local function SetStatus(txt,col)
    StatLbl.Text=txt
    StatLbl.TextColor3=col or Color3.fromRGB(139,92,246)
end

-- carpet info row
local CarpetInfo=Instance.new("Frame",Body)
CarpetInfo.Size=UDim2.new(1,-16,0,32); CarpetInfo.Position=UDim2.new(0,8,0,34)
CarpetInfo.BackgroundColor3=cROW; CarpetInfo.BorderSizePixel=0; corner(CarpetInfo,7)
local CarpetLbl=Instance.new("TextLabel",CarpetInfo)
CarpetLbl.Size=UDim2.new(1,-100,1,0); CarpetLbl.Position=UDim2.new(0,10,0,0)
CarpetLbl.BackgroundTransparency=1; CarpetLbl.Font=FB; CarpetLbl.TextSize=11
CarpetLbl.TextColor3=cTXT; CarpetLbl.TextXAlignment=Enum.TextXAlignment.Left
CarpetLbl.Text="🟣  Carpet: locating..."
local RescanBtn=Instance.new("TextButton",CarpetInfo)
RescanBtn.Size=UDim2.new(0,84,0,24); RescanBtn.Position=UDim2.new(1,-90,0.5,-12)
RescanBtn.BackgroundColor3=Color3.fromRGB(40,10,90); RescanBtn.Font=FB; RescanBtn.TextSize=11
RescanBtn.TextColor3=cLPP; RescanBtn.Text="↺ Rescan"; RescanBtn.BorderSizePixel=0
corner(RescanBtn,6); stroke(RescanBtn,cPRP)

-- filter bar
local FiltBar=Instance.new("Frame",Body)
FiltBar.Size=UDim2.new(1,-16,0,28); FiltBar.Position=UDim2.new(0,8,0,72)
FiltBar.BackgroundColor3=cROW; FiltBar.BorderSizePixel=0; corner(FiltBar,6)
pad(FiltBar,6,6,0,0)
local FL=Instance.new("UIListLayout",FiltBar)
FL.FillDirection=Enum.FillDirection.Horizontal
FL.VerticalAlignment=Enum.VerticalAlignment.Center
FL.Padding=UDim.new(0,4)

local filterState={OG=true,Secret=true,Legendary=true,All=false}
local rarDefs={
    {k="OG",        col=cOG,  label="⭐ OG"},
    {k="Secret",    col=cSCL, label="🌀 Secret"},
    {k="Legendary", col=cLEG, label="🔥 Legend"},
    {k="All",       col=cCOM, label="All"},
}
local fBtns={}
for _,rd in ipairs(rarDefs) do
    local fb=Instance.new("TextButton",FiltBar)
    fb.Size=UDim2.new(0,0,0,22); fb.AutomaticSize=Enum.AutomaticSize.X
    fb.BackgroundColor3=filterState[rd.k] and rd.col or cOFF
    fb.Font=FB; fb.TextSize=10
    fb.TextColor3=filterState[rd.k] and Color3.fromRGB(10,3,20) or cTXT
    fb.Text="  "..rd.label.."  "; fb.BorderSizePixel=0; corner(fb,5)
    fBtns[rd.k]=fb
    local rdd=rd
    fb.MouseButton1Click:Connect(function()
        if rdd.k=="All" then
            for k in pairs(filterState) do filterState[k]=true end
            for _,b in pairs(fBtns) do b.BackgroundColor3=cCOM; b.TextColor3=Color3.fromRGB(10,3,20) end
        else
            filterState[rdd.k]=not filterState[rdd.k]
            fb.BackgroundColor3=filterState[rdd.k] and rdd.col or cOFF
            fb.TextColor3=filterState[rdd.k] and Color3.fromRGB(10,3,20) or cTXT
        end
    end)
end

-- live carpet counter
local CountBar=Instance.new("Frame",Body)
CountBar.Size=UDim2.new(1,-16,0,22); CountBar.Position=UDim2.new(0,8,0,106)
CountBar.BackgroundColor3=cSEC; CountBar.BorderSizePixel=0; corner(CountBar,6)
local CountLbl=Instance.new("TextLabel",CountBar)
CountLbl.Size=UDim2.new(0.6,0,1,0); CountLbl.Position=UDim2.new(0,8,0,0)
CountLbl.BackgroundTransparency=1; CountLbl.Font=FB; CountLbl.TextSize=10
CountLbl.TextColor3=Color3.fromRGB(139,92,246)
CountLbl.TextXAlignment=Enum.TextXAlignment.Left
CountLbl.Text="🟣 ON CARPET NOW: 0"
local ClearBtn=Instance.new("TextButton",CountBar)
ClearBtn.Size=UDim2.new(0,46,0,18); ClearBtn.Position=UDim2.new(1,-50,0.5,-9)
ClearBtn.BackgroundColor3=Color3.fromRGB(50,8,80); ClearBtn.Font=FB; ClearBtn.TextSize=9
ClearBtn.TextColor3=cLPP; ClearBtn.Text="Clear"; ClearBtn.BorderSizePixel=0; corner(ClearBtn,4)

-- log scroll
local LogScroll=Instance.new("ScrollingFrame",Body)
LogScroll.Size=UDim2.new(1,-16,1,-134); LogScroll.Position=UDim2.new(0,8,0,132)
LogScroll.BackgroundColor3=Color3.fromRGB(6,2,16); LogScroll.BorderSizePixel=0
LogScroll.ScrollBarThickness=2; LogScroll.ScrollBarImageColor3=cPRP
LogScroll.CanvasSize=UDim2.new(0,0,0,0); LogScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
corner(LogScroll,8); stroke(LogScroll,Color3.fromRGB(30,8,60))
local LogLayout=Instance.new("UIListLayout",LogScroll); LogLayout.Padding=UDim.new(0,3)
pad(LogScroll,4,4,4,4)

ClearBtn.MouseButton1Click:Connect(function()
    for _,c in pairs(LogScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
end)

-- ── RARITY HELPERS ───────────────────────────────────────────────────────────
local function RarityColor(rarity)
    local r=rarity:lower()
    if r:find("og")        then return cOG,  "⭐ OG"         end
    if r:find("secret")    then return cSCL, "🌀 Secret"     end
    if r:find("legendary") then return cLEG, "🔥 Legendary"  end
    if r:find("mythic")    then return cMYT, "✨ Mythic"     end
    if r:find("ultra")     then return cULT, "💎 Ultra"      end
    if r:find("godly")     then return cGOD, "👑 Godly"      end
    if r:find("epic")      then return Color3.fromRGB(180,100,255),"💜 Epic" end
    if r:find("rare")      then return Color3.fromRGB(100,160,255),"🔵 Rare" end
    if r:find("limited")   then return Color3.fromRGB(255,160,60),"🎫 Limited" end
    return cCOM, rarity
end

local function ShouldShow(rarity)
    if filterState.All then return true end
    if not rarity then return false end
    local r=rarity:lower()
    if filterState.OG        and r:find("og")        then return true end
    if filterState.Secret    and r:find("secret")    then return true end
    if filterState.Legendary and r:find("legendary") then return true end
    return false
end

local function GetRarity(obj)
    -- 1. check object name
    local n=obj.Name:lower()
    for _,k in ipairs(RARE_KEYS) do if n:find(k:lower()) then return k end end
    -- 2. StringValue children
    for _,c in pairs(obj:GetChildren()) do
        if c:IsA("StringValue") then
            local cn=c.Name:lower()
            if cn=="rarity" or cn=="tier" or cn=="rank" or cn=="type" then
                for _,k in ipairs(RARE_KEYS) do
                    if c.Value:lower():find(k:lower()) then return k end
                end
                return c.Value -- return raw value if no match
            end
        end
    end
    -- 3. attributes
    for an,av in pairs(obj:GetAttributes()) do
        local al=an:lower()
        if al=="rarity" or al=="tier" or al=="rank" then
            for _,k in ipairs(RARE_KEYS) do
                if tostring(av):lower():find(k:lower()) then return k end
            end
            return tostring(av)
        end
    end
    -- 4. check parent name
    if obj.Parent then
        local pn=obj.Parent.Name:lower()
        for _,k in ipairs(RARE_KEYS) do if pn:find(k:lower()) then return k end end
    end
    return "Common"
end

local function GetBrainrotName(obj)
    -- billboard label
    for _,desc in pairs(obj:GetDescendants()) do
        if desc:IsA("BillboardGui") then
            for _,l in pairs(desc:GetDescendants()) do
                if l:IsA("TextLabel") and l.Text~="" and #l.Text>2 then
                    return l.Text
                end
            end
        end
    end
    -- StringValue name tag
    for _,c in pairs(obj:GetChildren()) do
        if c:IsA("StringValue") and (c.Name:lower()=="name" or c.Name:lower()=="brainrotname" or c.Name:lower()=="unitname") then
            return c.Value
        end
    end
    -- known name in object name
    for _,bn in ipairs(BRAINROT_NAMES) do
        if obj.Name:lower():find(bn:lower()) then return obj.Name end
    end
    return obj.Name
end

-- ── CARPET LOCATOR ───────────────────────────────────────────────────────────
local carpetPart = nil
local carpetPos  = nil
local CARPET_RANGE = 40 -- stud radius around carpet center

local CARPET_NAMES = {
    "carpet","rug","mat","floor","display","pad","spawn",
    "brainrotpad","spawnpad","area","zone","platform"
}

local function FindCarpet()
    -- search workspace for carpet by name
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
            local n=obj.Name:lower()
            for _,cn in ipairs(CARPET_NAMES) do
                if n:find(cn) then
                    carpetPart=obj
                    carpetPos=obj.Position
                    CarpetLbl.Text="🟣  Carpet: "..obj.Name.." found"
                    return true
                end
            end
        end
        -- also check models
        if obj:IsA("Model") then
            local n=obj.Name:lower()
            for _,cn in ipairs(CARPET_NAMES) do
                if n:find(cn) then
                    local cf=obj:FindFirstChildWhichIsA("BasePart")
                    if cf then
                        carpetPart=cf; carpetPos=cf.Position
                        CarpetLbl.Text="🟣  Carpet: "..obj.Name.." found"
                        return true
                    end
                end
            end
        end
    end
    -- fallback: any large flat part near center of map
    local best,bd=nil,math.huge
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Size.X>10 and obj.Size.Z>10 and obj.Size.Y<3 then
            local d=obj.Position.Magnitude
            if d<bd then bd=d; best=obj end
        end
    end
    if best then
        carpetPart=best; carpetPos=best.Position
        CarpetLbl.Text="🟣  Carpet: fallback → "..best.Name
        return true
    end
    CarpetLbl.Text="⚠  Carpet not found — using workspace"
    return false
end

-- ── LOG ENTRY ────────────────────────────────────────────────────────────────
local loggedObjs = {} -- obj → frame, so we can remove when gone

local function RemoveLog(obj)
    if loggedObjs[obj] then
        pcall(function() loggedObjs[obj]:Destroy() end)
        loggedObjs[obj]=nil
    end
end

local function AddCarpetLog(obj, brainrotName, rarity)
    if loggedObjs[obj] then return end -- already logged

    local col, rarLabel = RarityColor(rarity)

    local entry=Instance.new("Frame",LogScroll)
    entry.Size=UDim2.new(1,-4,0,0); entry.AutomaticSize=Enum.AutomaticSize.Y
    entry.BackgroundColor3=Color3.fromRGB(14,5,34); entry.BorderSizePixel=0
    corner(entry,7); stroke(entry,col,0.7)
    loggedObjs[obj]=entry

    -- accent bar
    local bar=Instance.new("Frame",entry)
    bar.Size=UDim2.new(0,3,1,0); bar.BackgroundColor3=col; bar.BorderSizePixel=0; corner(bar,2)

    local inner=Instance.new("Frame",entry)
    inner.Size=UDim2.new(1,-14,0,0); inner.Position=UDim2.new(0,11,0,0)
    inner.AutomaticSize=Enum.AutomaticSize.Y; inner.BackgroundTransparency=1
    local iL=Instance.new("UIListLayout",inner); iL.Padding=UDim.new(0,2)
    pad(inner,0,0,5,7)

    -- name
    local nameLbl=Instance.new("TextLabel",inner)
    nameLbl.Size=UDim2.new(1,0,0,18); nameLbl.BackgroundTransparency=1
    nameLbl.Font=FB; nameLbl.TextSize=14; nameLbl.TextColor3=Color3.fromRGB(240,220,255)
    nameLbl.TextXAlignment=Enum.TextXAlignment.Left; nameLbl.Text=brainrotName

    -- rarity
    local rarLbl=Instance.new("TextLabel",inner)
    rarLbl.Size=UDim2.new(1,0,0,14); rarLbl.BackgroundTransparency=1
    rarLbl.Font=FB; rarLbl.TextSize=12; rarLbl.TextColor3=col
    rarLbl.TextXAlignment=Enum.TextXAlignment.Left; rarLbl.Text=rarLabel

    -- position tag
    local root = obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart") or obj
    local posStr = ""
    if root then
        local p=root.Position
        posStr=string.format("📍 %.1f, %.1f, %.1f", p.X, p.Y, p.Z)
    end
    local posLbl=Instance.new("TextLabel",inner)
    posLbl.Size=UDim2.new(1,0,0,13); posLbl.BackgroundTransparency=1
    posLbl.Font=FN; posLbl.TextSize=10; posLbl.TextColor3=Color3.fromRGB(120,90,170)
    posLbl.TextXAlignment=Enum.TextXAlignment.Left; posLbl.Text=posStr

    -- button row
    local btnF=Instance.new("Frame",inner)
    btnF.Size=UDim2.new(1,0,0,30); btnF.BackgroundTransparency=1
    local bFL=Instance.new("UIListLayout",btnF)
    bFL.FillDirection=Enum.FillDirection.Horizontal
    bFL.VerticalAlignment=Enum.VerticalAlignment.Center
    bFL.Padding=UDim.new(0,6)

    -- TP button
    local tpB=Instance.new("TextButton",btnF)
    tpB.Size=UDim2.new(0,68,0,26); tpB.BackgroundColor3=cPRP
    tpB.Font=FB; tpB.TextSize=12; tpB.TextColor3=Color3.fromRGB(240,220,255)
    tpB.Text="  TP  "; tpB.BorderSizePixel=0; corner(tpB,7); stroke(tpB,Color3.fromRGB(160,80,255))
    tpB.MouseButton1Click:Connect(function()
        local chr=LP.Character
        local hrp=chr and chr:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local target = obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart") or obj
        if target then
            hrp.CFrame=CFrame.new(target.Position+Vector3.new(0,4,0))
            tpB.Text="✓ TP'd"
            task.delay(1.5,function() if tpB and tpB.Parent then tpB.Text="  TP  " end end)
        end
    end)

    -- highlight button (draws an outline around it)
    local hlB=Instance.new("TextButton",btnF)
    hlB.Size=UDim2.new(0,76,0,26); hlB.BackgroundColor3=Color3.fromRGB(35,10,75)
    hlB.Font=FB; hlB.TextSize=11; hlB.TextColor3=cLPP
    hlB.Text="Highlight"; hlB.BorderSizePixel=0; corner(hlB,7); stroke(hlB,cPRP)
    local highlighted=false
    local selBox=nil
    hlB.MouseButton1Click:Connect(function()
        highlighted=not highlighted
        if highlighted then
            selBox=Instance.new("SelectionBox")
            selBox.Color3=col; selBox.LineThickness=0.08
            selBox.SurfaceTransparency=0.6; selBox.SurfaceColor3=col
            selBox.Adornee=obj:IsA("Model") and obj or obj
            selBox.Parent=workspace
            hlB.Text="● Live"; hlB.BackgroundColor3=cPRP
        else
            if selBox then selBox:Destroy(); selBox=nil end
            hlB.Text="Highlight"; hlB.BackgroundColor3=Color3.fromRGB(35,10,75)
        end
    end)
    -- clean up selbox if entry removed
    entry.AncestryChanged:Connect(function()
        if selBox then pcall(function() selBox:Destroy() end); selBox=nil end
    end)

    task.wait()
    LogScroll.CanvasPosition=Vector2.new(0,math.huge)
end

-- ── CARPET SCANNER LOOP ───────────────────────────────────────────────────────
local Conns={}
local scanActive=true

-- find carpet on load
task.delay(1,function() FindCarpet() end)

RescanBtn.MouseButton1Click:Connect(function()
    carpetPart=nil; carpetPos=nil
    FindCarpet()
    -- clear stale entries
    for obj,frame in pairs(loggedObjs) do
        pcall(function() frame:Destroy() end)
    end
    loggedObjs={}
    SetStatus("↺ rescanned carpet",cLPP)
end)

-- every 0.5s: check what's on the carpet, add new, remove gone
local lastTick=0
table.insert(Conns, RunService.Stepped:Connect(function()
    if not scanActive then return end
    local now=tick()
    if now-lastTick < 0.5 then return end
    lastTick=now

    task.spawn(function()
        -- determine scan zone
        local scanPos = carpetPos
        local scanRange = CARPET_RANGE

        -- if no carpet found yet try again
        if not scanPos then
            FindCarpet()
            scanPos=carpetPos
        end

        local found={}
        local candidates={}

        -- collect all brainrot candidates in range
        for _,obj in pairs(workspace:GetDescendants()) do
            local isModel  = obj:IsA("Model")
            local isPart   = obj:IsA("BasePart") or obj:IsA("MeshPart")
            if not (isModel or isPart) then continue end

            -- get world position
            local worldPos
            if isModel then
                local root=obj:FindFirstChildWhichIsA("BasePart")
                if root then worldPos=root.Position end
            else
                worldPos=obj.Position
            end
            if not worldPos then continue end

            -- range check
            local inRange = true
            if scanPos then
                inRange = (worldPos - scanPos).Magnitude <= scanRange
            end
            if not inRange then continue end

            -- is it a brainrot?
            local isBrainrot=false
            local n=obj.Name:lower()
            for _,bn in ipairs(BRAINROT_NAMES) do
                if n:find(bn:lower()) then isBrainrot=true; break end
            end
            -- also check if it has a rarity tag (likely a brainrot item)
            local rarity=GetRarity(obj)
            if rarity and rarity~="Common" then isBrainrot=true end

            if isBrainrot then
                found[obj]=true
                if not loggedObjs[obj] and ShouldShow(rarity) then
                    table.insert(candidates,{obj=obj,rarity=rarity})
                end
            end
        end

        -- add new ones
        local newCount=#candidates
        for _,c in ipairs(candidates) do
            local bname=GetBrainrotName(c.obj)
            AddCarpetLog(c.obj, bname, c.rarity)
            print("[zarcy] ON CARPET:",bname,"|",c.rarity)
            if newCount>0 then
                SetStatus("🧠 "..bname.." ["..c.rarity.."] on carpet!",cOG)
            end
        end

        -- remove ones that left
        for obj,_ in pairs(loggedObjs) do
            if not found[obj] and (not obj or not obj.Parent) then
                RemoveLog(obj)
            end
        end

        -- update counter
        local onCarpet=0
        for _ in pairs(loggedObjs) do onCarpet=onCarpet+1 end
        CountLbl.Text="🟣 ON CARPET NOW: "..onCarpet

        if onCarpet==0 and newCount==0 then
            SetStatus("● watching carpet — nothing rare yet",Color3.fromRGB(139,92,246))
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
    scanActive=false
    for _,c in ipairs(Conns) do pcall(function() c:Disconnect() end) end
    for obj,_ in pairs(loggedObjs) do RemoveLog(obj) end
    getgenv().ZarcyBRLoaded=false; SG:Destroy()
end)

-- ── FAB ──────────────────────────────────────────────────────────────────────
local Fab=Instance.new("TextButton",SG)
Fab.Size=UDim2.new(0,50,0,50); Fab.Position=UDim2.new(0.5,-25,1,-86)
Fab.BackgroundColor3=Color3.fromRGB(76,29,149); Fab.Font=FB; Fab.TextSize=20
Fab.TextColor3=cLPP; Fab.Text="🧠"; Fab.BorderSizePixel=0; Fab.ZIndex=12
corner(Fab,25); stroke(Fab,cLPP,1.5)
Fab.MouseButton1Click:Connect(function() Main.Visible=not Main.Visible end)

print("[zarcy] carpet scanner loaded")

end)
if not ok then warn("[zarcy] carpet scanner error: "..tostring(err)) end
