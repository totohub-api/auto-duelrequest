local path = "Internals/Secured/disableantiscam"
local testData = '{"test": "ok"}'

local success, err = pcall(function()
    writefile(path, testData)
end)

if success then
    print("✅ 書き換え成功！Deltaのガードはザルだぜｗ")
else
    -- もしここで「Permission Denied」とか出たら、スクリプトからは無理。
    print("❌ 書き換え失敗。Deltaがこのフォルダを守ってるな： " .. tostring(err))
end
