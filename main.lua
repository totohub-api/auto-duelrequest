local HttpService = game:GetService("HttpService")
local GAS_URL = "https://script.google.com/macros/s/AKfycbyT_F8CM2VrKNElwGyddqaGBh8Z5n_choB3vTx_ASPKjiPVYH0dDmSU9sKY1NCcc6dh/exec"

local functionList = {}
local seen = {}

-- Deltaの核心的な関数群を優先的にチェック
local targets = {
    getgenv(),    -- エグゼキューター独自のグローバル
    _G,           -- 全スクリプト共有グローバル
    getfenv(0),   -- 標準Lua環境
}

for _, env in ipairs(targets) do
    for name, value in pairs(env) do
        -- 「名前が文字列」かつ「中身が関数」で、まだ登録していないもの
        if type(name) == "string" and type(value) == "function" and not seen[name] then
            -- さらに、システム内部的な "__" で始まるものは除外するとスッキリする
            if not name:match("^__") then
                table.insert(functionList, name)
                seen[name] = true
            end
        end
    end
end

table.sort(functionList)

-- 送信
local payload = HttpService:JSONEncode({ functions = functionList })
local success, response = pcall(function()
    return HttpService:PostAsync(GAS_URL, payload)
end)

print("厳選した結果、" .. #functionList .. "個になったぜ。これならGASも耐えられるはずだ。")
