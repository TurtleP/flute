local lute = require("flute")

local suite = nil
function love.load()
    suite = lute.suite("test", "tests", { "two.lua" })
end

function love.update(dt)
    suite:update()
end
