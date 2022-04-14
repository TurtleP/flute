--[[
	batteries for lua

	a collection of helpful code to get your project off the ground faster
]]

local path = ...
local function require_relative(p)
    return require(table.concat({ path, p }, "."))
end

--build the module
local _batteries =
{
    assert = require_relative("assert"),
    async = require_relative("async"),
    class = require_relative("class"),
    functional = require_relative("functional"),
    measure = require_relative("measure"),
    pretty = require_relative("pretty"),
    stringx = require_relative("stringx"),
    tablex = require_relative("tablex"),
    timer = require_relative("timer")
}

--easy export globally if required
function _batteries:export()
    --export all key strings globally, if doesn't already exist
    for k, v in pairs(self) do
        if _G[k] == nil then
            _G[k] = v
        end
    end

    --overlay tablex and functional and sort routines onto table
    self.tablex.shallow_overlay(table, self.tablex)
    table.shallow_overlay(table, self.functional)

    --overlay onto string
    table.shallow_overlay(string, self.stringx)

    --overwrite assert wholesale (it's compatible)
    assert = self.assert

    --like ipairs, but in reverse
    ripairs = self.tablex.ripairs

    --export the whole library to global `batteries`
    batteries = self

    return self
end

return _batteries
