local Module = require "lib/report/Module"

Footer = Module:new()

function Footer:render(out)
	local template = [[
----------------------------------------------------------------------
Do you have any suggestions on what I should put on the report?
Send them to me!
======================================================================
]]
	out:write(string.format(template, os.date("%Y-%m-%d")))
end

return Footer
