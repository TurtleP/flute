local path = (...):gsub("suite", "")

local suite = class()

local utf8   = require("utf8")
local logger = require(path .. ".log")

local print_header = nil
local print_footer = nil

local async_pass = nil
local async_fail = nil

function suite:new(name, tests_or_path, exclude)
    local items = tests_or_path
    if type(tests_or_path) == "string" then
        items = love.filesystem.getDirectoryItems(tests_or_path)
    end

    exclude = exclude or {}

    functional.filter_inplace(items, function(value, _)
        if functional.contains(exclude, value) then
            return false
        end
        return true
    end)

    self.items = {}

    self.name = name or "suite"
    for index = 1, #items do
        local name = items[index]:gsub(".lua", "")
        self.items[index] = require(tests_or_path .. "." .. name)
    end

    self.log = logger("test.log", { name = name, mode = "w" })

    print_header(self.log, #self.items)

    self.async = async()

    functional.foreach(self.items, function(item, _)
        self.log:echo("Executing Test '%s':", item:name())

        self.async:call(function()
            item:execute(self.log)
        end, nil, function()
            async_pass(self.log, item)
        end, function()
            async_fail(self.log, item)
        end)
    end)

    self._finish = false
end

function suite:update()
    local running = self.async:update()
    if not running and not self._finish then
        print_footer(self.log, self.items)
        self._finish = true
    end
end

function async_pass(log, item)
    if not item:status() then
        return
    end

    log:echo("Test '%s' status: PASS.", item:name())
end

function async_fail(log, item)
    log:echo("Test '%s' status: FAIL.\n  %s", item:name(), item:message())
end

function print_header(log, count)
    local message = ("# Executing a total of $tests test(s) #"):apply_template({ tests = count })
    local divider = string.rep("-", #message)

    log:echo(divider)
    log:echo(message)
    log:echo(divider)
end

function print_footer(log, items)
    local passing = 0
    functional.foreach(items, function(item, _)
        if item:status() then
            passing = passing + 1
        end
    end)


    local message = ("# $fail failed. $pass passed. $percent%% success rate. #"):apply_template({
        fail = #items - passing, pass = passing,
        percent = (passing / #items) * 100
    })

    local divider = string.rep("-", #message)

    log:echo(divider)
    log:echo(message)
    log:echo(divider)
end

return suite
