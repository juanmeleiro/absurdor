local date = require "date"

local Module = require "lib.report.Module"

local now = date(os.date())
local this_monday = now:adddays(- (now:getisoweekday() - 1))
local previous_monday = this_monday:adddays(-7)

local Latest = Module:new({
	start = date.diff(previous_monday, date.epoch()):spanseconds(),
	events = {}
})
Latest:add_processor("push", function(self, e)
	if e.when >= self.start then
		table.insert(self.events, e)
	end
end)
Latest:add_processor("report", function(self, e)
	if e.when >= self.start then
		table.insert(self.events, e)
	end
end)
function Latest:render(out)
	out:write(string.rep("-", 70) .. "\n")
	out:write("LATEST EVENTS\n\n")
	for _,e in ipairs(self.events) do
		out:write(fmt_event(e) .. "\n")
	end
	out:write("\n")
end

return Latest
