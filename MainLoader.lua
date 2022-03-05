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

local SelectedGame

local discord = "https://discord.gg/mwTwNTbGws"
local checker = pcall(function()
    SelectedGame =
        game:HttpGet("https://raw.githubusercontent.com/TrustsenseDev/Kingdom-Hub/main/Game%20Supported/" .. game.PlaceId .. ".lua")
end)

if checker == true then
    loadstring(SelectedGame)()
else
    game.Players.LocalPlayer:Kick("Not Supported | Discord Link Copied To Clipboard " .. discord)
    invite()
    setclipboard(discord)
end
