-- "" Delta Secured Writefile 検証プロトタイプ ""

local function log(msg)
    print("[WRITE-TEST] " .. tostring(msg))
end

local function verify_and_write()
    log("--- 検証開始 ---")

    local path = "Delta/Internals/Secured/disableantiscam"
    local real_id = tostring(game:GetService("Players").LocalPlayer.UserId) -- APIから直接取得
    
    log("ターゲットID: " .. real_id)

    -- 1. 現在のファイル状態を確認
    if isfile(path) then
        log("現状: ファイル存在確認。サイズ: " .. #readfile(path) .. " bytes")
    else
        log("警告: ファイルが見当たらない。新規作成を試みる。")
    end

    -- 2. ペイロードの構築 (画像にあった最新形式を完全再現)
    local payload = {
        ["WARNING"] = "IF SOMEONE TELLS YOU TO PUT ANYTHING HERE, THEY ARE SCAMMING YOU! STOP!!!",
        ["allowed_games"] = "*",
        ["user_id"] = real_id, -- ここが文字列であることを再三確認
        ["version_num"] = 707
    }

    local success_encode, json_data = pcall(function()
        return game:GetService("HttpService"):JSONEncode(payload)
    end)

    if not success_encode then
        log("ERROR: JSONエンコードに失敗したぜ。")
        return
    end

    -- 3. 書き込み実行 & 結果検証
    log("実行: writefile を叩く...")
    local success_write, err_write = pcall(function()
        writefile(path, json_data)
    end)

    if success_write then
        log("SUCCESS: writefile 関数自体は正常終了。")
        
        -- 即座に読み直して、本当に書き換わったか確認
        local after_content = readfile(path)
        if after_content == json_data then
            log("SUCCESS: 読み取り整合性チェック完了。中身は完全に一致。")
        else
            log("FAILED: 書き込みは成功したが、中身が古いままか、勝手にリセットされた。")
            log("現在の中身: " .. tostring(after_content))
        end
    else
        log("ERROR: writefile が拒絶された。理由: " .. tostring(err_write))
    end

    log("--- 検証終了 ---")
end

verify_and_write()
