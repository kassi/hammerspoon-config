-- Requires
--   brew install calm-notifications

function calmDown()
  hs.execute([["/usr/local/bin/calm-notifications" "on"]])
end

function calmUp()
  hs.execute([["/usr/local/bin/calm-notifications" "off"]])
end
