local ui = loadstring(game:HttpGet('https://raw.githubusercontent.com/TrustsenseDev/Library/main/funny.lua'))()
local Window = ui:NewWindow('Andromeda Hub', 350, 400)
ui:SetColors('Legacy')

game:GetService('Players').LocalPlayer.Idled:connect(function()
    game:GetService('VirtualUser'):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService('VirtualUser'):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

local menus = {
    main = Window:NewMenu('Main'),
    inventory = Window:NewMenu('Inventory'),
    misc = Window:NewMenu('Miscellaneous')
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
            tempObj:SetText(#tempObj.Selected > 0 and table.concat(tempObj.Selected, ', ') or t.Text)
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
            tempObj:SetText('')
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
local rep = game:GetService('ReplicatedStorage')
local wrk = game:GetService('Workspace')

local client = {
    main = {
        autoclick = false,
        rebirth = '1',
        autorebirth = false,
        clickmultiplier = false,
        freeclicker = false,
        rebirthbuttons = false,
        walkspeed = false,
        gemsmultiplier = false,
        automultipet = false,
        automultistorage = false,
        autoluckmultiplier = false,
        autofasterautoclicker = false
    },
    inventory = {
        egg = 'Basic',
        autohatch = false,
        triplehatch = false
    },
    misc = {
        WalkSpeed = false,
        JumpPower = false
    }
}

toggle({
    Menu = 'main',
    Text = 'Auto Click',
    Callback = function(state)
        client.main.autoclick = state

        while client.main.autoclick do
            task.wait()
            rep.Events.Click3:FireServer()
        end
    end
})

button({
    Menu = 'main',
    Text = 'Collect All Chests',
    Callback = function()
        for _, v in next, wrk.Scripts.Chests:GetChildren() do
            rep.Events.Chest:FireServer(v)
        end
    end
})

separate({
    Menu = 'main',
    Text = 'Rebirth'
})

local function getRebirths()
    local rebirthsTable = {}
    for _, v in next, plr.PlayerGui.MainUI.RebirthFrame.Top.Holder.ScrollingFrame:GetChildren() do
        table.insert(rebirthsTable, v.Name)
        for i, v in next, rebirthsTable do
            if v == 'UIGridLayout' or v == 'TextLabel' then
                table.remove(rebirthsTable, i)
            end
        end
    end
    return rebirthsTable
end

dropdown({
    Menu = 'main',
    Text = 'Rebirths List',
    Options = getRebirths(),
    Callback = function(value)
        client.main.rebirth = value
    end
})

local RebirthInfo = label({
    Menu = 'main',
    Text = plr.PlayerGui.MainUI.RebirthFrame.Top.Holder.ScrollingFrame[client.main.rebirth].Main.Label.Text
})

toggle({
    Menu = 'main',
    Text = 'Auto Rebirth',
    Callback = function(state)
        client.main.autorebirth = state

        while client.main.autorebirth do
            task.wait()
            if plr.PlayerGui.MainUI.RebirthFrame.Top.Holder.ScrollingFrame[client.main.rebirth].Main.Use.Not.Visible ==
                false then
                rep.Events.Rebirth:FireServer(tonumber(client.main.rebirth))
            end
        end
    end
})

separate({
    Menu = 'main',
    Text = 'Upgrades'
})

toggle({
    Menu = 'main',
    Text = 'Auto Click Multiplier',
    Callback = function(state)
        client.main.clickmultiplier = state

        while client.main.clickmultiplier do
            task.wait()
            rep.Functions.Upgrade:InvokeServer('ClickMultiplier')
        end
    end
})

toggle({
    Menu = 'main',
    Text = 'Free Auto Click ',
    Callback = function(state)
        client.main.freeclicker = state

        while client.main.freeclicker do
            task.wait()
            rep.Functions.Upgrade:InvokeServer('FreeAutoClicker')
        end
    end
})

toggle({
    Menu = 'main',
    Text = 'Auto Rebirth Buttons',
    Callback = function(state)
        client.main.rebirthbuttons = state

        while client.main.rebirthbuttons do
            task.wait()
            rep.Functions.Upgrade:InvokeServer('RebirthButtons')
        end
    end
})

toggle({
    Menu = 'main',
    Text = 'Auto Walk Speed',
    Callback = function(state)
        client.main.walkspeed = state

        while client.main.walkspeed do
            task.wait()
            rep.Functions.Upgrade:InvokeServer('WalkSpeed')
        end
    end
})

toggle({
    Menu = 'main',
    Text = 'Auto Gems Multiplier',
    Callback = function(state)
        client.main.gemsmultiplier = state

        while client.main.gemsmultiplier do
            task.wait()
            rep.Functions.Upgrade:InvokeServer('GemsMultiplier')
        end
    end
})

toggle({
    Menu = 'main',
    Text = 'Auto 1+ Pet Equip',
    Callback = function(state)
        client.main.automultipet = state

        while client.main.automultipet do
            task.wait()
            rep.Functions.Upgrade:InvokeServer('PetEquip')
        end
    end
})

toggle({
    Menu = 'main',
    Text = 'Auto 5+ Pet Storage',
    Callback = function(state)
        client.main.automultistorage = state

        while client.main.automultistorage do
            task.wait()
            rep.Functions.Upgrade:InvokeServer('PetStorage')
        end
    end
})

toggle({
    Menu = 'main',
    Text = 'Auto Luck Multiplier',
    Callback = function(state)
        client.main.autoluckmultiplier = state

        while client.main.autoluckmultiplier do
            task.wait()
            rep.Functions.Upgrade:InvokeServer('LuckMultiplier')
        end
    end
})

toggle({
    Menu = 'main',
    Text = 'Auto Faster Clicker',
    Callback = function(state)
        client.main.autofasterautoclicker = state

        while client.main.autofasterautoclicker do
            task.wait()
            rep.Functions.Upgrade:InvokeServer('FasterFreeAutoClicker')
        end
    end
})

local function getEggs()
    local eggsTable = {}
    for _, v in next, wrk.Scripts.Eggs:GetChildren() do
        table.insert(eggsTable, v.Name)
    end
    return eggsTable
end

dropdown({
    Menu = 'inventory',
    Text = 'Rebirths List',
    Options = getEggs(),
    Callback = function(value)
        client.inventory.egg = value
    end
})

toggle({
    Menu = 'inventory',
    Text = 'Auto Hatch',
    Callback = function(state)
        client.inventory.autohatch = state

        while client.inventory.autohatch do
            task.wait()
            rep.Functions.Unbox:InvokeServer(client.inventory.egg, 'Single')
        end
    end
})

toggle({
    Menu = 'inventory',
    Text = 'Auto Triple Hatch',
    Callback = function(state)
        client.inventory.triplehatch = state

        while client.inventory.triplehatch do
            task.wait()
            rep.Functions.Unbox:InvokeServer(client.inventory.egg, 'Triple')
        end
    end
})

button({
    Menu = 'misc',
    Text = 'Copy Discord Server Link',
    Callback = function()
        setclipboard('https://discord.gg/rh2hXXQNZk')
    end
})

separate({
    Menu = 'misc',
    Text = 'Local Player'
})

toggle({
    Menu = 'misc',
    Text = 'WalkSpeed',
    Callback = function(state)
        client.misc.WalkSpeed = state
    end
})

slider({
    Menu = 'misc',
    Text = 'WalkSpeed',
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
    Menu = 'misc',
    Text = 'JumpPower',
    Callback = function(state)
        client.misc.JumpPower = state
    end
})

slider({
    Menu = 'misc',
    Text = 'JumpPower',
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

-- Label Refresh 
game:GetService('RunService').Heartbeat:Connect(function()
    RebirthInfo:SetText(plr.PlayerGui.MainUI.RebirthFrame.Top.Holder.ScrollingFrame[client.main.rebirth].Main.Label.Text)
end)

ui:Ready()
