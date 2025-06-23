local Module = require "lib/report/Module"

local Banner = Module:new({
	height = 0,
	slope = 1,
	max_height = 0,
	max_slope = 1,
	weekly_pushes = {},
	weekly_slope = {}
})

function maybe_start_week(data, w)
	if data.weekly_pushes[w] == nil then -- Starting a new week. Need to initialize it:
		local p = previous_week(w)
		if data.weekly_pushes[p] then -- Last week exists. Check conditions for falling:
			if data.weekly_pushes[p] >= data.weekly_slope[p] then -- Last week was successful
				data.weekly_slope[w] = data.weekly_slope[p] + 1
				data.slope = data.slope + 1
				data.weekly_pushes[w] = 0
			else -- Last week failed.
				data.weekly_slope[w] = 1 -- Starting slope.
				data.weekly_pushes[w] = 1 -- Counting the current push.
				data.height = 1
				data.slope = 1
			end
		else -- First week ever.
			data.weekly_pushes[w] = 1
			data.weekly_slope[w] = 1
		end
	end
end

Banner:add_processor("push", function(self, e)
	local w = unix_to_week(e.when)
	maybe_start_week(self, w)

	self.height = self.height + 1
	self.weekly_pushes[w] = self.weekly_pushes[w] + 1

	-- Update the known maxima
	self.max_height = math.max(self.height, self.max_height)
	self.max_slope = math.max(self.slope, self.max_slope)
end)

Banner:add_processor("report", function(self, e)
	local w = unix_to_week(e.when)
	maybe_start_week(self, w)

	self.height = e.height
	self.slope = e.slope
end)

function Banner:render(out)
	maybe_start_week(self, unix_to_week(os.time()))
	local template = [[

            #####     _/
           #######   /
          #########  /
         |#########_/                 The Boulder
        /  #######/                      is at %d
       /_   #####/                     Its Slope is %d
      / /O_/   /
      | /_    /                 It has been at %d
      /_/\.  /                  Moving as fast as %d
     //  // _/
    /‘  /‘_/
   /  __`/
   `_/
   /

]]

	out:write(string.format(template, self.height, self.slope, self.max_height, self.max_slope))

end

Banner:add_field("height", function(self)
	maybe_start_week(self, unix_to_week(os.time()))
	return self.height
end)

Banner:add_field("slope", function(self)
	maybe_start_week(self, unix_to_week(os.time()))
	return self.slope
end)

return Banner
