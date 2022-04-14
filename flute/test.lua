local test = class()

function test:create(name, description, task)
    self._name        = name
    self._description = description

    self._pass = false
    self._task = assert:type(task, "function")
    self._message = nil
end

function test:assert_equal(a, b)
    self._pass = (a == b)

    if not self._pass then
        self._message = ("equality failure: %s ~= %s"):format(tostring(a), tostring(b))
    end

    return self._pass
end

function test:assert_less_than(a, b)
    a = assert:type(a, "number")
    b = assert:type(b, "number")

    self._pass = (a < b)

    if not self._pass then
        self._message = ("less_than failure: %s >= %s"):format(tostring(a), tostring(b))
    end

    return self._pass
end

function test:assert_greater_than(a, b)
    a = assert:type(a, "number")
    b = assert:type(b, "number")

    self._pass = (a > b)

    if not self._pass then
        self._message = ("greater_than failure: %s <= %s"):format(tostring(a), tostring(b))
    end

    return self._pass
end

function test:assert_less_than_equal(a, b)
    a = assert:type(a, "number")
    b = assert:type(b, "number")

    self._pass = (a <= b)

    if not self._pass then
        self._message = ("less_than_equal failure: %s > %s"):format(tostring(a), tostring(b))
    end

    return self._pass
end

function test:assert_greater_than_equal(a, b)
    a = assert:type(a, "number")
    b = assert:type(b, "number")

    self._pass = (a >= b)

    if not self._pass then
        self._message = ("greater_than_equal failure: %s < %s"):format(tostring(a), tostring(b))
    end

    return self._pass
end

function test:assert_type(a, typeOf)
    local type = type(a)
    if type == "userdata" then
        type = a:type()
    end

    return self:assert_equal(type, typeOf)
end

function test:execute(log)
    self._pass, self._message = pcall(function() self._task(self, log) end)
    assert(self._pass == true, self._message)
end

function test:message()
    return self._message
end

function test:status()
    return self._pass
end

function test:name()
    return self._name
end

function test:about()
    return self._description
end

function test:__tostring()
    return self:name() .. " => " .. self:about()
end

return test
