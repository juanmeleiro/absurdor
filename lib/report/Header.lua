local Module = require "lib/report/Module"

Header = Module:new({
	last = -math.huge
})

Header:add_processor("push", function(self, e)
	self.last = e.when
end)

function Header:render(out)
	local template = [[
======================================================================
absurdor: juan      The State of the Absurd%s%s                     
======================================================================
]]
	local ts = os.date("!%Y-%m-%d %H:%M %Z", self.last)
	local spaces = string.rep(" ", 27 - string.len(ts))
	out:write(string.format(template, spaces, ts))
end

return Header
