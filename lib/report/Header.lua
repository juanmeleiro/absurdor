local Module = require "lib/report/Module"

Header = Module:new()

function Header:render(out)
	local template = [[
======================================================================
absurdor: juan          The State of the Absurd             %s                     
======================================================================
]]
	out:write(string.format(template, os.date("%Y-%m-%d")))
end

return Header
