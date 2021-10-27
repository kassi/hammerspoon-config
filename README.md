# My Hammerspoon Config

## Provides

* Set Slack status according to location and meeting status
* Caffeine with individual settings, including a "disable throttling" option to speed up processes like long running Time Machine runs, etc.
* Mouse auto-switcher
* Lots of shortcuts to quickly place windows
* Some goodies to find browser windows for reuse

### Set Slack Status

This sets the slack status according to a configurable network list.
If I'm at home, it sets the house icon with "Working remotely" text.
If I'm at work, it sets the office icon with my location.
If I'm in a zoom call, it sets the zoom icon (overriding the above) and sets do not disturb mode.

In order to use slack, you need to register a slack app that allows setting the status and get a token.
Place the token into `$HOME/.config/slack/token`.

In order to set do not distirb mode, you need to

```
brew install calm-notifications
```

For only the slack status, you need
* `init.lua`
* `globals.lua`
* `slack.lua`
* `work.lua`
* `zoom.lua`
* `calm.lua`

