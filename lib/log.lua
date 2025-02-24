require "lib.util"

function is_valid_entry(e)
	return (
		(e.what ~= nil) and
		(e.when ~= nil) and
		(e.what ~= "push" or e.who ~= nil) and
		(e.what ~= "report" or e.height ~= nil)
	)
end

function parse_jsonl(f)
	local log = {}
	for l in f:lines() do
		local e = json.decode(l)
		die(not is_valid_entry(e), string.format("Invalid log entry:\n    %s", l))
		table.insert(log, e)
	end
	return log
end

function write_jsonl(l)
	local res = ""
	for _,v in ipairs(l) do
		res = res .. json.encode(v) .. "\n"
	end
	return res
end

function fmt_event(e)
	date = os.date("!%Y-%m-%d %H:%M:%S %z", e.when)
	args = {ts = date}
	if e.what == "report" then
		if e.slope then
			fmt = "[{ts}] Reported boulder at height {height} and slope at {slope}"
		else
			fmt = "[{ts}] Reported boulder at height {height}"
		end
		args.height = e.height
		args.slope = e.slope
	elseif e.what == "push" then
		fmt = "[{ts}] {who} pushed the boulder"
		args.who = e.who
	elseif e.what == "transfer" then
		fmt = "[{ts}] {who} transfered the Veblen for {payed}"
		args.who = e.who
		args.payed= e.payed
	elseif e.what == "devalue" then
		fmt = "[{ts}] {who} devalued the Veblen to {value}"
		args.who = e.who
		args.value = e.value
	else
		die(true, "Unknown event type '%s'", e.what)
	end
	return format(fmt, args)
end

function is_duplicate(ts, log)
	for _,e in ipairs(log) do
		if e.when == ts then
			return true
		end
	end
	return false
end

