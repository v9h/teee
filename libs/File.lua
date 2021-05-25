local File = {}

File.Create = function(Path)
    local PathString = ""
    local Folders = string.split(Path, "/")
    table.remove(Folders, #Folders)
    for _, Folder in ipairs(Folders) do
        if not isfolder(PathString .. Folder) then
            makefolder(PathString .. Folder)
        end
        PathString ..= Folder .. "/"
    end
    File.Write(Path, "")
    return Path
end

File.Delete = function(Path)
    if File.Exists(Path) then
        delfile(Path)
        return true
    elseif isfolder(Path) then
        delfolder(Path)
        return true
    end
    error("invalid path " .. string.format("%q", Path))
end

File.Decrypt = function(Path)
    local decrypt = syn and syn.crypt.decrypt or crypt.decrypt
    if File.Exists(Path) then
        File.Write(Path, decrypt(File.Read(Path), "ROBLOX"))
        return File.Read(Path)
    end
    error("invalid path " .. string.format("%q", Path))
end

File.Encrypt = function(Path)
    local encrypt = syn and syn.crypt.encrypt or crypt.encrypt
    if File.Exists(Path) then
        File.Write(Path, encrypt(File.Read(Path), "ROBLOX"))
        return File.Read(Path)
    end
    error("invalid path " .. string.format("%q", Path))
end

File.Exists = function(Path)
    return isfile(Path)
end

File.ListFiles = function(Path)
    if isfolder(Path) then
        return listfiles(Path)
    end
    error("invalid path " .. string.format("%q", Path))
end

File.Read = function(Path)
    if File.Exists(Path) then
        return readfile(Path)
    end
end

File.Append = function(Path, Content)
    if File.Exists(Path) then
        appendfile(Path, Content)
        return true
    end
    error("invalid path " .. string.format("%q", Path))
end

File.Write = function(Path, Content)
    writefile(Path, Content)
end

File.ReadDialog = function(Title, Filter)
    return readdialog(Title, Filter)
end

File.WriteDialog = function(Title, Filter, Data)
    return writedialog(Title, Filter, Data)
end
