# F. L. U. T. E

## Freakin' LÖVE Unit Testing Environment

This is a simple Unit Testing structure made with [batteries](https://github.com/1bardesign/batteries).

## Components

### flute.suite(name, pathOrItems, exclude)

* name: `string` Name of the Test Suite
* pathOrItems: `table|string`
  + table: list of filepaths to include
  + string: directory to load filepaths from (non-recursive)
* exclude: `table` List of filepaths to exclude

The Suite class is located under `flute/suite.lua` . This defines a list of what tests you would like to run.

### flute.suite:update()

The update function is ran under the `love.update` callback. This will execute all the tests that it holds.

```lua
local lute = require("flute")

local suite = nil
function love.load()
    suite = lute.suite("test", "tests", { "two.lua" })
end

function love.update(dt)
    suite:update()
end
```

### flute.test

This is the base item for all test cases. You don't need to inherit via OOP, only require the file and create a new instance.

```lua
-- one.lua

local test = require("flute.test")()

test:create("yeet", "do a thing, I guess", function(self, log)
    log:echo("  is 1 == 1? %s", self:assert_equal(1, 1))

    -- less_than failure
    -- self:assert_less_than(420, 69)

    -- lua pcall error about concat with a boolean value
    -- print(true .. "!")
end)

return test
```

### flute.test:create(name, description, task)

* name: `string` Name of the Test
* description: `string` Description of the Test
* task: `function` The task to run for validation

### task(test, logger)

* test: `flute.test` This Test object
* logger: `flute.logger` Logger class that is from this Test's Suite
