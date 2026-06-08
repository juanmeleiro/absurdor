local date = require "date"

local Module = require "lib.report.Module"

-- The cutoff is the timestamp of adoption of Proposal 9213, on 2025-02-16
local cutoff = 1739754145

local TopPushers = Module:new({
	pushers = {},
	now = os.time()
})

DAY = 60 * 60 * 24
WEEK = DAY * 7

function unix2weekindex(s)
	return math.floor((s + 3*DAY)/WEEK)
end

function contribution(ts, now)
	local curweek = unix2weekindex(now)
	local pushweek = unix2weekindex(ts)
	local delta = curweek - pushweek
	return 1/((delta + 1)*(delta + 2))
end

TopPushers:add_processor("push", function(self, e)
	self.pushers[e.who] = self.pushers[e.who] or 0
	self.pushers[e.who] = self.pushers[e.who] + contribution(e.when, self.now)
end)

function TopPushers:render(out)
	out:write(string.rep("-", 70) .. "\n")
	out:write("TOP RECENT PUSHERS (with exponential decay!)\n\n")
	local hist = {}
	for w,c in pairs(self.pushers) do
		table.insert(hist, { who = w, score = c })
	end
	table.sort(hist, function(p0, p1) return p0.score > p1.score end)
	local width = 30
	for i,p in ipairs(hist) do
		local count = math.floor(width * p.score)
		if count > 0 then
			out:write(string.format("#%-2d %.3f %s %s\n", i, p.score, string.rep("=", count), p.who))
		end
	end
	out:write("\n")
	out:write("(The score is the average over all half-lifes of the scores obtained by\neach push contributing 1 with exponential decay with that half-life,\nrounding the time using which week it happened on.)")
	out:write("\n\n")
end

return TopPushers
