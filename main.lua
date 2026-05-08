local functionList = {}
local seen = {}

local targets = {getgenv(), getfenv(0)}
for _, env in ipairs(targets) do
    for name, value in pairs(env) do
        if type(name) == "string" and type(value) == "function" and not seen[name] then
            if not name:find("%.") and not name:match("^__") then
                table.insert(functionList, name)
                seen[name] = true
            end
        end
    end
end
table.sort(functionList)

-- 全関数を改行区切りの一つの文字列にする
local finalString = table.concat(functionList, "\n")

-- Deltaのコピー関数を実行
local success, err = pcall(function()
    setclipboard(finalString)
end)

if success then
    print("【完全勝利】 " .. #functionList .. " 個の関数をクリップボードにコピーしたぜ！")
    print("あとはメモ帳やGASに直接ペーストするだけだ。")
else
    warn("コピー失敗: " .. tostring(err))
end
