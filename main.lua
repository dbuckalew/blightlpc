local mod = {}
local code_dir = os.getenv("PWD")
local fh = nil

function mod.set_dir(dir)
	code_dir = dir
end

local function file_exists(file)
	local f = io.open(file)
	if f then
		f:close()
		return true
	else
		return false
	end
end

local save_line = trigger.add("(.*)", {gag=true, raw=true, enabled=false}, function(m, ln)
	-- fh:write(m)
	if ln and string.sub(ln:raw(), 1,1) ~= ":" then
		fh:write(ln:raw() .. "\n")
		print("LINE" .. ln:raw())
	else
		print("NO LINE?")
	end
end)

local start_save = trigger.add("^:", {gag=true, enabled=false}, function(m, ln)
	save_line:enable()
end)

local ed_quit = trigger.add("Exit from ed", {gag=true, enabled=false}, function(m, ln)
	save_line:disable()
	fh:close()
	print("CLOSED FILE ")
	fh = nil
end)

local actions = {
	["send"] = function (x) 
		print("SEND ".. x) 
		local file = assert(io.open(code_dir .. "/" .. x), "r")
		local line = file:read("*line")
		mud.send("ed " .. x, {gag=true})
		mud.send("1,$d", {gag=true})
		mud.send("a", {gag=true})
		while line do
			mud.send(line .. "\n", {gag=true})
			line = file:read("*line")
		end
		mud.send(".", {gag=true})
		mud.send("I", {gag=true})
		mud.send("w", {gag=true})
		mud.send("q", {gag=true})
	end,
	["get"] = function (x) 
		print("GET ".. x) 
		fh = io.open(code_dir .. "/" .. x, "w")
		mud.send("ed " .. x, {gag=true})
		start_save:enable()
		ed_quit:enable()
		mud.send("1,$p", {gag=true})
		mud.send("q", {gag=true})
	end,
	["pwd"] = function (x) print ("PWD " .. code_dir) end,
	["cd"] = function (x) 
		if x then
	  	code_dir = x
	  end
		print ("CD " .. x) 
	end,
}

alias.add("^/lpc (.*)$",
  function (subcommand)
		if not subcommand[2] then
			return false
		end
		_, _, cmd, args = subcommand[2]:find("(%a+) (.*)")
		if not cmd then
			_, _, cmd = subcommand[2]:find("(%a+)")
			args = ""
		end

		if actions[cmd] then
			actions[cmd](args)
  	end
	end
)


return mod
