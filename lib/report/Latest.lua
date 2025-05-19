local date = require "date"

local Module = require "lib.report.Module"

local Latest = Module:new({
	start = -math.huge,
	events = {}
})
Latest:add_processor("push", function(self, e)
	if e.when >= self.start then
		table.insert(self.events, e)
	end
end)
Latest:add_processor("report", function(self, e)
	self.start = e.when
	self.events = {e}
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
