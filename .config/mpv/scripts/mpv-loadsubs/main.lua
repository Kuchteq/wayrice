function load_subtitles()
    local target_path = "/tmp/" .. mp.get_property("media-title") .. "." .. os.clock() .. ".target";
     mp.command_native({
             name = "subprocess",
             args = { "foot", "-W", "120x36", '-a', 'floatermid', "lf",  "-selection-path", target_path},
     })

     local file = io.open(target_path, "r")
     if file then
             local output = file:read("*a")
             file:close()
             os.remove(target_path)
             mp.commandv("sub_add", output)
     end
end

mp.add_key_binding("Ctrl+s", "cut", load_subtitles)
