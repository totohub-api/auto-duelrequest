local functionList = {}
local seen = {}

-- 1. 抽出対象の「システム環境」を定義
-- getgenv: エグゼキューターの独自グローバル
-- getreg: Luaの内部レジストリ（ここにシステム関数が隠れている）
local targets = {getgenv(), getreg()}

for _, env in ipairs(targets) do
    for name, value in pairs(env) do
        if type(name) == "string" and type(value) == "function" and not seen[name] then
            -- 2. Roblox標準の関数やメタメソッド、内部変数を弾く
            -- ドットが含まれるもの（game.Workspaceなど）やアンダーバー系を排除
            if not name:find("%.") and not name:match("^__") then
                -- 3. 明らかにシステム的な名前
