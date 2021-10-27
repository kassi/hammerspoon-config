require "globals"
require "window"
require "slack"

home_networks = Set { "Aries" }
nwh_networks = Set { "NW-WIRELESS", "NW-GUEST", "NW-Portal" }

function setSlackStatusAccordingToNetwork(interface)
  local ssid = hs.wifi.currentNetwork(interface)
  hs.notify.show("Set Slack Status for Wifi Network", "", ssid)

  if home_networks[ssid] then
    setSlackStatus(":house_with_garden:", "Working remotely")
  elseif nwh_networks[ssid] then
    hs.notify.show("Set Slack Status for Wifi Network", "", ssid)
    setSlackStatus(":nwh_arche:", "NWH 4 green")
  else
    clearSlackStatus()
  end
end

function on_wifi_change(watcher, event, interface)
  if event == "SSIDChange" then
    setSlackStatusAccordingToNetwork(interface)
  end
end
wifi_watcher = hs.wifi.watcher.new(on_wifi_change)
wifi_watcher:start()
setSlackStatusAccordingToNetwork("en0")

function findNewWindow(before, after)
  local t = {}
  for i = 1, #before do
    t[before[i]:id()] = true
  end
  for i = #after, 1, -1 do
    if not t[after[i]:id()] then
      return after[i]
    end
  end
  return nil
end

function openNewFirefoxWindow(appName)
  appName = appName or "Firefox"
  if hs.application.launchOrFocus(appName .. ".app") then
    local app = waitFor(hs.application.frontmostApplication, function(res)
      return res:name() == appName
    end, 3)
    local menuTitle
    local menuEntry
    local menuItems
    menuItems = app:getMenuItems()
    menuTitle = menuItems[2]["AXTitle"]
    menuEntry = menuItems[2]["AXChildren"][1][3]["AXTitle"]

    local wins = app:allWindows()
    local menuItem = app:selectMenuItem({menuTitle, menuEntry})

    local newWin = waitFor(function()
      local wins2 = app:allWindows()
      return findNewWindow(wins, wins2)
    end, function(result)
      return result ~= nil
    end, 3)
    hs.layout.apply({{ app, newWin, hs.screen('1,0'), hs.geometry.unitrect(0.15, 0, 0.7, 1), nil, nil}})
  else
    print(appName .. ".app doesn't exist")
  end
end

hs.hotkey.bind({"cmd"}, "f15", openNewFirefoxWindow)
hs.hotkey.bind({"cmd", "shift"}, "f15", function() openNewFirefoxWindow("Firefox Developer Edition") end)
