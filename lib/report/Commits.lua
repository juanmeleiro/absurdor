local date = require "date"

local Module = require "lib.report.Module"

local Commit = Module:new({
	start = -math.huge,
})

Commit:add_processor("report", function(self, e)
	self.start = e.when
end)

function Commit:render(out)
	local template = [[jj log -r 'author_date(after:"%s")' --no-graph --template 'self.author().timestamp().utc() ++ " " ++ self.commit_id().short() ++ " " ++ self.description().remove_suffix("\n") ++ "\n"']]
	local cmd = string.format(template, os.date("%Y-%m-%dT%H:%M:%S%Z", self.start))
	local f = io.popen(cmd, "r")
	out:write(string.rep("-", 70) .. "\n")
	out:write("LATEST COMMITS\n\n")
	out:write(f:read("a"))
	f:close()
	out:write("\n")
end

return Commit
