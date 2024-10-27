local ffi = require "ffi" -- подключаем FFI

ffi.cdef[[
    struct stServerPresets
    {
        uint8_t     byteCJWalk;
        int         m_iDeathDropMoney;
        float	    fWorldBoundaries[4];
        bool        m_bAllowWeapons;
        float	    fGravity;
        uint8_t     byteDisableInteriorEnterExits;
        uint32_t    ulVehicleFriendlyFire;
        bool        m_byteHoldTime;
        bool        m_bInstagib;
        bool        m_bZoneNames;
        bool        m_byteFriendlyFire;
        int		    iClassesAvailable;
        float	    fNameTagsDistance;
        bool        m_bManualVehicleEngineAndLight;
        uint8_t     byteWorldTime_Hour;
        uint8_t     byteWorldTime_Minute;
        uint8_t     byteWeather;
        uint8_t     byteNoNametagsBehindWalls;
        int         iPlayerMarkersMode;
        float	    fGlobalChatRadiusLimit;
        uint8_t     byteShowNameTags;
        bool        m_bLimitGlobalChatRadius;
    }__attribute__ ((packed));
]]

function main()
    repeat wait(0) until isSampAvailable() -- ожидание инициализации SA:MP
    local server = ffi.cast('struct stServerPresets*', sampGetServerSettingsPtr()) -- преобразовываем указатель одного типа в указатель другого типа
    print(server.fGravity) -- выводим, к примеру, гравитацию сервера
    server.byteShowNameTags = 0
    print(ffi.offsetof("struct stServerPresets", "byteShowNameTags"))
end