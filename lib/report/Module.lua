local Module = {}

function Module:new(m)
	local m = m or {}
	m.variables = m.variables or {}
	self.__index = self
	setmetatable(m, self)
	return m
end

function Module:add_processor(what, fun)
	self.types = self.types or {}
	self.types[what] = fun
end

function Module:process(e)
	self.types = self.types or {}
	if self.types[e.what] then
		self.types[e.what](self, e)
	end
end

function Module:render(out) end

function Module:keys()
	if not self.fields then
		self.fields = {}
	end
	local ks = {}
	for k,_ in pairs(self.fields) do
		table.insert(ks, k)
	end
	local i = 0
	return function()
		i = i + 1
		return ks[i]
	end
end

function Module:add_field(k, f)
	self.fields = self.fields or {}
	self.fields[k] = f
end

function Module:log(k)
	if (self.fields[k]) then
		return self.fields[k](self)
	else
		error(string.format("Tried getting value of inexistent field '%s'", k))
	end
end

return Module
