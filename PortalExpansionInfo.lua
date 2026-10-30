local PORTALS = {
    -- Legion / Wrath (both are "Dalaran", so match the zone part)
    { "broken isles",        "Legion" },
    { "crystalsong",         "Wrath of the Lich King" },
    { "northrend",           "Wrath of the Lich King" },

    -- Midnight
    { "silvermoon",          "Midnight" },
    { "harandar",            "Midnight" },
    { "voidstorm",           "Midnight" },
    { "razorwind shores",    "Midnight (Player Housing)" },
    { "founder's point",     "Midnight (Player Housing)" },
    { "founders point",      "Midnight (Player Housing)" },

    -- The War Within
    { "dornogal",            "The War Within" },

    -- Dragonflight
    { "valdrakken",          "Dragonflight" },
    { "bel'ameth",           "Dragonflight" },
    { "dragon isles",        "Dragonflight" },

    -- Shadowlands
    { "oribos",              "Shadowlands" },

    -- Battle for Azeroth
    { "zuldazar",            "Battle for Azeroth" },
    { "dazar'alor",          "Battle for Azeroth" },
    { "boralus",             "Battle for Azeroth" },

    -- Legion
    { "azsuna",              "Legion" },

    -- Warlords of Draenor
    { "warspear",            "Warlords of Draenor" },
    { "stormshield",         "Warlords of Draenor" },
    { "ashran",              "Warlords of Draenor" },

    -- Mists of Pandaria
    { "jade forest",         "Mists of Pandaria" },
    { "vale of eternal",     "Mists of Pandaria" },
    { "shrine of",           "Mists of Pandaria" },

    -- Cataclysm
    { "vashj'ir",            "Cataclysm" },
    { "deepholm",            "Cataclysm" },
    { "hyjal",               "Cataclysm" },
    { "uldum",               "Cataclysm" },
    { "twilight highlands",  "Cataclysm" },
    { "tol barad",           "Cataclysm" },

    -- The Burning Crusade
    { "shattrath",           "The Burning Crusade" },
    { "exodar",              "The Burning Crusade" },
    { "caverns of time",     "The Burning Crusade" },
    { "hellfire",            "The Burning Crusade" },

    -- Classic
    { "blasted lands",       "Classic" },
    { "dark portal",         "Classic" },
    { "orgrimmar",           "Classic" },
    { "stormwind",           "Classic" },
    { "ironforge",           "Classic" },
    { "darnassus",           "Classic" },
    { "thunder bluff",       "Classic" },
    { "undercity",           "Classic" },
}

local LABEL_COLOR = NORMAL_FONT_COLOR or CreateColor(1, 0.82, 0)
local VALUE_COLOR = HIGHLIGHT_FONT_COLOR or CreateColor(1, 1, 1)

local cache = {}                      -- title -> expansion (or false)
local done = setmetatable({}, { __mode = "k" }) -- tooltips already handled

local function GetExpansion(title)
    local cached = cache[title]
    if cached ~= nil then return cached end

    local lower = title:lower()
    local result = false
    if lower:find("portal", 1, true) then
        for i = 1, #PORTALS do
            if lower:find(PORTALS[i][1], 1, true) then
                result = PORTALS[i][2]
                break
            end
        end
    end
    cache[title] = result
    return result
end

local function OnTooltip(tooltip)
    if not tooltip or done[tooltip] or not tooltip.GetName then return end
    local name = tooltip:GetName()
    if not name then return end

    local line = _G[name .. "TextLeft1"]
    local title = line and line:GetText()
    if not title then return end
    if issecretvalue and issecretvalue(title) then return end

    local expansion = GetExpansion(title)
    if not expansion then return end

    done[tooltip] = true
    tooltip:AddDoubleLine("Expansion:", expansion,
        LABEL_COLOR.r, LABEL_COLOR.g, LABEL_COLOR.b,
        VALUE_COLOR.r, VALUE_COLOR.g, VALUE_COLOR.b)
    tooltip:Show()
end

if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall then
    TooltipDataProcessor.AddTooltipPostCall(TooltipDataProcessor.AllTypes, OnTooltip)
end

GameTooltip:HookScript("OnShow", OnTooltip)
GameTooltip:HookScript("OnTooltipCleared", function(self) done[self] = nil end)
