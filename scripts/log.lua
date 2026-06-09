#!/usr/bin/lua5.4
local json = require "json"

function init(t, k)
	t[k] = t[k] or {}
end

require "lib/util"

fn = "log.json"
log = decodewith(json.decode, fn)

byweek = {}
for _,e in ipairs(log) do
	init(byweek, os.date("%Y-%V", e.when))
	table.insert(byweek[os.date("%Y-%V", e.when)], e)
end

weeks = {}
for k,es in pairs(byweek) do
	table.insert(weeks, {
		week = k,
		events = es
	})
end

table.sort(weeks, function (w0,w1) return w0.week < w1.week end)

for _,w in ipairs(weeks) do
	print(string.format("%s:", w.week))
	for _,e in ipairs(w.events) do
		print(string.format("\t%s%s %s", os.date("%Y-%m-%d", e.when), e.who and " " .. e.who or "", e.what))
	end
end
