function ap(x)
  print(hs.inspect(x))
end

function split(str, sep)
  if sep == nil then
    sep = "\t"
  end
  local t = {}
  for s in string.gmatch(str, "([^"..sep.."]+)") do
    table.insert(t, s)
  end
  return t
end

function inspectWindows(name)
  local app = hs.application.find(name)
  print(hs.inspect(app:allWindows()))
end

function waitForApplication(name, timeout)
  print(timeout)
  function findApplication()
    return hs.application.find(name)
  end
  waitFor(findApplication, function(res)
    return res ~= nil
  end, timeout)
end

function waitFor(func, testFunc, timeout)
  local timeoutReached = false
  local timer = hs.timer.doAfter(timeout, function()
    timeoutReached = true
  end)
  local result = nil
  repeat
    if timeoutReached then
      return nil
    end
    result = func()
  until testFunc(result)
  timer:stop()
  return result
end

function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end
