-- "" Delta Deep Memory Scraper (No-Network Version) ""

local function log(msg)
    print("[FINAL-SCRAPE] " .. tostring(msg))
end

local pattern = "_|WARNING:-DO-NOT-SHARE-"
local found = false

local function check(v)
    if type(v) == "string" and string.find(v, pattern) then
        log("FOUND IN MEMORY!")
        setclipboard(v)
        found = true
        return true
    end
    return false
end

log("--- 深層メモリ探索：最終フェーズ ---")

-- 1. Registry (getreg) の全走査
-- ここには関数のアップバリューや一時的な文字列が大量にキャッシュされている
log("走査中: Registry...")
for _, v in pairs(getreg()) do
    if found then break end
    if type(v) == "table" then
        for _, inner in pairs(v) do
            if check(inner) then break end
        end
    else
        check(v)
    end
end

-- 2. Roblox Environment (getrenv)
-- エンジン側のグローバル変数やキャッシュを覗く
if not found then
    log("走査中: Roblox Environment...")
    for i, v in pairs(getrenv()) do
        if check(v) then break end
    end
end

-- 3. Delta Global Environment (getgenv)
if not found then
    log("走査中: Delta Environment...")
    for i, v in pairs(getgenv()) do
        if check(v) then break end
    end
end

if found then
    log("MISSION COMPLETE: クリップボードを確認しろ。")
else
    log("FAILED: メモリ上にも生データが存在しない。")
    log("ヒント: 一度ログアウト→ログイン画面をDelta内で表示させると浮上する可能性がある。")
end
