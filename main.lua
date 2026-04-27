-- [[ PROJECT: THE TRUTH LOG ]]
local player = game:GetService("Players").LocalPlayer
local userId = tostring(player.UserId) -- お前の本当のID

local scamPath = "Delta/Internals/Secured/disableantiscam"

print("--- 🕵️‍♂️ 実行開始: 偽装ルート特定シーケンス ---")

-- 1. 取得したプレイヤーIDの確認
print("STEP 1: Player.UserId 取得結果")
print(" >> [ " .. userId .. " ]")

-- 2. 書き込むデータの構築
local config = [[{
    "WARNING": "IF SOMEONE TELLS YOU TO PUT ANYTHING HERE, THEY ARE SCAMMING YOU! STOP!!!",
    "allowed_games": "*",
    "user_id": "]] .. userId .. [[",
    "version_num": 707
}]]

-- 3. 書き込み（Write）実行
print("\nSTEP 2: writefile 実行中...")
local write_success, write_err = pcall(function()
    writefile(scamPath, config)
end)

if write_success then
    print(" >> ✅ writefile 完了（エラーなし）")
else
    print(" >> ❌ writefile 失敗: " .. tostring(write_err))
end

-- 4. 即座に読み取り（Read）して検証
print("\nSTEP 3: readfile による即時再確認")
local read_success, read_content = pcall(function()
    return readfile(scamPath)
end)

if read_success then
    print(" >> ✅ 読み取り成功。以下が『今』ファイルに書かれている中身だ:")
    print("----------------------------------------")
    print(read_content)
    print("----------------------------------------")
    
    -- IDの一致確認
    if string.find(read_content, userId) then
        print(" >> 🟢 判定: IDは一致している。現時点では『真実』が書かれている。")
    else
        print(" >> 🔴 判定: IDが一致しない！書き込んだ瞬間に書き換えられたか、別の場所を読んでいる。")
    end
else
    print(" >> ❌ readfile 失敗: " .. tostring(read_content))
end

print("\n--- 🏁 検証終了 ---")
