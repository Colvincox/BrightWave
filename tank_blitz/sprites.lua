--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:24cc6a1e3e960f30b21e5c9f4922ff0b$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- bg
            x=2,
            y=2,
            width=240,
            height=240,

        },
        {
            -- bullet
            x=446,
            y=2,
            width=34,
            height=33,

        },
        {
            -- obj1
            x=244,
            y=2,
            width=118,
            height=118,

        },
        {
            -- obj2
            x=342,
            y=146,
            width=106,
            height=101,

        },
        {
            -- tank1
            x=244,
            y=122,
            width=96,
            height=106,

            sourceX = 72,
            sourceY = 69,
            sourceWidth = 240,
            sourceHeight = 240
        },
        {
            -- tank2
            x=364,
            y=2,
            width=80,
            height=142,

            sourceX = 80,
            sourceY = 78,
            sourceWidth = 240,
            sourceHeight = 240
        },
    },
    
    sheetContentWidth = 482,
    sheetContentHeight = 249
}

SheetInfo.frameIndex =
{

    ["bg"] = 1,
    ["bullet"] = 2,
    ["obj1"] = 3,
    ["obj2"] = 4,
    ["tank1"] = 5,
    ["tank2"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
