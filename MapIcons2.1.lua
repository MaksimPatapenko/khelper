local icons = {
    markers = 0,
    cords = {}
}
local mymark = {}
local active = true
local selected = nil
local configDir = getWorkingDirectory().."\\config\\MapIcons.json"
jsoncfg = {
    save = function(data, path)
        if doesFileExist(path) then os.remove(path) end
        if type(data) ~= 'table' then return end
        local f = io.open(path, 'a+')
        local writing_data = encodeJson(data)
        f:write(writing_data)
        f:close()
    end,
    load = function(path)
        if doesFileExist(path) then
          local f = io.open(path, 'a+')
          local data = decodeJson(f:read('*a'))
          f:close()
          return data
        end
    end
}
if not doesDirectoryExist(getWorkingDirectory().."\\config") then createDirectory(getWorkingDirectory().."\\config") end
if not doesFileExist(configDir) then jsoncfg.save(icons, configDir) else icons = jsoncfg.load(configDir) end
function main()
    if not isSampLoaded() and not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand('msave', msave)
    sampRegisterChatCommand('mdelete', mdelete)
    sampRegisterChatCommand('mnear', mnear)
    sampRegisterChatCommand('mlist', mlist)
    sampAddChatMessage("MapIcons {FFFFFF}by CaJlaT {00ff00}[Loaded]", 0x00fc76)
    LoadMarkers()
    while true do
        wait(0)
        local px, py, pz = getCharCoordinates(playerPed)
        if checkpoint ~= nil then
            if math.floor(getDistanceBetweenCoords3d(cx, cy, cz, px, py, pz)) <= 7 then deleteCheckpoint(checkpoint) addOneOffSound(0, 0, 0, 1057) checkpoint = nil end
        end
        for k, v in pairs(icons.cords) do
            if v.time ~= nil then
                local time = v.time - os.time()
                if time <= 0 then
                    sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: Icon {FF0000}'..v.name..'{FFFFFF} deleted {FF0000}(time out){FFFFFF}!', -1)
                    table.remove(icons.cords, k)
                    jsoncfg.save(icons, configDir)
                    ReloadMarkers()
                end
            end
        end
    end
end
function msave(arg)
    if #arg == 0 then
        if getTargetBlipCoordinatesFixed() then
            local _, mpX, mpY, mpZ = getTargetBlipCoordinatesFixed()
            icons.markers = icons.markers + 1
            sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: New icon name: {FF0000}New icon{FFFFFF}, time: {FF0000}None', -1)
            table.insert(icons.cords, { X = mpX, Y = mpY, Z = mpZ, name = 'New icon', state = true, icon = 56 })
            mymark[#mymark+1] = addSpriteBlipForCoord(mpX, mpY, mpZ, 56)
            jsoncfg.save(icons, configDir)
            addOneOffSound(0, 0, 0, 1057)
        else
        	local mpX, mpY, mpZ = getCharCoordinates(PLAYER_PED)
            icons.markers = icons.markers + 1
            sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: New icon name: {FF0000}New icon{FFFFFF}, time: {FF0000}None', -1)
            table.insert(icons.cords, { X = mpX, Y = mpY, Z = mpZ, name = 'New icon', state = true, icon = 56 })
            mymark[#mymark+1] = addSpriteBlipForCoord(mpX, mpY, mpZ, 56)
            jsoncfg.save(icons, configDir)
            addOneOffSound(0, 0, 0, 1057)
        end
    else
        if getTargetBlipCoordinatesFixed() then
            local _, mpX, mpY, mpZ = getTargetBlipCoordinatesFixed()
            icons.markers = icons.markers + 1
            if arg:find('(.+) (.+)') then
                local arg1, arg2 = arg:match('(.+) (.+)')
                if arg2:find('%*') then minutes = tonumber(arg2:match('(.+)%*'))*tonumber(arg2:match('%*(.+)')) else minutes = tonumber(arg2) end
                if tonumber(minutes) ~= nil then 
                    sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: New icon name: {FF0000}'..arg1..'{FFFFFF}, time: {FF0000}'..minutes..' {FFFFFF}minutes.', -1)
                    table.insert(icons.cords, { X = mpX, Y = mpY, Z = mpZ, time = os.time() + minutes*60, name = arg1, state = true, icon = 56 })
                else
                    sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: New icon name: {FF0000}'..arg..'{FFFFFF}, time: {FF0000}None', -1)
                    table.insert(icons.cords, { X = mpX, Y = mpY, Z = mpZ, name = arg, state = true, icon = 56 })
                end
            else
                sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: New icon name: {FF0000}'..arg..'{FFFFFF}, time: {FF0000}None', -1)
                table.insert(icons.cords, { X = mpX, Y = mpY, Z = mpZ, name = arg, state = true, icon = 56 })
            end
            mymark[#mymark+1] = addSpriteBlipForCoord(mpX, mpY, mpZ, 56)
            jsoncfg.save(icons, configDir)
            addOneOffSound(0, 0, 0, 1057)
        else
            local mpX, mpY, mpZ = getCharCoordinates(PLAYER_PED)
            icons.markers = icons.markers + 1
            if arg:find('(.+) (.+)') then
                local arg1, arg2 = arg:match('(.+) (.+)')
                if arg2:find('%*') then minutes = tonumber(arg2:match('(.+)%*'))*tonumber(arg2:match('%*(.+)')) else minutes = tonumber(arg2) end
                if tonumber(minutes) ~= nil then 
                    sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: New icon name: {FF0000}'..arg1..'{FFFFFF}, time: {FF0000}'..minutes..' {FFFFFF}minutes.', -1)
                    table.insert(icons.cords, { X = mpX, Y = mpY, Z = mpZ, time = os.time() + minutes*60, name = arg1, state = true, icon = 56 })
                else
                    sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: New icon name: {FF0000}'..arg..'{FFFFFF}, time: {FF0000}None', -1)
                    table.insert(icons.cords, { X = mpX, Y = mpY, Z = mpZ, name = arg, state = true, icon = 56 })
                end
            else
                sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: New icon name: {FF0000}'..arg..'{FFFFFF}, time: {FF0000}None', -1)
                table.insert(icons.cords, { X = mpX, Y = mpY, Z = mpZ, name = arg, state = true, icon = 56 })
            end
            mymark[#mymark+1] = addSpriteBlipForCoord(mpX, mpY, mpZ, 56)
            jsoncfg.save(icons, configDir)
            addOneOffSound(0, 0, 0, 1057)
        end
    end
end
function mdelete(arg)
    if #arg == 0 then
        if icons.markers <= 0 then sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: No one markers found') return end
        for k, v in pairs(icons.cords) do
            name = v.name
        end
        table.remove(icons.cords)
        icons.markers = icons.markers - 1
        jsoncfg.save(icons, configDir)
        ReloadMarkers()
        sampAddChatMessage("[{00fc76}MapIcons{FFFFFF}]: Icon {FF0000}"..name..'{FFFFFF} deleted!', -1)
    else
        local name = nil
        local index = 0
        local i = 0
        for k, v in pairs(icons.cords) do
            i = i + 1
            if v.name == arg then name = v.name index = i end
        end
        if name == nil then sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: Icon {FF0000}'..arg..' {FFFFFF}not found!', -1) return end
        table.remove(icons.cords, index)
        print(index)
        icons.markers = icons.markers - 1
        jsoncfg.save(icons, configDir)
        ReloadMarkers()
        sampAddChatMessage("[{00fc76}MapIcons{FFFFFF}]: Icon {FF0000}"..name..'{FFFFFF} deleted!', -1)
    end
end
function mnear()
    name, dist, cx, cy, cz = GetNearestCoord(icons.cords)
    if checkpoint ~= nil then deleteCheckpoint(checkpoint) end
    checkpoint = createCheckpoint(1, cx, cy, cz, _, _, _, 7)
    sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: Nearest icon: {FF0000}'..name..'{FFFFFF}, distance: {FF0000}'..dist..'{FFFFFF}.', -1)
end
function mselect(arg)
    if checkpoint ~= nil then deleteCheckpoint(checkpoint) end
    cx, cy, cz = icons.cords[arg].X, icons.cords[arg].Y, icons.cords[arg].Z
    checkpoint = createCheckpoint(1, cx, cy, cz, _, _, _, 7)
    sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: Icon {FF0000}'..icons.cords[arg].name..' {FFFFFF}selected!', -1)
end
function mlist()
    local dtext = active and 'Name\tDistance\tTime\tStatus\n{FFFFFF}All icons {00FF00}On' or 'Name\tDistance\tTime\tStatus\n{FFFFFF}All icons {AFAFAF}Off'
    if checkpoint ~= nil then dtext = dtext..'\t \t{FF0000}Remove checkpoint' end
    local x, y, z = getCharCoordinates(playerPed)
    for k, v in pairs(icons.cords) do
        if v.time ~= nil then 
            local time = v.time - os.time()
            local min, sec = math.floor(time / 60), time % 60
            print(time)
            dtext = dtext..'\n{00fc76}'..v.name..'\t{FF0000}'..math.floor(getDistanceBetweenCoords3d(v.X, v.Y, v.Z, x, y, z))..'\t{FF0000}'..min..':'..sec..'\t'..(v.state and '{00FF00}Showed' or '{AFAFAF}Hided')
        else
            dtext = dtext..'\n{00fc76}'..v.name..'\t{FF0000}'..math.floor(getDistanceBetweenCoords3d(v.X, v.Y, v.Z, x, y, z))..'\t \t'..(v.state and '{00FF00}Showed' or '{AFAFAF}Hided')
        end
    end
    sampShowDialog(28246, "[{00fc76}MapIcons{FFFFFF}]: Icons list:", dtext, "Ok", "Close", 5)
    lua_thread.create(dialog_mlist)
end
function dialog_mlist()
    while sampIsDialogActive() do
        wait(0)
        if sampGetCurrentDialogId() ~= 28246 then break end
        local result, button, list, input = sampHasDialogRespond(28246)
        if result then
            if button == 1 then
                if list == 0 then 
                    active = not active 
                    if active then ReloadMarkers() else RemoveMarkers() end
                    if checkpoint ~= nil then deleteCheckpoint(checkpoint) checkpoint = nil end
                    mlist()
                else
                    selected = list
                    if icons.cords[selected].time ~= nil then
                        local time = icons.cords[selected].time - os.time()
                        min, sec = math.floor(time / 60), time % 60
                        sampShowDialog(28247, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FFFFFF}Back\t \n'..(icons.cords[selected].state and '{00FF00}Show' or '{AFAFAF}Hide')..'\n{FFFFFF}Set {FF0000}checkpoint\n{FFFFFF}Change {FF0000}name\t{00fc76}'..icons.cords[selected].name..'\n{FFFFFF}Change {FF0000}icon texture\t{FF0000}'..icons.cords[selected].icon..'\n{FFFFFF}Change {FF0000}time\t{FF0000}'..min..':'..sec..'\n{FF0000}Delete icon', 'Ok', 'Close', 4)
                    else
                        sampShowDialog(28247, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FFFFFF}Back\t \n'..(icons.cords[selected].state and '{00FF00}Show' or '{AFAFAF}Hide')..'\n{FFFFFF}Set {FF0000}checkpoint\n{FFFFFF}Change {FF0000}name\t{00fc76}'..icons.cords[selected].name..'\n{FFFFFF}Change {FF0000}icon texture\t{FF0000}'..icons.cords[selected].icon..'\n{FFFFFF}Change {FF0000}time\n{FF0000}Delete icon', 'Ok', 'Close', 4)
                    end
                    min, sec = nil
                    lua_thread.create(dialog_icon)
                end
            end
        end
    end
end
function dialog_icon()
    while sampIsDialogActive() do
        wait(0)
        if sampGetCurrentDialogId() ~= 28247 then break end
        local result, button, list, input = sampHasDialogRespond(28247)
        if result then
            if button == 1 then
                if list == 0 then 
                    mlist()
                elseif list == 1 then
                    icons.cords[selected].state = not icons.cords[selected].state
                    jsoncfg.save(icons, configDir)
                    if icons.cords[selected].time ~= nil then
                        local time = icons.cords[selected].time - os.time()
                        min, sec = math.floor(time / 60), time % 60
                        sampShowDialog(28247, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FFFFFF}Back\t \n'..(icons.cords[selected].state and '{00FF00}Show' or '{AFAFAF}Hide')..'\n{FFFFFF}Set {FF0000}checkpoint\n{FFFFFF}Change {FF0000}name\t{00fc76}'..icons.cords[selected].name..'\n{FFFFFF}Change {FF0000}icon texture\t{FF0000}'..icons.cords[selected].icon..'\n{FFFFFF}Change {FF0000}time\t{FF0000}'..min..':'..sec..'\n{FF0000}Delete icon', 'Ok', 'Close', 4)
                    else
                        sampShowDialog(28247, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FFFFFF}Back\t \n'..(icons.cords[selected].state and '{00FF00}Show' or '{AFAFAF}Hide')..'\n{FFFFFF}Set {FF0000}checkpoint\n{FFFFFF}Change {FF0000}name\t{00fc76}'..icons.cords[selected].name..'\n{FFFFFF}Change {FF0000}icon texture\t{FF0000}'..icons.cords[selected].icon..'\n{FFFFFF}Change {FF0000}time\n{FF0000}Delete icon', 'Ok', 'Close', 4)
                    end
                    min, sec = nil
                    ReloadMarkers()
                    lua_thread.create(dialog_icon)
                    break
                elseif list == 2 then
                    mselect(selected)
                elseif list == 3 then
                    sampShowDialog(28248, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FFFFFF}Enter a {FF0000}new {FFFFFF}name:', 'Ok', 'Close', 1)
                    lua_thread.create(dialog_rename)
                elseif list == 4 then
                    sampShowDialog(28249, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FFFFFF}Enter a {FF0000}new {FFFFFF}texture number:', 'Ok', 'Close', 1)
                    lua_thread.create(dialog_retexture)
                elseif list == 5 then
                    sampShowDialog(28250, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FFFFFF}To specify the hour, enter {FF0000}1*60\n{FFFFFF}Enter the {FF0000}time (in minutes):', 'Изменить', 'Отмена', 1)
                    lua_thread.create(dialog_time)
                elseif list == 6 then
                    table.remove(icons.cords, selected)
                    jsoncfg.save(icons, configDir)
                    mlist()
                    ReloadMarkers()
                end
            end
        end
    end
end
function dialog_rename()
    while sampIsDialogActive() do
        wait(0)
        if sampGetCurrentDialogId() ~= 28248 then break end
        local result, button, list, input = sampHasDialogRespond(28248)
        if result then
            if button == 1 then
                if #input == 0 or input == nil then
                    sampShowDialog(28248, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FF0000}Error, you did not enter a name\n{FFFFFF}Enter a {FF0000}new {FFFFFF}name:', 'Изменить', 'Отмена', 1)
                    lua_thread.create(dialog_rename)
                    break
                else
                    sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: New name: {00FF00}'..input..'{FFFFFF}, last name: {FF0000}'..icons.cords[selected].name, -1)
                    icons.cords[selected].name = input
                    jsoncfg.save(icons, configDir)
                    if icons.cords[selected].time ~= nil then
                        local time = icons.cords[selected].time - os.time()
                        min, sec = math.floor(time / 60), time % 60
                        sampShowDialog(28247, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FFFFFF}Back\t \n'..(icons.cords[selected].state and '{00FF00}Show' or '{AFAFAF}Hide')..'\n{FFFFFF}Set {FF0000}checkpoint\n{FFFFFF}Change {FF0000}name\t{00fc76}'..icons.cords[selected].name..'\n{FFFFFF}Change {FF0000}icon texture\t{FF0000}'..icons.cords[selected].icon..'\n{FFFFFF}Change {FF0000}time\t{FF0000}'..min..':'..sec..'\n{FF0000}Delete icon', 'Ok', 'Close', 4)
                    else
                        sampShowDialog(28247, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FFFFFF}Back\t \n'..(icons.cords[selected].state and '{00FF00}Show' or '{AFAFAF}Hide')..'\n{FFFFFF}Set {FF0000}checkpoint\n{FFFFFF}Change {FF0000}name\t{00fc76}'..icons.cords[selected].name..'\n{FFFFFF}Change {FF0000}icon texture\t{FF0000}'..icons.cords[selected].icon..'\n{FFFFFF}Change {FF0000}time\n{FF0000}Delete icon', 'Ok', 'Close', 4)
                    end
                    min, sec = nil
                    lua_thread.create(dialog_icon)
                end
            end
        end
    end
end
function dialog_retexture()
    while sampIsDialogActive() do
        wait(0)
        if sampGetCurrentDialogId() ~= 28249 then break end
        local result, button, list, input = sampHasDialogRespond(28249)
        if result then
            if button == 1 then
                if #input == 0 or tonumber(input) == nil then
                    sampShowDialog(28249, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FF0000}Error, you did not enter a texture number\n{FFFFFF}Enter a {FF0000}new {FFFFFF}texture number:', 'Изменить', 'Отмена', 1)
                    lua_thread.create(dialog_retexture)
                    break
                else
                    sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: New texture number: {00FF00}'..input..'{FFFFFF}, last texture number: {FF0000}'..icons.cords[selected].icon, -1)
                    icons.cords[selected].icon = tonumber(input)
                    jsoncfg.save(icons, configDir)
                    if icons.cords[selected].time ~= nil then
                        local time = icons.cords[selected].time - os.time()
                        min, sec = math.floor(time / 60), time % 60
                        sampShowDialog(28247, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FFFFFF}Back\t \n'..(icons.cords[selected].state and '{00FF00}Show' or '{AFAFAF}Hide')..'\n{FFFFFF}Set {FF0000}checkpoint\n{FFFFFF}Change {FF0000}name\t{00fc76}'..icons.cords[selected].name..'\n{FFFFFF}Change {FF0000}icon texture\t{FF0000}'..icons.cords[selected].icon..'\n{FFFFFF}Change {FF0000}time\t{FF0000}'..min..':'..sec..'\n{FF0000}Delete icon', 'Ok', 'Close', 4)
                    else
                        sampShowDialog(28247, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FFFFFF}Back\t \n'..(icons.cords[selected].state and '{00FF00}Show' or '{AFAFAF}Hide')..'\n{FFFFFF}Set {FF0000}checkpoint\n{FFFFFF}Change {FF0000}name\t{00fc76}'..icons.cords[selected].name..'\n{FFFFFF}Change {FF0000}icon texture\t{FF0000}'..icons.cords[selected].icon..'\n{FFFFFF}Change {FF0000}time\n{FF0000}Delete icon', 'Ok', 'Close', 4)
                    end
                    min, sec = nil
                    lua_thread.create(dialog_icon)
                    ReloadMarkers()
                end
            end
        end
    end
end
function dialog_time()
    while sampIsDialogActive() do
        wait(0)
        if sampGetCurrentDialogId() ~= 28250 then break end
        local result, button, list, input = sampHasDialogRespond(28250)
        if result then
            if button == 1 then
                if #input == 0 or tonumber(input) == nil and not input:find('%*') then
                    sampShowDialog(28250, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FF0000}Error, you did not enter the minutes\n{FFFFFF}To specify the hour, enter {FF0000}1*60\n{FFFFFF}Enter the {FF0000}time (in minutes):', 'Изменить', 'Отмена', 1)
                    lua_thread.create(dialog_time)
                    break
                else
                    if input:find('%*') then input = tonumber(input:match('(.+)%*'))*tonumber(input:match('%*(.+)')) else input = tonumber(input) end
                    if icons.cords[selected].time ~= nil then
                        local lasttime = icons.cords[selected].time - os.time()
                        lastmin, lastsec = math.floor(lasttime / 60), lasttime % 60
                        icons.cords[selected].time = tonumber(input)*60+os.time()
                        jsoncfg.save(icons, configDir)
                        local time = icons.cords[selected].time - os.time()
                        min, sec = math.floor(time / 60), time % 60
                        sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: New time: {00FF00}'..min..':'..sec..'{FFFFFF}, last time: {FF0000}'..lastmin..':'..lastsec, -1)
                    else
                        icons.cords[selected].time = tonumber(input)*60+os.time()
                        jsoncfg.save(icons, configDir)
                        local time = icons.cords[selected].time - os.time()
                        min, sec = math.floor(time / 60), time % 60
                        sampAddChatMessage('[{00fc76}MapIcons{FFFFFF}]: New time: {00FF00}'..min..':'..sec..'{FFFFFF}, last time: {FF0000}None', -1)
                    end
                    if icons.cords[selected].time ~= nil then
                        local time = icons.cords[selected].time - os.time()
                        min, sec = math.floor(time / 60), time % 60
                        sampShowDialog(28247, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FFFFFF}Back\t \n'..(icons.cords[selected].state and '{00FF00}Show' or '{AFAFAF}Hide')..'\n{FFFFFF}Set {FF0000}checkpoint\n{FFFFFF}Change {FF0000}name\t{00fc76}'..icons.cords[selected].name..'\n{FFFFFF}Change {FF0000}icon texture\t{FF0000}'..icons.cords[selected].icon..'\n{FFFFFF}Change {FF0000}time\t{FF0000}'..min..':'..sec..'\n{FF0000}Delete icon', 'Ok', 'Close', 4)
                    else
                        sampShowDialog(28247, '[{00fc76}MapIcons{FFFFFF}]: {00fc76}'..icons.cords[selected].name, '{FFFFFF}Back\t \n'..(icons.cords[selected].state and '{00FF00}Show' or '{AFAFAF}Hide')..'\n{FFFFFF}Set {FF0000}checkpoint\n{FFFFFF}Change {FF0000}name\t{00fc76}'..icons.cords[selected].name..'\n{FFFFFF}Change {FF0000}icon texture\t{FF0000}'..icons.cords[selected].icon..'\n{FFFFFF}Change {FF0000}time\n{FF0000}Delete icon', 'Ok', 'Close', 4)
                    end
                    min, sec = nil
                    lua_thread.create(dialog_icon)
                    ReloadMarkers()
                end
            end
        end
    end
end
function getTargetBlipCoordinatesFixed()
    local bool, x, y, z = getTargetBlipCoordinates(); if not bool then return false end
    requestCollision(x, y); loadScene(x, y, z)
    local bool, x, y, z = getTargetBlipCoordinates()
    return bool, x, y, z
end
function GetNearestCoord(Array)
    local x, y, z = getCharCoordinates(playerPed)
    local distance = {}
    for k, v in pairs(Array) do
        if type(v) ~= 'userdata' then distance[#distance+1] = {distance = math.floor(getDistanceBetweenCoords3d(v.X, v.Y, v.Z, x, y, z)), name = v.name, x = v.X, y = v.Y, z = v.Z} end
    end
    table.sort(distance, function(a, b) return a.distance < b.distance end)
    for k, v in pairs(distance) do
        CoordName, CoordDist, X, Y, Z = v.name, v.distance, v.x, v.y, v.z
        break
    end
    return CoordName, CoordDist, X, Y, Z
end
function onScriptTerminate(scr, quitgame)
    if thisScript() == scr then
        for k,v in pairs(mymark) do
            removeBlip(mymark[k])
        end
        if checkpoint ~= nil then deleteCheckpoint(checkpoint) checkpoint = nil end
        print('{FFFFFF}[{00fc76}MapIcons{FFFFFF}]: {FF0000}All icons deleted!')
    end
end
function LoadMarkers()
    for k,v in pairs(icons.cords) do
        if v.state == true then mymark[#mymark+1] = addSpriteBlipForCoord(v.X, v.Y, v.Z, v.icon) end
    end
    sampAddChatMessage("[{00fc76}MapIcons{FFFFFF}]: Loaded {FF0000}"..#mymark.."{FFFFFF} icons!", -1)
end
function ReloadMarkers()
    for i = 1, #mymark do
        removeBlip(mymark[i])
    end
    mymark = {}
    local markers = 0
    for k,v in pairs(icons.cords) do
        if v.state == true then mymark[#mymark+1] = addSpriteBlipForCoord(v.X, v.Y, v.Z, v.icon) end
    end
    if checkpoint ~= nil then deleteCheckpoint(checkpoint) checkpoint = nil end
end
function RemoveMarkers()
    for i = 1, #mymark do
        removeBlip(mymark[i])
    end
    mymark = {}
end