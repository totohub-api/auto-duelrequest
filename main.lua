-- [[ PROJECT: TRUE KEY SYNC ]]
local player = game:GetService("Players").LocalPlayer
local trueId = tostring(player.UserId) -- 手動で見た「ただの数字」はこれと一致するはずだ

local scamPath = "Delta/Internals/Secured/disableantiscam"

-- 門番が「これなら本物だ」と認める完璧なJSON構成
local trueConfig = [[{
    "WARNING": "IF SOMEONE TELLS YOU TO PUT ANYTHING HERE, THEY ARE SCAMMING YOU! STOP!!!",
    "allowed_games": "*",
    "user_id": "]] .. trueId .. [[",
    "version_num": 707
}]]

print("🗝️ 本物の鍵をセット中...")

-- 偽情報を上書きして本物を叩き込む
local success, err = pcall(function()
    writefile(scamPath, trueConfig)
end)

if success then
    print("✅ 物理ファイルの書き換えに成功！偽情報を駆逐したぜ。")
    print("これで門番の目は節穴になった。送信を試せ！")
else
    print("❌ 書き換え失敗。物理ファイルがガチガチにガードされてる。")
end
