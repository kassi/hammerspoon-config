-- Expects
--   ~/.config/slack/token
-- to exist and contain a valid slack token

require("hs.http")

local open = io.open
local function read_file(path)
  local file = open(path, "rb") -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local token=nil
function readToken()
  if token == nil then
    local tokenFile = os.getenv("HOME") .. "/.config/slack/token"
    token=string.gsub(read_file(tokenFile), "\n$", "")
  end
end

function slackApi(method, path, data)
  readToken()
  code, body, headers = hs.http.doRequest(
    "https://slack.com/api/" .. path,
    method,
    data,
    {
      Authorization = "Bearer " .. token
    }
  )
end

function setSlackStatus(emoji, text)
  slackApi(
    "POST",
    "users.profile.set",
    "profile={\"status_emoji\":\"" .. emoji .. "\",\"status_text\":\"" .. text .. "\"}"
    )
end

function clearSlackStatus()
  slackApi(
    "POST",
    "users.profile.set",
    "profile={\"status_emoji\":\"\",\"status_text\":\"\"}"
  )
end

function resetSlackStatus()
  setSlackStatusAccordingToNetwork("en0")
end
