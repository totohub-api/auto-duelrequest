-- これを単体で実行して、コンソールに何が出るか見てくれ
local success, result = pcall(function()
    -- 認証が必要なURLを、あえて「生」のHttpGetで叩く
    return game:HttpGet("https://www.roblox.com/mobileapi/userinfo")
end)

if success then
    print("APIレスポンス取得成功: " .. result:sub(1, 50))
else
    print("APIアクセス失敗: " .. tostring(result))
end
