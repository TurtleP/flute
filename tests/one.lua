local test = require("flute.test")()

test:create("yeet", "do a thing, I guess", function(self, log)
    log:echo("  is 1 == 1? %s", self:assert_equal(1, 1))

    -- less_than failure
    -- self:assert_less_than(420, 69)

    -- lua pcall error about concat with a boolean value
    -- print(true .. "!")
end)

return test
