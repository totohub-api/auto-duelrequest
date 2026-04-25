local path = "Delta/Internals/Secured/"
pcall(function()
    for i, v in pairs(listfiles(path)) do
        print("見えているファイル: " .. v)
    end
end)
