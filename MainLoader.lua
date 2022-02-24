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
    setclipboard(discordinv)
end
