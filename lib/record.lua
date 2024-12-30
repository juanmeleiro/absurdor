local record = {}

record.push = function(f, args, log)
	f:write(string.format("%s pushed the boulder at %s\n", args.who, os.date("!%Y-%m-%d %H:%M %z", args.when)))
	table.insert(log, {
					 when = args.when,
					 what = "push",
					 who = args.who,
					 where = args.where
	})
end

record.transfer = function(f, args, log)
	f:write(string.format("%s transfered the Veblen to emself for %d spendies.\n", args.who, args.payed))
	table.insert(log, {
		when = args.when,
		what = "transfer",
		who = args.who,
		where = args.where,
		payed = args.payed
	})
end

record.devalue = function(f, args, log)
	f:write(string.format("%s devalued the Veblen to %d spendies.\n", args.who, args.value))
	table.insert(log, {
		when = args.when,
		what = "devalue",
		who = args.who,
		where = args.where,
		value = args.value
	})
end

return record
