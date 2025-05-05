local date = require "date"
local Module = require "lib/report/Module"
require "lib.log"

-- Generic interface
Report = {}

function Report:new(r)
	local r = r or {}
	setmetatable(r, self)
	r.modules = {}
	self.__index = self
	return r
end

function Report:add_module(m)
	if self.closed then
		error("Tried adding module after processing events.")
	end
	table.insert(self.modules, m:new())
end

function Report:process(e)
	self.closed = true
	for _,m in ipairs(self.modules) do
		m:process(e)
	end
end

function Report:render(out)
	for _,m in ipairs(self.modules) do
		m:render(out)
	end
end

function Report:report(log, out)
	for _,e in ipairs(log) do
		self:process(e)
	end
	self:render(out)
end

function Report:log()
	local rec = {}
	for _,m in ipairs(self.modules) do
		for k in m:keys() do
			rec[k] = m:log(k)
		end
	end
	rec.when = os.time()
	rec.what = "report"
	return rec
end

-- Modules

local modules = {}
modules.Mail = require "lib.report.Mail"
modules.Header = require "lib.report.Header"
modules.Banner = require "lib.report.Banner"
modules.Latest = require "lib.report.Latest"
modules.Veblen = require "lib.report.Veblen"
modules.Footer = require "lib.report.Footer"
modules.TopPushers = require "lib.report.TopPushers"

return {
	modules = modules
}
