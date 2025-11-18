local Module = require "lib/report/Module"

Veblen = Module:new({
	cost = 1,
	owner = nil
})

Veblen:add_processor("transfer", function(self, e)
	self.cost = e.payed + 1
	self.owner = e.who
end)

Veblen:add_processor("devalue", function(self, e)
	self.cost = e.value
end)

Veblen:add_processor("report", function(self, e)
	self.cost = e.cost
end)

function Veblen:render(out)
	local template = [[
----------------------------------------------------------------------
THE VEBLEN

          The Veblen
          is owned by %s
          and costs %d spendies

]]

	out:write(string.format(template, self.owner, self.cost))
end

Veblen:add_field("cost", function(self) return self.cost end)
Veblen:add_field("owner", function(self) return self.owner end)

return Veblen
