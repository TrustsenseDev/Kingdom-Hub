local plr = game.Players.LocalPlayer
local rep = game:GetService('ReplicatedStorage')
local rebirthShop = require(rep.RebirthShopModule).rebirthShop
local mod = require(rep.FunctionsModule)
local wrk = game.Workspace
local Gamepass = plr.Data.gamepasses
local vu = game:GetService('VirtualUser')

local client = {
    main = {
        autoclick = false,
        autospin = false,
        autobuyrebirths = false,
        autobuyjumps = false,
        autoquest = false,
        autogifts = false,
        egg = '',
        hatch = false,
        triplehatch = false,
        autoshiny = false,
        autogolden = false,
        autobest = false,
        autodelete = false,
        rebirth = '',
        autorebirth = false,
        infrebirth = '',
        autoinfrebirth = false,
        selectedZone = ''
    }
}

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

plr.Idled:connect(function()
    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)


local library = loadstring(game:GetObjects('rbxassetid://7657867786')[1].Source)()
local Wait = library.subs.Wait

local AndromedaSoftware = library:CreateWindow({
    Name = 'Kingdom Hub',
    Themeable = {
        Info = 'Discord Server: rh2hXXQNZk',
        Credit = false
    }
})

local MainTab = AndromedaSoftware:CreateTab({
    Name = 'Main'
})

-- General Section
local GeneralSection = MainTab:CreateSection({
    Name = 'General'
})

GeneralSection:AddToggle({
    Name = 'Auto Click',
    Callback = function(state)
        client.main.autoclick = state

        while client.main.autoclick do
            task.wait()
            getsenv(plr.PlayerGui.mainUI.LocalScript).activateClick()
        end
    end
})

GeneralSection:AddToggle({
    Name = 'Auto Spin Daily Wheel',
    Callback = function(state)
        client.main.autospin = state

        while client.main.autospin do
            task.wait()
            if plr.Data.freeSpinTimeLeft.Value == 0 then
                rep.Events.Client.spinWheel:InvokeServer()
            end
        end
    end
})

GeneralSection:AddButton({
    Name = 'Unlock Double Clicks',
    Callback = function()
        plr.Boosts.DoubleClicks.isActive.Value = true
    end
})

-- Shops Section
local ShopSection = MainTab:CreateSection({
    Name = 'Shop'
})

ShopSection:AddToggle({
    Name = 'Auto Buy Jumps',
    Callback = function(state)
        client.main.autobuyjumps = state

        while client.main.autobuyjumps do
            task.wait()
            for _, v in next, wrk.Clouds:GetChildren() do
                rep.Events.Client.upgrades.upgradeDoubleJump:FireServer(v.Name, 1)
            end
        end
    end
})

local function shopTable()
    local shopTable = {}
    for _, v in next, rebirthShop do
        if rawget(v, 'name') then
            table.insert(shopTable, v.name)
        end
    end
    return shopTable
end

ShopSection:AddToggle({
    Name = 'Auto Buy Rebirths',
    Callback = function(state)
        client.main.autobuyrebirths = state

        while client.main.autobuyrebirths do
            task.wait()
            for _, v in next, (shopTable()) do
                rep.Events.Client.purchaseRebirthShopItem:FireServer(v)
            end
        end
    end
})

-- Collect Section
local CollectSection = MainTab:CreateSection({
    Name = 'Collect'
})

CollectSection:AddToggle({
    Name = 'Auto Collect Gifts',
    Callback = function(state)
        client.main.autogifts = state

        while client.main.autogifts do
            task.wait()
            for _, v in pairs(getconnections(plr.PlayerGui.randomGiftUI.randomGiftBackground.Background.confirm
                                                 .MouseButton1Click)) do
                v.Function()
            end
        end
    end
})

CollectSection:AddToggle({
    Name = 'Auto Collect Achievements',
    Callback = function(state)
        client.main.autoquest = state

        while client.main.autoquest do
            task.wait()
            for _, v in next, plr.currentQuests:GetChildren() do
                if v.questCompleted.Value == true then
                    rep.Events.Client.claimQuest:FireServer(v.Name)
                end
            end
        end
    end
})

CollectSection:AddButton({
    Name = 'Collect All Chests',
    Callback = function()
        for _, v in next, wrk.Chests:GetChildren() do
            rep.Events.Client.claimChestReward:InvokeServer(v.Name)
        end
    end
})

-- Gamepasses Section
local GamepassesSection = MainTab:CreateSection({
    Name = 'Gamepasses & Codes'
})

GamepassesSection:AddButton({
    Name = 'Redeem All Codes',
    Callback = function()
        local codesTable = {'150KCLICKS', '125KLUCK', '100KLIKES', '75KLIKES', '50KLikes', '30klikes', '20KLIKES',
                            'freeautohatch', '175KLIKELUCK'}
        for _, v in pairs(codesTable) do
            rep.Events.Client.useTwitterCode:InvokeServer(v)
        end
    end
})

GamepassesSection:AddButton({
    Name = 'Unlock Auto Clicker Gamepass',
    Callback = function()
        Gamepass.Value = Gamepass.Value .. ';autoclicker;'
    end
})

GamepassesSection:AddButton({
    Name = 'Unlock Auto Rebirth Gamepass',
    Callback = function()
        Gamepass.Value = Gamepass.Value .. ';autorebirth;'
    end
})

-- Rebirth Section
local RebirthSection = MainTab:CreateSection({
    Name = 'Rebirth',
    Side = 'Right'
})

local function giveRebirths()
    local rebirthsTable = {1, 5, 10}
    for _, v in next, rebirthShop do
        if rawget(v, 'rebirthOption') then
            table.insert(rebirthsTable, v.rebirthOption)
        end
    end
    return rebirthsTable
end

RebirthSection:AddDropdown({
    Name = 'Rebirths List',
    List = giveRebirths(),
    Callback = function(value)
        client.main.rebirth = value
    end
})

RebirthSection:AddToggle({
    Name = 'Auto Rebirth',
    Callback = function(state)
        client.main.autorebirth = state

        while client.main.autorebirth do
            task.wait()
            local calculate = mod.calculateRebirthsCost(plr.Data.Rebirths.Value, client.main.rebirth)
            if calculate <= tonumber(plr.Data.Clicks.Value) then
                rep.Events.Client.requestRebirth:FireServer(tonumber(client.main.rebirth), false, false)
            end
        end
    end
})

-- Infinite Rebirth Section
local InfRebirthSection = MainTab:CreateSection({
    Name = 'Infinite Rebirth | Gamepass',
    Side = 'Right'
})

InfRebirthSection:AddTextbox({
    Name = 'Rebirths Amount',
    Callback = function(value)
        client.main.infrebirth = value
    end
})

InfRebirthSection:AddToggle({
    Name = 'Auto Infinite Rebirth',
    Callback = function(state)
        client.main.autoinfrebirth = state

        while client.main.autoinfrebirth do
            task.wait()
            local calculate = mod.calculateRebirthsCost(plr.Data.Rebirths.Value, client.main.infrebirth)
            if calculate <= tonumber(plr.Data.Clicks.Value) then
                rep.Events.Client.requestRebirth:FireServer(tonumber(client.main.infrebirth), true, false)
            end
        end
    end
})

-- Hatch Section
local PetsSection = MainTab:CreateSection({
    Name = 'Pets',
    Side = 'Right'
})

local function getEggs()
    local newEggs = {unpack(require(rep.EggModule).Order)}
    for _, v in next, wrk.Eggs:GetChildren() do
        if not tostring(v):find('Robux') and not table.find(newEggs, tostring(v)) and
            not table.find(require(rep.EggModule).Order, tostring(v)) then
            table.insert(newEggs, tostring(v))
        end
    end
    return newEggs
end

PetsSection:AddDropdown({
    Name = 'Eggs List',
    List = getEggs(),
    Callback = function(value)
        client.main.egg = value
    end
})

PetsSection:AddToggle({
    Name = 'Auto Hatch',
    Callback = function(state)
        client.main.hatch = state

        while client.main.hatch do
            task.wait(0.1)
            rep.Events.Client.purchaseEgg2:InvokeServer(wrk.Eggs[client.main.egg], false, false)
        end
    end
})

PetsSection:AddToggle({
    Name = 'Auto Triple Hatch',
    Callback = function(state)
        client.main.triplehatch = state

        while client.main.triplehatch do
            task.wait(0.1)
            rep.Events.Client.purchaseEgg2:InvokeServer(wrk.Eggs[client.main.egg], true, false)
        end
    end
})

-- Inventory Section
local InventorySection = MainTab:CreateSection({
    Name = 'Inventory Management',
    Side = 'Right'
})

InventorySection:AddToggle({
    Name = 'Auto Craft Shiny All',
    Callback = function(state)
        client.main.autoshiny = state

        while client.main.autoshiny do
            task.wait(0.1)
            for _, v in next, plr.petOwned:GetChildren() do
                rep.Events.Client.upgradePet:FireServer(v.name.Value, 1, v)
            end
        end
    end
})

InventorySection:AddToggle({
    Name = 'Auto Craft Golden All',
    Callback = function(state)
        client.main.autogolden = state

        while client.main.autogolden do
            task.wait(0.1)
            for _, v in next, plr.petOwned:GetChildren() do
                rep.Events.Client.upgradePet:FireServer(v.name.Value, 2, v)
            end
        end
    end
})

InventorySection:AddToggle({
    Name = 'Auto Equip Best',
    Callback = function(state)
        client.main.autobest = state

        while client.main.autobest do
            task.wait(0.1)
            if plr.PlayerGui.framesUI.petsBackground.Background.background.tools.equipBest.BackgroundColor3 ==
                Color3.fromRGB(64, 125, 255) then
                rep.Events.Client.petsTools.equipBest:FireServer()
            end
        end
    end
})

InventorySection:AddToggle({
    Name = 'Auto Mass Delete',
    Callback = function(state)
        client.main.autodelete = state

        while client.main.autodelete do
            task.wait(0.4)
            rep.Events.Client.petsTools.deleteUnlocked:FireServer()
        end
    end
})

-- Credits Section
local CreditsSection = MainTab:CreateSection({
    Name = 'Credits & Discord',
    Side = 'Right'
})

CreditsSection:AddLabel({
    Name = 'Script: Trustsense#8185'
})

CreditsSection:AddLabel({
    Name = 'User Interface: Pepsi#5229'
})

CreditsSection:AddLabel({
    Name = 'Help From: Discord !0000#6303'
})

CreditsSection:AddButton({
    Name = 'Join Discord Server',
    Callback = function()
        invite()
        setclipboard('https://discord.gg/WFS3gYURAk')
    end
})

-- Teleport Section
local TeleportSection = MainTab:CreateSection({
    Name = 'Teleport'
})

local function giveZones()
    local zonesTable = {}
    for i, v in next, wrk.Zones:GetChildren() do
        table.insert(zonesTable, v.Name)
    end
    return zonesTable
end

TeleportSection:AddDropdown({
    Name = 'Zones List',
    List = giveZones(),
    Callback = function(value)
        client.main.selectedZone = value
    end
})

-- Movement Changer
local MovementSection = MainTab:CreateSection({
    Name = 'Movement'
})

MovementSection:AddSlider({
    Name = "WalkSpeed",
    Value = 16,
    Precise = 2,
    Min = 0,
    Max = 100,
    Callback = function(value)
        plr.Character.Humanoid.WalkSpeed = value
    end
})

MovementSection:AddSlider({
    Name = "JumpPower",
    Value = 50,
    Precise = 2,
    Min = 0,
    Max = 200,
    Callback = function(value)
        plr.Character.Humanoid.JumpPower = value
    end
})