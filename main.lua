local path_id = "Delta/Internals/Secured/user_id"
local s, real_id = pcall(function() return readfile(path_id) end)

if s then
    -- 改行や空白が入っていると失敗するので掃除する
    real_id = real_id:gsub("%s+", "")
    print("🔑 本物の鍵を取得完了: [" .. real_id .. "]")
else
    print("❌ 鍵の読み取りに失敗。手動で入れるしかない。")
end
