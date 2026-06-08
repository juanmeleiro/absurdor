#!/usr/bin/lua5.4
local json = require "json"

require "lib/util"

DAY = 60 * 60 * 24
WEEK = DAY * 7
HALF_LIFE = 2 -- in weeks

function unix2weekindex(s)
	return math.floor((s + 3*DAY)/WEEK)
end

fn = "log.json"
log = decodewith(json.decode, fn)

weeks = {}

for _,e in ipairs(log) do
	if e.what == "push" then
		weeks[e.who] = weeks[e.who] or {}
		local w = unix2weekindex(e.when)
		if (weeks[e.who][w]) then
			local d = os.date("%Y-%m-%d", w*WEEK - 3*DAY)
			print(string.format("Error: %s pushed the boulder twice in week %d starting at %s", e.who, w, d))
		else
			weeks[e.who][w] = true
		end
	end
end
