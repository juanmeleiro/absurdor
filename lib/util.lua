local date = require "date"
local path = require "path"

function die(err, msg, ...)
   msg = tostring(msg or err)
   if err then
      io.stderr:write(string.format(msg .. "\n", ...))
      os.exit(1)
   end
end

function maildate(s)
	local d = date(s)
	local sec = date.diff(d, date.epoch()):spanseconds()
	return sec
end

function yn(prompt)
	meaning = {Y = true, y = true, n = false, N = false}
	while meaning[ans] == nil do
		io.write(prompt)
		io.flush()
		ans = io.read(1)
	end
	return meaning[ans]
end

function decodewith(decoder, fn)
   die(not path.exists(fn), fn.." does not exist.")
   die(not path.isfile(fn), fn.." is not a file.")
   local f, err = io.open(fn, "r")
   die(err)
   status, res = xpcall(decoder, die, f:read("a"))
   f:close()
   die(not status, res)
   return res
end

function encodewith(encoder, fn, data)
   local f, err = io.open(fn, "w")
   die(not status, err)
   status, err = f:write(encoder(data))
   die(not status, err)
end

function format(fmt, dict, sett)
   -- A identifier is
   -- > any string of Latin letters, Arabic-Indic digits, and
   -- > underscores, not beginning with a digit and not being a reserved
   -- > word

   -- local reserved = {
   --    "and", "break", "do", "else", "elseif", "end", "false", "for",
   --    "function", "goto", "if", "in", "local", "nil", "not", "or", "repeat",
   --    "return", "then", "true", "until", "while"
   -- }
   res = fmt
   for s in string.gmatch(fmt, "%{([_a-zA-Z][._a-zA-Z0-9]*)%}") do
      local value = dict
      local pref = sett
      for k in string.gmatch(s, "([_a-zA-Z][_a-zA-Z0-9]*)") do
	 if type(value) == "table" then value = value[k] end
	 if type(pref) == "table" then pref = pref[k] end
      end
      if pref and value then string.format(pref, value) end
      res = fmt.gsub(res, "{"..s.."}", value or "nil")
   end
   return res
end

function sec2week(s)
	local d = date(s)
	d:adddays(-d:getisoweekday()+1)
	d:sethours(0,0,0,0)
	return date.diff(d, date.epoch()):spanseconds()
end

function week2sec(w)
   return w
end

function prevweek(w)
	return date.diff(date(w):adddays(-7), date.epoch()):spanseconds()
end
