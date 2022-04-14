local test = require("flute.test")()

test:create("piepie", "do another thing, I guess", function(self, log)
    local dataview = love.data.newByteData(512)
    self:assert_equal(dataview:getSize(), 512)
end)

return test
