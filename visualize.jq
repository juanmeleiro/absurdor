# Visualize the log in a prettier format
# Usage: jq -r -f visualize.jq log.json

.[] |
(.when | strftime("%Y-%m-%d %H:%M")) as $date |
"[\($date)] " +
if   .what == "push" then
	"Push by \(.who)"
elif .what == "report" then
	"Report"
elif .what == "devalue" then
	"Devalue by \(.who) to \(.value)"
elif .what == "transfer" then
	"Transfer to \(.who) for \(.payed)"
else
	"IMPOSSIBLE"
end
