local Module = require "lib/report/Module"

Mail = Module:new()

function Mail:render(out)
	local template = [[
Date: %s
To: agora-official@agoranomic.org
From: juan <juan@juanmeleiro.mat.br>
Subject: [Absurdor] The State of the Absurd (%s)

]]
	out:write(string.format(template, os.date("%a,%e %b %Y %H:%M:%H %z"), os.date("%Yw%U")))
end

return Mail
