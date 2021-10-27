-- system libraries
require("hs.ipc")
require("hs.notify")
require("hs.hotkey")
-- personal modules
require("globals")
require("caffeine")
require("layout")
require("mouse")
require("window")
require("work")
require("zoom")

function reloadConfig(files)
  hs.reload()
  -- hs.notify.new({title = "Hammerspoon",
  --   informativeText = "Configuration reloaded.",
  --   autoWithdraw = true,
  --   withdrawAfter = 2}):send()
end
hs.hotkey.bind({"shift", "ctrl", "alt", "cmd"}, "R", reloadConfig)
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
