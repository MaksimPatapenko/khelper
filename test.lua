-- --------------------------------------------------------------
-- local jopa_str = 'hello' .. 'dolbaeb'
-- print(jopa_str .. 'world')
-- --------------------------------------------------------------
-- local jopa_num = 4 + 4
-- print(jopa_num)
-- --------------------------------------------------------------
-- local jopa_bool = true
-- if jopa_bool then
--     print('Ok!')
-- else
--     print('poshel v sraky')
-- end
-- -- ���� ����� ��� � ����
-- print(jopa_bool and 'Ok!' or 'poshel v sraky')
-- --------------------------------------------------------------
-- local jopa_1 = 1
-- local jopa_2 = 2
-- if not jopa_bool then
--     print('Ok!')
-- else
--     print('poshel v sraky')
-- end
-- --------------------------------------------------------------
-- local var = {true, nil, 4, 15, 'hello'} -- �������
-- print(var[4]) -- 15 (������ � �������)
-- print(#var) -- 5 ���������� ���������
-- --------------------------------------------------------------
-- local var = {
--     [99] = 'hello',
--     ['text'] = 233,
--     text_2 = 466
-- }

-- print(var[99]) -- hello
-- print(var['text']) -- 233
-- print(var.text_2) -- 466

-- --------------------------------------------------------------
-- function onSendRpc(id, bs)
-- end


-- addEventHandler('onSendRpc', function(id, bs)
--     -- SendCommand - ID: 50
--     -- Parametrs: INT32 lengh, char[] commandtext
--     print('start');
--     if (id == 50) then
--         print('id=50');
--         local len = raknetBitStreamReadInt32(bs);
--         local str = raknetBitStreamReadString(bs, len);
--         sampAddChatMessage('cmd sent: ' .. str, -1);
--     end
-- end);