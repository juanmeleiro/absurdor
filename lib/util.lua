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

function unix_to_week(s)
	return os.date("%GW%V", s)
end

function year_ending_weekday(y)
	return (y + math.floor(y/4) - math.floor(y/100) + math.floor(y/400)) % 7
end

function weeks_in_year(y)
	if year_ending_weekday(y) == 4 or year_ending_weekday(y-1) == 3 then
		return 53
	else
		return 52
	end
end

function parse_week(w)
	return string.match(w, "(%d+)W(%d+)")
end

function format_week(y, w)
	return string.format("%dW%d", y, w)
end

function previous_week(w)
	local year, week = parse_week(w)
	if week == 1 then
		return format_week(year - 1, weeks_in_year(year - 1))
	else
		return format_week(year, week - 1)
	end
end
