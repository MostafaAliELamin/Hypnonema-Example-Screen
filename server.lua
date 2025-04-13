
local currentPlaying = {}

RegisterNetEvent("discordPlayVideo")
AddEventHandler("discordPlayVideo", function(data)
    local screen = data.screen
    local url = data.url
    local user = data.user

    if currentPlaying[screen] and GetGameTimer() < currentPlaying[screen] then
        print("❌ الشاشة مشغولة حالياً بفيديو آخر.")
        return
    end

    -- تشغيل الفيديو عبر hypnonema
    TriggerClientEvent("hypnonema:playVideo", -1, {
        url = url,
        screenName = screen,
        volume = 0.5,
        isLooping = false
    })

    -- تقدير وقت نهاية الفيديو (مثلاً 5 دقائق)
    currentPlaying[screen] = GetGameTimer() + (5 * 60000)

    -- إرسال لوج للديسكورد
    local logMessage = string.format("🎬 **%s** شغّل فيديو على **%s**\n🔗 الرابط: %s\n🕒 %s", user, screen, url, os.date("%Y-%m-%d %H:%M:%S"))
    sendToDiscordLog(logMessage)
end)

function sendToDiscordLog(msg)
    local webhook = "https://discord.com/api/webhooks/1360744238408798368/E1UyiEesMeDfSd5fyPmZKzGW0h27U706MOwlPSbOchhX1ULIkv54_v4MPjKHIMGkPOLY"
    PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({
        username = "Video Logger",
        embeds = {{
            description = msg,
            color = 65280
        }}
    }), { ["Content-Type"] = "application/json" })
end
