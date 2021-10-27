require("slack")
require("calm")

check_interval=10 -- number of seconds to check zomo status
notify_status_change = false -- whether you also want a desktop notification

locale_menu = {
  de = "Dem Meeting beitreten...",
  en = "Join Meeting...",
  es = "Entrar a la Reunión...",
  fr = "Rejoindre la réunion",
  it = "Entra nella riunione...",
  ja = "ミーティングに参加...",
  ko = "회의 참가...",
  pt = "Ingressar na Reunião...",
  ru = "Войти в конференцию...",
  vi = "Tham gia cuộc họp...",
  zh = "加入会议...",
  -- zh = "加入會議中...",
}
language = string.sub(hs.host.locale.preferredLanguages()[1],1,2)

function update_status(status)
    if status == "zoom" then
      setSlackStatus(":zoom:", "On a call")
      calmDown()
    else
      resetSlackStatus()
      calmUp()
    end
end

function in_zoom_meeting()
    local app = hs.application.find("zoom.us")
    if app ~= nil then
        local menu_item = app:findMenuItem(locale_menu[language])
        return menu_item ~= nil and not menu_item["enabled"]
    else
        return false
    end
end

zoom_meeting_running = false
zoom_timer = hs.timer.doEvery(check_interval, function()
    if in_zoom_meeting() then
      if zoom_meeting_running == false then
            zoom_meeting_running = true
            update_status("zoom")
            if notify_status_change then
              hs.notify.show("Started zoom meeting", "Updating slack status", "")
            end
          end
        else
          if zoom_meeting_running == true then
            zoom_meeting_running = false
            update_status("none")
            if notify_status_change then
              hs.notify.show("Left zoom meeting", "Updating slack status", "")
            end
        end
    end
end)
zoom_timer:start()
