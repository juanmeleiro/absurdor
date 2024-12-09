local banner = {
	filter = function(self, e) return e.what == "push" end
	digest = function(self, e)
		local w = nil -- calculate week of timestamp e.when
		if self.pushed[w-1] or self.pushed[w] or week2sec(sec2week(e.when)) < 1693159683 then
			-- At 1693159683 seconds from Unix epoch, the governing
			-- rule was changed so that the Boulder falls to zero
			-- if it was not pushed the previous week. However, the
			-- change is not retroactive; hence the magic number.
			height = (height + 1)
		else
			height = 1
		end
		self.pushed[w] = true
	end,
	render = function(self, out)
		vars = {
			YYYY = os.date("!%Y"),
			MM = os.date("!%m"),
			DD = os.date("!%d"),
			N = height
		}

		defs = ""

		for k, v in pairs(vars) do
			defs = defs .. string.format(" --define=%s=%s", k, v)
		end

		tmpname = ".tmp"
		-- Height banner
		os.execute(string.format("m4 %s templates/banner.m4 >> %s", defs, tmpname))
	end,
	height = 0,
	pushed = {}
}

function report(modules, log, out)

	-- Precompute data
	for _,e in ipairs(log) do
		for _,m in ipairs(modules) do
			if m:filter(e) then
				m:digest(e)
			end
		end
	end

	-- Render data
	for _,m in ipairs(modules) do
		m:render(out)
	end
end
