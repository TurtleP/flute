local path = (...):gsub("%.init%", "")
require(path .. ".batteries"):export()

local flute = {}

flute.suite = require(path .. ".suite")
flute.test  = require(path .. ".test")

return flute
