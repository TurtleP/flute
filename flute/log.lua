local log = class()

log.templates = {}

log.templates.time    = "$time"
log.templates.level   = "$level"
log.templates.message = "$message"
log.templates.utctime = "$asctime"

log.levels = {}

log.levels.debug    = 1
log.levels.info     = 2
log.levels.warning  = 3
log.levels.error    = 4
log.levels.critical = 5

local DEFAULT_FORMAT = "$time - $level - $message"
local DEFAULT_NAME   = ""

function log:new(filename, config)
    if config.level ~= nil then
        assert(functional.contains(log.levels, config.level))
    end

    config = config or { level = log.levels.debug, mode = "a", format = DEFAULT_FORMAT }

    self.level = config.level or log.levels.debug
    self.name = config.name or DEFAULT_NAME
    self.file = love.filesystem.newFile(filename, config.mode)
    self.logFormat = config.format or DEFAULT_FORMAT
end

function log:getLevelName(levelIndex)
    return table.key_of(log.levels, levelIndex):upper()
end

function log:templateFormat(levelIndex, message)
    local result = self.logFormat

    result = result:apply_template({ time = os.date("%H:%M:%S") })
    result = result:apply_template({ level = self:getLevelName(levelIndex) })
    result = result:apply_template({ message = message })
    result = result:apply_template({ utctime = os.date("%Y-%m-%d %H:%M:%S") })

    return result
end

function log:print(levelIndex, message, ...)
    if levelIndex < self.level then
        return
    end

    local message_formatted = message:format(...)

    self.file:write(self:templateFormat(levelIndex, message_formatted) .. "\n")
    self.file:flush()
end

function log:echo(message, ...)
    message = tostring(message)
    local message_formatted = message:format(...)

    self.file:write(message_formatted .. "\n")
    self.file:flush()
end

function log:debug(message, ...)
    self:print(log.levels.debug, message, ...)
end

function log:info(message, ...)
    self:print(log.levels.info, message, ...)
end

function log:warning(message, ...)
    self:print(log.levels.warning, message, ...)
end

function log:error(message, ...)
    self:print(log.levels.error, message, ...)
end

function log:critical(message, ...)
    self:print(log.levels.critical, message, ...)
end

return log
