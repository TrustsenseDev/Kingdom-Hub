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

local discordinv = "https://discord.gg/mwTwNTbGws"
local d
local f = pcall(function()
    d =
        game:HttpGet("https://raw.githubusercontent.com/TrustsenseDev/Andromeda-Hub/main/Game%20Supported/" .. game.PlaceId .. ".lua")
end)

if f == true then
    loadstring(d)()
else
    game.Players.LocalPlayer:Kick("Not Supported | Discord Link Copied To Clipboard " .. discordinv)
    invite()
    setclipboard(discordinv)
end
