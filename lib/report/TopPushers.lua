local date = require "date"

local Module = require "lib.report.Module"

-- The cutoff is the timestamp of adoption of Proposal 9213, on 2025-02-16
local cutoff = 1739754145

local TopPushers = Module:new({
	pushers = {}
})

TopPushers:add_processor("push", function(self, e)
	if e.when >= cutoff then
		self.pushers[e.who] = self.pushers[e.who] or 0
		self.pushers[e.who] = self.pushers[e.who] + 1
	end
end)

function TopPushers:render(out)
	out:write(string.rep("-", 70) .. "\n")
	out:write("TOP PUSHERS (since things got hard)\n\n")
	local hist = {}
	for w,c in pairs(self.pushers) do
		table.insert(hist, { who = w, count = c })
	end
	table.sort(hist, function(p0, p1) return p0.count > p1.count end)
	for i,p in ipairs(hist) do
		out:write(string.format("#%-2d %2d %s %s\n", i, p.count, string.rep("=", p.count), p.who))
	end
	out:write("\n")
end

return TopPushers
