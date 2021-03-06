require("hs.screen")

function sortDisplays(a, b)
  return a.x < b.x
end

function showDisplays()
  for i, screen in pairs(hs.screen.allScreens()) do
    print(screen:position(), screen:id(), screen:getUUID())
  end
end

function getDisplayInOrder(d)
  local displays = {}
  for k, v in pairs(hs.screen.screenPositions()) do
    displays[v.x+1] = k
  end
  return displays[d]
end

function moveWindowToDisplay(d)
  return function(win)
    if win == nil then
      win = hs.window.focusedWindow()
    end
    win:moveToScreen(getDisplayInOrder(d), false, true)
  end
end

function getDisplayByName(name)
  local map = {
    laptop = 1,
    left = 1,
    front = 2,
    right = 3
  }
  return getDisplayInOrder(map[name])
end
