-- Invite For Discord
local function invite()
    if not isfolder('kingdom') then
        makefolder('kingdom')
    end
    if isfile('kingdom.txt') == false then
        (syn and syn.request or http_request)({
            Url = 'http://127.0.0.1:6463/rpc?v=1',
            Method = 'POST',
            Headers = {
                ['Content-Type'] = 'application/json',
                ['Origin'] = 'https://discord.com'
            },
            Body = game:GetService('HttpService'):JSONEncode({
                cmd = 'INVITE_BROWSER',
                args = {
                    code = 'WFS3gYURAk'
                },
                nonce = game:GetService('HttpService'):GenerateGUID(false)
            }),
            writefile('kingdom.txt', 'discord')
        })
    end
end

-- Services
local Players = game:GetService('Players')
local WRK = game:GetService('Workspace')
local VU = game:GetService('VirtualUser')
local REP = game:GetService('ReplicatedStorage')
local UIS = game:GetService('UserInputService')
local RS = game:GetService('RunService')

-- Variables
local Player = Players.LocalPlayer
local RebirthShop = require(REP.RebirthShopModule).rebirthShop
local Mod = require(REP.FunctionsModule)
local Gamepass = Player.Data.gamepasses
local RebirthMod = getsenv(Player.PlayerGui.mainUI.rebirthBackground.LocalScript)
local letters = {'K', 'M', 'B', 'T', 'Qa', 'Qi', 'Sx', 'Sp', 'Oc', 'No', 'Dc', 'Ud', 'Dd', 'Td'}

-- Anti-AFK
Player.Idled:connect(function()
    VU:Button2Down(Vector2.new(0, 0), WRK.CurrentCamera.CFrame)
    wait(1)
    VU:Button2Up(Vector2.new(0, 0), WRK.CurrentCamera.CFrame)
end)

-- Client
local client = ({
    utilities = {
        autoclick = false,
        autospin = false,
        autoquests = false,
        autogifts = false,
        collectchests = false,
        autobuyrebirths = false,
        autobuyjumps = false
    },
    teleportation = {
        player = '',
        clickteleport = false
    },
    rebirth = {
        rebirthValue = '1',
        autorebirth = false,
        UnRebirthValue = '',
        AutoUnRebirth = false
    },
    inventory = {
        egg = 'Basic',
        autohatch = false,
        autotriplehatch = false,
        autoshiny = false,
        autogolden = false,
        autobest = false,
        autodelete = false
    },
    localplayer = {
        jumppower = false
    }
})

-- Library & Window
local Library = loadstring(game:HttpGet(
    'https://raw.githubusercontent.com/RegularVynixu/UI-Libraries/main/Vynixius%20UI%20Library/Source.lua'))()

for _, v in next, game:GetService('CoreGui'):GetChildren() do
    if v.Name == 'Kindom Hub Clicker Simulator' then
        v:Destroy()
    end
end

local Theme = {
    ThemeColor = Color3.fromRGB(0, 119, 255),
    TopbarColor = Color3.fromRGB(30, 30, 30),
    SidebarColor = Color3.fromRGB(25, 25, 25),
    BackgroundColor = Color3.fromRGB(20, 20, 20),
    SectionColor = Color3.fromRGB(30, 30, 30),
    TextColor = Color3.fromRGB(255, 255, 255)
}

local Window = Library:AddWindow({
    title = {'Kindom Hub', 'Clicker Simulator'},
    theme = Theme,
    key = Enum.KeyCode.RightAlt
})

-- Tabs
local CreditsTab = Window:AddTab('Credits')
local UtilityTab = Window:AddTab('Utilities')
local TeleportationTab = Window:AddTab('Teleportation')
local RebirthTab = Window:AddTab('Rebirth')
local InventoryTab = Window:AddTab('Inventory')
local LocalPlayerTab = Window:AddTab('Local Player')
CreditsTab:Show()

-- Credits Section
local CreditsSection = CreditsTab:AddSection('Credits')
CreditsSection:AddDualLabel({'Script', 'Trustsense#8185'})
CreditsSection:AddDualLabel({'Additional Help', 'Discord !0000#6303'})
CreditsSection:AddDualLabel({'User Interface', 'RegularVynixu#8039'})

-- Extra Section
local ExtraSection = CreditsTab:AddSection('Extra')
ExtraSection:AddButton('Join Kingdom Community', function()
    invite()
end)

ExtraSection:AddClipboardLabel('https://discord.gg/WFS3gYURAk')

-- Utilities Section
local FarmingSection = UtilityTab:AddSection('Farming')
FarmingSection:AddToggle('Auto Click', 'Toggle', function(state)
    client.utilities.autoclick = state
    while client.utilities.autoclick do
        task.wait()
        getsenv(Player.PlayerGui.mainUI.LocalScript).activateClick()
    end
end)

FarmingSection:AddToggle('Auto Spin Daily Wheel', 'Toggle', function(state)
    client.utilities.autospin = state
    while client.utilities.autospin do
        task.wait()
        if Player.Data.freeSpinTimeLeft.Value == 0 then
            REP.Events.Client.spinWheel:InvokeServer()
        end
    end
end)

FarmingSection:AddButton('Unlock Double Clicks Boost', function()
    Player.Boosts.DoubleClicks.isActive.Value = true
end)

-- Collect Section
local CollectSection = UtilityTab:AddSection('Collect')
CollectSection:AddToggle('Auto Collect Gifts', 'Toggle', function(state)
    client.utilities.autogifts = state
    while client.utilities.autogifts do
        task.wait()
        for _, v in pairs(getconnections(Player.PlayerGui.randomGiftUI.randomGiftBackground.Background.confirm
                                             .MouseButton1Click)) do
            v.Function()
        end
    end
end)

CollectSection:AddToggle('Auto Collect Achievements', 'Toggle', function(state)
    client.utilities.autoquest = state
    while client.utilities.autoquest do
        task.wait()
        for _, v in next, Player.currentQuests:GetChildren() do
            if v.questCompleted.Value == true then
                REP.Events.Client.claimQuest:FireServer(v.Name)
            end
        end
    end
end)

CollectSection:AddToggle('Auto Collect All Chests', 'Toggle', function(state)
    client.utilities.collectchests = state
    while client.utilities.collectchests do
        task.wait(0.3)
        for _, v in next, WRK.Chests:GetChildren() do
            REP.Events.Client.claimChestReward:InvokeServer(v.Name)
        end
    end
end)

CollectSection:AddButton('Collect All Chests', function()
    for _, v in next, WRK.Chests:GetChildren() do
        REP.Events.Client.claimChestReward:InvokeServer(v.Name)
    end
end)

-- Other Section
local OtherSection = UtilityTab:AddSection('Other')
local function shopTable()
    local shopTable = {}
    for _, v in next, RebirthShop do
        if rawget(v, 'name') then
            table.insert(shopTable, v.name)
        end
    end
    return shopTable
end

OtherSection:AddToggle('Auto Buy Rebirth Shop', 'Toggle', function(state)
    client.utilities.autobuyrebirths = state
    while client.utilities.autobuyrebirths do
        task.wait(0.3)
        for _, v in next, (shopTable()) do
            REP.Events.Client.purchaseRebirthShopItem:FireServer(v)
        end
    end
end)

OtherSection:AddToggle('Auto Buy Jumps', 'Toggle', function(state)
    client.utilities.autobuyjumps = state
    while client.utilities.autobuyjumps do
        task.wait(0.3)
        for _, v in next, WRK.Clouds:GetChildren() do
            REP.Events.Client.upgrades.upgradeDoubleJump:FireServer(v.Name, 1)
        end
    end
end)

-- ExtraMN Section
local ExtraMNSection = UtilityTab:AddSection('Extra')
ExtraMNSection:AddButton('Redeem All Codes', function()
    local codesTable = {'150KCLICKS', '125KLUCK', '100KLIKES', '75KLIKES', '50KLikes', '30klikes', '20KLIKES',
                        'freeautohatch', '175KLIKELUCK', '225KLIKECODE', '200KLIKECODE'}
    for _, v in pairs(codesTable) do
        REP.Events.Client.useTwitterCode:InvokeServer(v)
    end
end)

ExtraMNSection:AddButton('Unlock Auto Click Gamepass', function()
    Gamepass.Value = Gamepass.Value .. ';autoclicker;'
end)

ExtraMNSection:AddButton('Unlock Auto Rebirth Gamepass', function()
    Gamepass.Value = Gamepass.Value .. ';autorebirth;'
end)

-- PlayerTP Section
local PlayerTPSection = TeleportationTab:AddSection('Player Teleportation')
local function getPlayers()
    local playersTable = {}
    for _, v in next, Players:GetChildren() do
        table.insert(playersTable, v.Name)
    end
    return playersTable
end

local PlayersDrop = PlayerTPSection:AddDropdown('Players', getPlayers(), function(value)
    client.teleportation.player = value.Name
end)

PlayerTPSection:AddButton('Teleport', function()
    Player.Character.HumanoidRootPart.CFrame = CFrame.new(Players[client.teleportation.player].Character
                                                              .HumanoidRootPart.Position)
end)

-- Locations Section
local LocationsSection = TeleportationTab:AddSection('Locations')
local function getZones()
    local zonesTable = {}
    for i, v in next, WRK.Zones:GetChildren() do
        table.insert(zonesTable, v.Name)
    end
    return zonesTable
end

LocationsSection:AddDropdown('Zones', getZones(), function(value)
    Player.Character.HumanoidRootPart.CFrame = CFrame.new(WRK.Zones[value.Name].Island.Platform.UIPart.Position)
end)

local function getEggs()
    local newEggs = {unpack(require(REP.EggModule).Order)}
    for _, v in next, WRK.Eggs:GetChildren() do
        if not tostring(v):find('Robux') and not table.find(newEggs, tostring(v)) and
            not table.find(require(REP.EggModule).Order, tostring(v)) then
            table.insert(newEggs, tostring(v))
        end
    end
    return newEggs
end

LocationsSection:AddDropdown('Eggs', getEggs(), function(value)
    Player.Character.HumanoidRootPart.CFrame = CFrame.new(WRK.Eggs[value.Name].Cost.Position)
end)

local function getChests()
    local chestsTable = {}
    for _, v in next, WRK.Chests:GetChildren() do
        table.insert(chestsTable, v.Name)
    end
    return chestsTable
end

LocationsSection:AddDropdown('Chests', getChests(), function(value)
    Player.Character.HumanoidRootPart.CFrame = CFrame.new(WRK.Chests[value.Name].Design.Detector.Position)
end)

-- Rebirth Section
local RebirthSection = RebirthTab:AddSection('Rebirth')
local function getRebirths()
    local rebirthsTable = {1, 5, 10}
    for _, v in next, RebirthShop do
        if rawget(v, 'rebirthOption') then
            table.insert(rebirthsTable, v.rebirthOption)
        end
    end
    return rebirthsTable
end

RebirthSection:AddDropdown('Rebirths Ammount', getRebirths(), function(value)
    client.rebirth.rebirthValue = value.Name
end)

RebirthSection:AddToggle('Auto Rebirth', 'Toggle', function(state)
    client.rebirth.autorebirth = state
    while client.rebirth.autorebirth do
        task.wait(0.2)
        RebirthMod.requestRebirth(tonumber(client.rebirth.rebirthValue))
    end
end)

-- Unlimited Rebirth Section
local UnRebirthSection = RebirthTab:AddSection('Unlimited Rebirth | Gamepass')
UnRebirthSection:AddBox('Rebirths Ammount', 'Box', function(value)
    client.rebirth.UnRebirthValue = value
end)

UnRebirthSection:AddToggle('Auto Rebirth', 'Toggle', function(state)
    client.rebirth.AutoUnRebirth = state
    while client.rebirth.AutoUnRebirth do
        task.wait(0.2)
        local found = table.find(letters, t:match('%a+') or '') or 0
        client.rebirth.UnRebirthValue = found > 0 and t:match('%d+') .. string.rep('0', found * 3) or t:match('%d+')
        RebirthMod.requestRebirth(tonumber(client.rebirth.UnRebirthValue))
    end
end)

-- Auto Hatch Section
local HatchSection = InventoryTab:AddSection('Hatch')
local function getEggs()
    local newEggs = {unpack(require(REP.EggModule).Order)}
    for _, v in next, WRK.Eggs:GetChildren() do
        if not tostring(v):find('Robux') and not table.find(newEggs, tostring(v)) and
            not table.find(require(REP.EggModule).Order, tostring(v)) then
            table.insert(newEggs, tostring(v))
        end
    end
    return newEggs
end

HatchSection:AddDropdown('Eggs', getEggs(), function(value)
    client.inventory.egg = value.Name
end)

local Cost = HatchSection:AddDualLabel({'Cost', WRK.Eggs[client.inventory.egg].Cost.eggCostSurfaceUI.TextLabel.Text})

HatchSection:AddToggle('Auto Hatch', 'Toggle', function(state)
    client.inventory.autohatch = state
    while client.inventory.autohatch do
        task.wait(0.1)
        REP.Events.Client.purchaseEgg2:InvokeServer(WRK.Eggs[client.inventory.egg], false, false)
    end
end)

HatchSection:AddToggle('Auto Triple Hatch', 'Toggle', function(state)
    client.inventory.autotriplehatch = state
    while client.inventory.autotriplehatch do
        task.wait(0.1)
        REP.Events.Client.purchaseEgg2:InvokeServer(WRK.Eggs[client.inventory.egg], true, false)
    end
end)

HatchSection:AddButton('Unlock Luck Boost', function()
    Player.Boosts.DoubleLuck.isActive.Value = true
end)

-- Inventory Management Section
local InventoryMSection = InventoryTab:AddSection('Inventory Management')
InventoryMSection:AddToggle('Auto Craft To Shiny', 'Toggle', function(state)
    client.inventory.autoshiny = state
    while client.inventory.autoshiny do
        tWait(0.3)
        for _, v in next, Player.petOwned:GetChildren() do
            REP.Events.Client.upgradePet:FireServer(v.name.Value, 1, v)
        end
    end
end)

InventoryMSection:AddToggle('Auto Craft To Golden', 'Toggle', function(state)
    client.inventory.autogolden = state
    while client.inventory.autogolden do
        task.wait(0.3)
        for _, v in next, Player.petOwned:GetChildren() do
            REP.Events.Client.upgradePet:FireServer(v.name.Value, 2, v)
        end
    end
end)

InventoryMSection:AddToggle('Auto Equip Best', 'Toggle', function(state)
    client.inventory.autobest = state
    while client.inventory.autobest do
        task.wait()
        if Player.PlayerGui.framesUI.petsBackground.Background.background.tools.equipBest.BackgroundColor3 ==
            Color3.fromRGB(64, 125, 255) then
            REP.Events.Client.petsTools.equipBest:FireServer()
        end
    end
end)

InventoryMSection:AddToggle('Auto Mass Delete', 'Toggle', function(state)
    client.inventory.autodelete = state
    while client.inventory.autodelete do
        task.wait(0.4)
        REP.Events.Client.petsTools.deleteUnlocked:FireServer()
    end
end)

-- Character Section
local CharacterSection = LocalPlayerTab:AddSection('Character')
CharacterSection:AddSlider('WalkSpeed Value', {
    min = 1,
    max = 100,
    default = 16,
    rounded = true
}, function(value)
    Player.Character.Humanoid.WalkSpeed = value
end)

CharacterSection:AddSlider('JumpPower Value', {
    min = 1,
    max = 200,
    default = 50,
    rounded = true
}, function(value)
    Player.Character.Humanoid.JumpPower = value
end)

CharacterSection:AddToggle('Infinite Jump', 'Toggle', function(state)
    client.localplayer.infjump = state
    if client.localplayer.infjump == true then
        UIS.JumpRequest:connect(function()
            Player.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Jumping')
        end)
    end
end)

-- Refresh Function
RS.Heartbeat:Connect(function()
    Cost.Label2.Text = WRK.Eggs[client.inventory.egg].Cost.eggCostSurfaceUI.TextLabel.Text
end)
