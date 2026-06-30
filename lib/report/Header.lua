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
absurdor: juan          The State of the Absurd       %s                     
======================================================================
]]
	out:write(string.format(template, os.date("%Y-%m-%d %H:%M", self.last)))
end

return Header
