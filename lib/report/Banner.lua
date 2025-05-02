local Module = require "lib/report/Module"

local Banner = Module:new({
	height = 0,
	slope = 1,
	max_height = 0,
	max_slope = 1
})

Banner:add_processor("push", function(self, e)
	self.height = self.height + 1
	self.max_height = math.max(self.height, self.max_height)
	self.max_slope = math.max(self.slope, self.max_slope)
end)

Banner:add_processor("report", function(self, e)
	self.height = e.height
	self.slope = e.slope
end)

function Banner:render(out)
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
	return self.height
end)

Banner:add_field("slope", function(self)
	return self.slope
end)

return Banner
