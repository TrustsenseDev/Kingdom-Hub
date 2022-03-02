local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/Discord0000/jeff2/main/lib"))()
local Window = ui:NewWindow("Andromeda Hub", 350, 400)
ui:SetColors("Legacy")

game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

if not isfolder("andromeda") then
    makefolder("andromeda")
end
if isfile("andromeda.txt") == false then
    (syn and syn.request or http_request)({
        Url = "http://127.0.0.1:6463/rpc?v=1",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Origin"] = "https://discord.com"
        },
        Body = game:GetService("HttpService"):JSONEncode({
            cmd = "INVITE_BROWSER",
            args = {
                code = "rh2hXXQNZk"
            },
            nonce = game:GetService("HttpService"):GenerateGUID(false)
        }),
        writefile("andromeda.txt", "discord")
    })
end

local menus = {
    main = Window:NewMenu("Main"),
    inventory = Window:NewMenu("Inventory"),
    rebirth = Window:NewMenu("Rebirth"),
    misc = Window:NewMenu("Miscellaneous")
}

local obj = {
    Sliders = {},
    Buttons = {},
    Toggles = {},
    Dropdowns = {},
    Textboxes = {},
    Sections = {},
    Labels = {}
}

-- funcs for lib
local function button(t)
    local tempObj = menus[t.Menu]:NewButton(t.Text)
    tempObj.OnClick:Connect(t.Callback)
    obj.Buttons[t.Text] = tempObj
    return tempObj
end

local function toggle(t)
    local tempObj = menus[t.Menu]:NewToggle(t.Text)
    tempObj.OnToggle:Connect(t.Callback)
    obj.Toggles[t.Text] = tempObj
    return tempObj
end

local function slider(t)
    local tempObj = menus[t.Menu]:NewSlider(t.Text, t.Min, t.Max, t.Def or t.Min)
    tempObj.OnValueChanged:Connect(t.Callback)
    obj.Sliders[t.Text] = tempObj
    return tempObj
end

local function dropdown(t)
    local tempObj = menus[t.Menu]:NewDropdown(t.Text, t.Options)
    if not t.multiOption then
        tempObj.OnSelection:Connect(t.Callback)
        obj.Dropdowns[t.Text] = tempObj
    else
        tempObj.Selected = {}
        tempObj.OnSelection:Connect(function(s)
            local found = table.find(tempObj.Selected, s)
            if found then
                table.remove(tempObj.Selected, found)
            else
                table.insert(tempObj.Selected, s)
            end
            tempObj:SetText(#tempObj.Selected > 0 and table.concat(tempObj.Selected, ", ") or t.Text)
            return t.Callback(tempObj.Selected)
        end)
        tempObj:SetText(t.Text)
        obj.Dropdowns[t.Text] = tempObj
    end
    return tempObj
end

local function textbox(t)
    local tempObj = menus[t.Menu]:NewTextbox(t.Text)
    if t.ClearOnFocus then
        tempObj.OnFocusGained:Connect(function()
            tempObj:SetText("")
        end)
    end
    tempObj.OnFocusLost:Connect(function()
        t.Callback(tempObj:GetText())
    end)
    obj.Textboxes[t.Text] = tempObj
    return tempObj
end

local function separate(t)
    local tempObj = menus[t.Menu]:NewSection(t.Text)
    obj.Sections[t.Text] = tempObj
    return tempObj
end

local function label(t)
    local tempObj = menus[t.Menu]:NewLabel(t.Text)
    obj.Labels[t.Text] = tempObj
    return tempObj
end

local plr = game.Players.LocalPlayer
local rep = game:GetService("ReplicatedStorage")
local rebirthShop = require(rep.RebirthShopModule).rebirthShop
local mod = require(rep.FunctionsModule)
local wrk = game.Workspace
local Gamepass = plr.Data.gamepasses

local client = {
    main = {
        autoclick = false,
        autospin = false,
        autobuyrebirths = false,
        autobuyjumps = false,
        autoquest = false,
        autogifts = false
    },
    inventory = {
        egg = "",
        hatch = false,
        triplehatch = false,
        autoshiny = false,
        autogolden = false,
        autobest = false,
        autodelete = false
    },
    rebirth = {
        rebirth = "",
        autorebirth = false,
        infrebirth = "",
        autoinfrebirth = false
    },
    misc = {
        selectedZone = "",
        WalkSpeed = false,
        JumpPower = false
    }
}

toggle({
    Menu = "main",
    Text = "Auto Click",
    Callback = function(state)
        client.main.autoclick = state

        while client.main.autoclick do
            task.wait()
            local env = getsenv(plr.PlayerGui.mainUI.LocalScript)
            env.activateClick()
        end
    end
})

toggle({
    Menu = "main",
    Text = "Auto Spin Wheel",
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

button({
    Menu = "main",
    Text = "Unlock x2 Clicks Boost",
    Callback = function()
        plr.Boosts.DoubleClicks.isActive.Value = true
    end
})

separate({
    Menu = "main",
    Text = "Auto Buy"
})

local function shopTable()
    local shopTable = {}
    for _, v in next, rebirthShop do
        if rawget(v, "name") then
            table.insert(shopTable, v.name)
        end
    end
    return shopTable
end

toggle({
    Menu = "main",
    Text = "Auto Buy Rebirths",
    Callback = function(state)
        client.main.autobuyrebirths = state

        while client.main.autobuyrebirths do
            task.wait(0.3)
            for _, v in next, (shopTable()) do
                rep.Events.Client.purchaseRebirthShopItem:FireServer(v)
            end
        end
    end
})

toggle({
    Menu = "main",
    Text = "Auto Buy Jumps",
    Callback = function(state)
        client.main.autobuyjumps = state

        while client.main.autobuyjumps do
            task.wait(0.2)
            for _, v in next, wrk.Clouds:GetChildren() do
                rep.Events.Client.upgrades.upgradeDoubleJump:FireServer(v.Name, 1)
            end
        end
    end
})

separate({
    Menu = "main",
    Text = "Auto Collect"
})

toggle({
    Menu = "main",
    Text = "Auto Collect Quests",
    Callback = function(state)
        client.main.autoquest = state

        while client.main.autoquest do
            task.wait()
            for i, v in next, plr.currentQuests:GetChildren() do
                if v.questCompleted.Value == true then
                    rep.Events.Client.claimQuest:FireServer(v.Name)
                end
            end
        end
    end
})

toggle({
    Menu = "main",
    Text = "Auto Collect Gifts",
    Callback = function(state)
        client.main.autogifts = state

        while client.main.autogifts do
            task.wait()
            for i, v in pairs(getconnections(plr.PlayerGui.randomGiftUI.randomGiftBackground.Background.confirm
                                                 .MouseButton1Click)) do
                v.Function()
            end
        end
    end
})

button({
    Menu = "main",
    Text = "Collect All Chests",
    Callback = function()
        for _, v in pairs(wrk.Chests:GetChildren()) do
            rep.Events.Client.claimChestReward:InvokeServer(v.Name)
        end
    end
})

local function getEggs()
    local newEggs = {unpack(require(rep.EggModule).Order)}
    for _, v in next, wrk.Eggs:GetChildren() do
        if not tostring(v):find("Robux") and not table.find(newEggs, tostring(v)) and
            not table.find(require(rep.EggModule).Order, tostring(v)) then
            table.insert(newEggs, tostring(v))
        end
    end
    return newEggs
end

dropdown({
    Menu = "inventory",
    Text = "Eggs List",
    Options = getEggs(),
    Callback = function(value)
        client.inventory.egg = value
    end
})

toggle({
    Menu = "inventory",
    Text = "Auto Hatch",
    Callback = function(state)
        client.inventory.hatch = state

        while client.inventory.hatch do
            task.wait(0.1)
            rep.Events.Client.purchaseEgg2:InvokeServer(wrk.Eggs[client.inventory.egg], false, false)
        end
    end
})

toggle({
    Menu = "inventory",
    Text = "Auto Triple Hatch",
    Callback = function(state)
        client.inventory.triplehatch = state

        while client.inventory.triplehatch do
            task.wait(0.1)
            rep.Events.Client.purchaseEgg2:InvokeServer(wrk.Eggs[client.inventory.egg], true, false)
        end
    end
})

separate({
    Menu = "inventory",
    Text = "Inventory Management"
})

toggle({
    Menu = "inventory",
    Text = "Auto Shiny",
    Callback = function(state)
        client.inventory.autoshiny = state

        while client.inventory.autoshiny do
            task.wait(0.3)
            for _, v in next, plr.petOwned:GetChildren() do
                rep.Events.Client.upgradePet:FireServer(v.name.Value, 1, v)
            end
        end
    end
})

toggle({
    Menu = "inventory",
    Text = "Auto Golden",
    Callback = function(state)
        client.inventory.autogolden = state

        while client.inventory.autogolden do
            task.wait(0.3)
            for _, v in next, plr.petOwned:GetChildren() do
                rep.Events.Client.upgradePet:FireServer(v.name.Value, 2, v)
            end
        end
    end
})

toggle({
    Menu = "inventory",
    Text = "Auto Equip Best",
    Callback = function(state)
        client.inventory.autobest = state

        while client.inventory.autobest do
            task.wait()
            if plr.PlayerGui.framesUI.petsBackground.Background.background.tools.equipBest.BackgroundColor3 ==
                Color3.fromRGB(64, 125, 255) then
                rep.Events.Client.petsTools.equipBest:FireServer()
            end
        end
    end
})

local mass = toggle({
    Menu = "inventory",
    Text = "Auto Mass Delete",
    Callback = function(state)
        client.inventory.autodelete = state

        while client.inventory.autodelete do
            task.wait(0.5)
            rep.Events.Client.petsTools.deleteUnlocked:FireServer()
        end
    end
})

mass:SetTooltip("Auto Equip Best Is Faster")

local function giveRebirths()
    local rebirthsTable = {1, 5, 10}
    for _, v in next, rebirthShop do
        if rawget(v, "rebirthOption") then
            table.insert(rebirthsTable, v.rebirthOption)
        end
    end
    return rebirthsTable
end

dropdown({
    Menu = "rebirth",
    Text = "Rebirth List",
    Options = giveRebirths(),
    Callback = function(value)
        client.rebirth.rebirth = value
    end
})

toggle({
    Menu = "rebirth",
    Text = "Auto Rebirth",
    Callback = function(state)
        client.rebirth.autorebirth = state

        while client.rebirth.autorebirth do
            task.wait()
            local calculate = mod.calculateRebirthsCost(plr.Data.Rebirths.Value, client.rebirth.rebirth)
            if calculate <= tonumber(plr.Data.Clicks.Value) then
                rep.Events.Client.requestRebirth:FireServer(tonumber(client.rebirth.rebirth), false, false)
            end
        end
    end
})

separate({
    Menu = "rebirth",
    Text = "Infinite Rebirth"
})

textbox({
    Menu = "rebirth",
    Text = "Rebirh Amount",
    Callback = function(value)
        client.rebirth.infrebirth = value
    end
})

toggle({
    Menu = "rebirth",
    Text = "Auto Infinite Rebirth",
    Callback = function(state)
        client.rebirth.autoinfrebirth = state

        while client.rebirth.autoinfrebirth do
            task.wait()
            local calculate = mod.calculateRebirthsCost(plr.Data.Rebirths.Value, client.rebirth.infrebirth)
            if calculate <= tonumber(plr.Data.Clicks.Value) then
                rep.Events.Client.requestRebirth:FireServer(tonumber(client.rebirth.infrebirth), true, false)
            end
        end
    end
})

button({
    Menu = "misc",
    Text = "Redeem All Codes",
    Callback = function()
        local codesTable = {"150KCLICKS", "125KLUCK", "100KLIKES", "75KLIKES", "50KLikes", "30klikes",
                            "20KLIKES", "freeautohatch", "175KLIKELUCK"}
        for _, v in pairs(codesTable) do
            rep.Events.Client.useTwitterCode:InvokeServer(v)
        end
    end
})

button({
    Menu = "misc",
    Text = "Unlock Auto Clicker Gamepass",
    Callback = function()
        Gamepass.Value = Gamepass.Value .. ";autoclicker;"
    end
})

button({
    Menu = "misc",
    Text = "Unlock Auto Rebirth Gamepass",
    Callback = function()
        Gamepass.Value = Gamepass.Value .. ";autorebirth;"
    end
})

button({
    Menu = "misc",
    Text = "Copy Discord Server Link",
    Callback = function()
        setclipboard("https://discord.gg/rh2hXXQNZk")
    end
})

separate({
    Menu = "misc",
    Text = "Teleport"
})

local function giveZones()
    local zonesTable = {}
    for i, v in next, wrk.Zones:GetChildren() do
        table.insert(zonesTable, v.Name)
    end
    return zonesTable
end

dropdown({
    Menu = "misc",
    Text = "Zones list",
    Options = giveZones(),
    Callback = function(value)
        client.misc.selectedZone = value
    end
})

button({
    Menu = "misc",
    Text = "Teleport",
    Callback = function()
        plr.Character.HumanoidRootPart.CFrame = CFrame.new(wrk.Zones[client.misc.selectedZone].Island.Platform.UIPart
                                                               .Position)
    end
})

separate({
    Menu = "misc",
    Text = "Local Player"
})

toggle({
    Menu = "misc",
    Text = "WalkSpeed",
    Callback = function(state)
        client.misc.WalkSpeed = state
    end
})

slider({
    Menu = "misc",
    Text = "WalkSpeed",
    Min = 0,
    Max = 500,
    Def = 16,
    Callback = function(value)
        while task.wait() do
            if client.misc.WalkSpeed == true then
                plr.Character.Humanoid.WalkSpeed = value
            else
                if client.misc.WalkSpeed == false then
                    plr.Character.Humanoid.WalkSpeed = 16
                end
            end
        end
    end
})

toggle({
    Menu = "misc",
    Text = "JumpPower",
    Callback = function(state)
        client.misc.JumpPower = state
    end
})

slider({
    Menu = "misc",
    Text = "JumpPower",
    Min = 0,
    Max = 500,
    Def = 50,
    Callback = function(value)
        while task.wait() do
            if client.misc.JumpPower == true then
                plr.Character.Humanoid.JumpPower = value
            else
                if client.misc.JumpPower == false then
                    plr.Character.Humanoid.JumpPower = 50
                end
            end
        end
    end
})

ui:Ready()
