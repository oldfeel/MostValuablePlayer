local friends = {}

local function Event(event, handler)
    if _G.event == nil then
        _G.event = CreateFrame("Frame")
        _G.event.handler = {}
        _G.event.OnEvent = function(frame, event, ...)
            for key, handler in pairs(_G.event.handler[event]) do
                handler(...)
            end
        end
        _G.event:SetScript("OnEvent", _G.event.OnEvent)
    end
    if _G.event.handler[event] == nil then
        _G.event.handler[event] = {}
        _G.event:RegisterEvent(event)
    end
    table.insert(_G.event.handler[event], handler)
end


local function colortxt(name)
    if name then
        if UnitInRaid(name) or UnitInParty(name) then
            local rsccodeclass = 0
            local _, rsctekclass = UnitClass(name)
            if rsctekclass then
                rsctekclass = string.lower(rsctekclass)
                if rsctekclass == "warrior" then rsccodeclass = 1
                elseif rsctekclass == "deathknight" then rsccodeclass = 2
                elseif rsctekclass == "paladin" then rsccodeclass = 3
                elseif rsctekclass == "priest" then rsccodeclass = 4
                elseif rsctekclass == "shaman" then rsccodeclass = 5
                elseif rsctekclass == "druid" then rsccodeclass = 6
                elseif rsctekclass == "rogue" then rsccodeclass = 7
                elseif rsctekclass == "mage" then rsccodeclass = 8
                elseif rsctekclass == "warlock" then rsccodeclass = 9
                elseif rsctekclass == "hunter" then rsccodeclass = 10
                elseif rsctekclass == "monk" then rsccodeclass = 11
                elseif rsctekclass == "demonhunter" then rsccodeclass = 12
                end
                local tablecolor = {"|CFFC69B6D", "|CFFC41F3B", "|CFFF48CBA", "|CFFFFFFFF", "|CFF1a3caa", "|CFFFF7C0A", "|CFFFFF468", "|CFF68CCEF", "|CFF9382C9", "|CFFAAD372", "|CFF00FF96", "|CFFA330C9", "|cff999999"}
                if rsccodeclass == 0 then
                    return "|cff999999" --для цвет петов
                else
                    return tablecolor[rsccodeclass]
                end
            end
        else
            return "" --цвет петов
        end
    end

end


local function GetColor(nr, name)
    if name then
        if nr == 2 then
            return "|r"
        end
        if nr == 1 then
            local realm = nil
            local _, localrealm = UnitFullName("player", true)
            
            if string.find(name, "%-") then
                realm = string.sub(name, string.find(name, "%-") + 1, -1)
            end

            if string.find(name, "%%") then
                name = string.sub(name, 1, string.find(name, "%%") - 1)
            end

            local color = colortxt(name)

            if color ~= "" then
                 return color           
            end
                        
            for i in pairs(MVP_Settings["MVPvscache"]) do
                if (name == MVP_Settings["MVPvscache"][i]["oname"] and (realm == "" or realm == nil) and localrealm == MVP_Settings["MVPvscache"][i]["orealm"]) then
                    return string.sub(MVP_Settings["MVPvscache"][i]["oclass"], 1, 10)
                end
            end

            for i in pairs(MVP_Settings["MVPvscache"]) do
                if (name == MVP_Settings["MVPvscache"][i]["oname"] and (realm == MVP_Settings["MVPvscache"][i]["orealm"] or realm == "" or realm == nil)) then
                    return string.sub(MVP_Settings["MVPvscache"][i]["oclass"], 1, 10)
                end
            end
            return "|cFF000000"
        end
    end
end

local psfilter = function(_, event, msg, player, ...)
    if friends == {} then
        return false
    else
        local chanid, found, modify = select(5, ...), 0, nil
        for i = 1, #(friends) do
            local tag = friends[i]
            if string.find(msg, tag) then
                msg, found = string.gsub(msg, tag, GetColor(1, tag) .. tag .. GetColor(2, tag))
                msg = string.gsub(msg, "|r%-", "%-")
                if found > 0 then modify = true end
            end
        end
        if modify then
            return false, msg, player, ...
        end
    end
end

local function ADDfilter()
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ITEM_LOOTED", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_ACHIEVEMENT", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_FILTERED", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONEY", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_EMOTE", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_PARTY", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_SAY", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_WHISPER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_BOSS_EMOTE", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_BOSS_WHISPER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", psfilter)
end

local function addfriends()
    local name, realm = UnitFullName("player")
    for i in pairs(MVP_Settings["MVPvscache"]) do
        table.insert(friends, MVP_Settings["MVPvscache"][i]["oname"] .. "%-" .. MVP_Settings["MVPvscache"][i]["orealm"])
        table.insert(friends, MVP_Settings["MVPvscache"][i]["oname"])
    end
    local aa = {}
    for k, v in pairs(friends) do
        aa[v] = true
    end
    friends = {}
    for k, v in pairs(aa) do
        table.insert(friends, k)
    end
    table.sort(friends, function(a, b) return tostring(a) > tostring(b) end)
end

Event("PLAYER_LOGIN", function()
    ADDfilter()
end)

Event("PLAYER_ENTERING_WORLD", function()
    addfriends()
end)

Event("PLAYER_REGEN_DISABLED", function()
    addfriends()
end)
