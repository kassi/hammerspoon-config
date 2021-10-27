require "hs.menubar"
local caffeine = hs.menubar.new(true)
local caffeineDuration = nil

local iconOff = [[
....................
....................
....................
.........11.........
....................
..1.................
..h..............e..
.................1..
.........gf1......2.
................2..2
....................
....i..........d..2.
..................2.
......j......c......
........a..b........
]]
local iconOn = [[
.....R...J...D......
......Q...I...C.....
.....P...H...B......
......O...G...A.....
.........11.........
....................
..1.................
..h..............e..
.................1..
.........gf1......2.
................2..2
....................
....i..........d..2.
..................2.
......j......c......
........a..b........
]]

function setCaffeineIconOff()
  caffeine:setIcon(hs.image.imageFromASCII(iconOff, {
    { -- 1
      fillColor={red=1,green=0,blue=0,alpha=0},
      strokeColor={red=1,green=0,blue=0},
    },
    { -- 2
      fillColor={red=1,green=0,blue=0,alpha=0},
      strokeColor={red=1,green=0,blue=0},
    },
    { -- abcd
      fillColor={red=1,green=1,blue=0,alpha=0.8},
      strokeColor={red=1,green=1,blue=0},
      lineWidth=1.4
    }
  }))
end
function setCaffeineIconOn()
  caffeine:setIcon(hs.image.imageFromASCII(iconOn, {
    { -- 1
      fillColor={red=1,green=0,blue=0,alpha=0.5},
      strokeColor={red=1,green=0,blue=0},
    },
    { -- 2
      fillColor={red=1,green=0,blue=0,alpha=0},
      strokeColor={red=1,green=0,blue=0},
    },
    { -- abcd
      fillColor={red=1,green=1,blue=0,alpha=0.5},
      strokeColor={red=1,green=1,blue=0},
      shouldClose=false
    },
    { -- abcd
      fillColor={red=1,green=1,blue=0,alpha=0.5},
      strokeColor={red=1,green=1,blue=0},
      shouldClose=false
    },
    { -- abcd
      fillColor={red=1,green=0,blue=0,alpha=1},
      strokeColor={red=1,green=0,blue=0},
    },

  }))
end

function getLowPriThrottle()
  result, obj, desc = hs.osascript.applescript('do shell script "/usr/sbin/sysctl debug.lowpri_throttle_enabled"')
  if result then
    throttle = string.sub(obj,-1,-1)
  end
  return throttle
end

function toggleLowPriThrottle()
  throttle = getLowPriThrottle()
  if throttle == "1" then
    newValue = "0"
  else
    newValue = "1"
  end
  hs.osascript.applescript('do shell script "/usr/bin/sudo /usr/sbin/sysctl debug.lowpri_throttle_enabled=' .. newValue .. '" with administrator privileges')
  setCaffeineDisplay()
end

local caffeineTimer = nil

function decaffeinate()
  if caffeineTimer and caffeineTimer:running() then
    caffeineTimer:stop()
  end
  hs.caffeinate.set("displayIdle", false, true)
  setCaffeineDisplay()
end

function caffeinateFor(duration)
  return function()
    if caffeineTimer then
      caffeineTimer:stop()
    end

    caffeineDuration = duration
    hs.caffeinate.set("displayIdle", true, true)
    setCaffeineDisplay()

    if duration then
      caffeineTimer = hs.timer.doAfter(duration*60, decaffeinate)
    end
  end
end

function caffeineMenu(mods)
  state = hs.caffeinate.get("displayIdle")
  throttle = getLowPriThrottle()
  throttleEnabled = throttle and throttle == "1"

  return {
    { title = "Decaffeinate", fn = decaffeinate, disabled = not state },
    { title = "Caffeinate", disabled = true },
    { title = "…Indefinitely", fn = caffeinateFor(nil), checked = state and caffeineDuration == nil},
    { title = "…for 2 hours", fn = caffeinateFor(60*2), checked = state and caffeineDuration == 60*2},
    { title = "…for 4 hours", fn = caffeinateFor(60*4), checked = state and caffeineDuration == 60*4},
    { title = "…for 8 hours", fn = caffeinateFor(60*8), checked = state and caffeineDuration == 60*8},
    { title = "-"},
    { title = "Disable low priority throttle…", fn = toggleLowPriThrottle, checked = not throttleEnabled}
  }
end

function setCaffeineDisplay()
  state = hs.caffeinate.get("displayIdle")
  if state then
    setCaffeineIconOn()
  else
    setCaffeineIconOff()
  end

  throttle = getLowPriThrottle()
  if throttle == "0" then
    caffeine:setTitle("!")
  else
    caffeine:setTitle("")
  end
end

if caffeine then
    caffeine:setMenu(caffeineMenu)
    setCaffeineDisplay()
end
