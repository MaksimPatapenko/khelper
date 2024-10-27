local vkeys = require 'vkeys'
local rkeys = require 'rkeys'
rkeys.registerHotKey({ vkeys.VK_LSHIFT, rkeys.vkeys.VK_WHEELUP }, 1,
                     function()
                        sampAddChatMessage("Combo 'LShift + Mouse Wheel Up' activeted", -1)
                     end)
rkeys.registerHotKey({ vkeys.VK_LBUTTON }, 1, true,
                     function()
                        sampAddChatMessage("Combo 'iskeypressed' activeted", 0x00FF0000)
                     end)
rkeys.registerHotKey({ vkeys.VK_SHIFT, vkeys.VK_E }, 2,
                     function()
                        sampAddChatMessage("Combo 'iskeydown' activeted", -1)
                     end)
rkeys.registerHotKey({ vkeys.VK_H }, 3,
                     function()
                        local result, data = rkeys.getHotKey({vkeys.VK_LSHIFT, vkeys.VK_W})
                        if result then
                           sampAddChatMessage("I found ID: " .. tostring(data.id), -1)
                           local deleted = rkeys.unRegisterHotKey({vkeys.VK_LSHIFT, vkeys.VK_W})
                           if deleted then
                              sampAddChatMessage("LShift + W deleted", -1)
                           end
                        end
                        rkeys.registerHotKey({vkeys.VK_LSHIFT, vkeys.VK_W}, 1, true, function(data)
                           sampAddChatMessage("New combo 'iskeypressed' activeted. My ID: " .. data.id, 0xFF00FF00)
                        end)
                     end)

function rkeys.onHotKey(id, data)
   if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() then
      return false
   end
end

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
   while not isSampAvailable() do wait(0) end
   local font = renderCreateFont("Trebuc", 11, 0x4 + 0x1)
   while true do
      wait(0)
      local keys = rkeys.getKeys(true)
      renderFontDrawText(font, rkeys.getCountKeys() .." :: [" .. table.concat(keys, "] + [") .. "]", 1920 / 2 - 50, 1080 / 2, 0xFFFFFFFF)
   end
end
