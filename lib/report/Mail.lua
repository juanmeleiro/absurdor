local Module = require "lib/report/Module"

Mail = Module:new()

function Mail:render(out)
	local template = [[
Date: %s
To: agora-official@agoranomic.org
From: juan <juan@juanmeleiro.mat.br>
Subject: [Absurdor] The State of the Absurd

]]
	out:write(string.format(template, os.date("%a,%e %b %Y %H:%M:%H %z")))
end

return Mail
