--- === SpoonsPackageManager ===
---
--- Support 
--- 
--- TODO: link to install Spoon
--- Download: []()

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "SpoonsPackageManager"
obj.version = "1.0"
obj.author = "yehvaed <jaroslaw.walach@gmail.com>"
obj.homepage = "https://github.com/yehvaed/SpoonsPackageManager.spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- SpoonsPackageManager.logger
--- Variable
--- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
obj.logger = hs.logger.new('SpoonsPackageManager')

-- Get path to Spoon's init.lua script
obj.spoonPath = hs.spoons.scriptPath()

-- Store id and props of spoons
obj.spoons = {}

-- helpers to check if spoon is installed
local function isSpoonInstalled(name) 
    return hs.spoons.isInstalled(name)
end

-- helper to convert value to bool (ex. check if object is nil)
local function bool(val) 
    return val and true or false
end

local function split(str, delimiter)
    local t = {}
    for word in str:gmatch('[^/%s]+') do
        table.insert(t, word)
    end
    return table.unpack(t)
end 


-- Place to store middlewares
obj.middlewares = {
    -- middleware for spoons in github reposittory (ex. in Spoons directory)
    function(id, props)
        local _, name = split(id, "/")
        if not isSpoonInstalled(name) and bool(props.repo) then
            local url = ("https://raw.githubusercontent.com/%s/master/%s.spoon.zip"):format(props.repo, id)

            hs.execute("curl -O -L " .. url)
            hs.execute("unzip -o ".. name .. ".spoon.zip -d Spoons/")
            hs.execute("rm ".. name .. ".spoon.zip")
        end
    end,
    -- middleware to to create loading function
    function(id, props)
        table.insert(obj.spoons, function () 
            local _, name = split(id, "/")

            hs.spoons.use(name, {
                fn = props.fn
            })
        end)
    end
}

function obj.plug(id)
    return function(props)
        for _, middleware in ipairs(obj.middlewares) do
            middleware(id, props)
          end
    end
end


function obj.bootstrap()
    for _, spoon in ipairs(obj.spoons) do
        spoon()
    end
end

return obj

