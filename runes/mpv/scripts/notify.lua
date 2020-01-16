-- notify.lua -- Desktop notifications for mpv.
-- Just put this file into your ~/.config/mpv/scripts folder and mpv will find it.
--
-- Copyright (c) 2014 Roland Hieber
-- (Also some minor edits from Arindam Das)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

-------------------------------------------------------------------------------
-- helper functions
-------------------------------------------------------------------------------

function print_debug(s)
    print("DEBUG: " .. s) -- comment out for no debug info
    return true
end

-- url-escape a string, per RFC 2396, Section 2
function string.urlescape(str)
    local s, c = string.gsub(str, "([^A-Za-z0-9_.!~*'()/-])",
    function(c)
        return ("%%%02x"):format(c:byte())
    end)
    return s;
end

-- escape string for html
function string.htmlescape(str)
    local str = string.gsub(str, "<", "&lt;")
    str = string.gsub(str, ">", "&gt;")
    str = string.gsub(str, "&", "&amp;")
    str = string.gsub(str, "\"", "&quot;")
    str = string.gsub(str, "'", "&apos;")
    return str
end

-- escape string for shell inclusion
function string.shellescape(str)
    return "'"..string.gsub(str, "'", "'\"'\"'").."'"
end

-- converts string to a valid filename on most (modern) filesystems
function string.safe_filename(str)
    local s, _ = string.gsub(str, "([^A-Za-z0-9_.-])",
    function(c)
        return ("%02x"):format(c:byte())
    end)
    return s;
end

-------------------------------------------------------------------------------
-- here we go.
-------------------------------------------------------------------------------

-- scale an image file
-- @return boolean of success
function scaled_image(src, dst)
    local convert_cmd = ("convert -scale x64 -- %s %s"):format(
    string.shellescape(src), string.shellescape(dst))
    print_debug("executing " .. convert_cmd)
    if os.execute(convert_cmd) then
        return true
    end
    return false
end

-- extract image from audio file
function extracted_image_from_audiofile (audiofile, imagedst)
    local ffmpeg_cmd = ("ffmpeg -loglevel error -hide_banner -vsync 2 -i %s %s > /dev/null"):format(
    string.shellescape(audiofile), string.shellescape(imagedst)
    )
    print_debug("executing " .. ffmpeg_cmd)
    os.execute(ffmpeg_cmd)
    return true
end

function get_value(data, keys)
    for _,v in pairs(keys) do
        if data[v] and string.len(data[v]) > 0 then
            return data[v]
        end
    end
    return ""
end

COVER_ART_PATH = "/tmp/covert_art.jpg"
ICON_PATH = "/tmp/icon.jpg"

function notify_current_track()
    os.remove(COVER_ART_PATH)
    os.remove(ICON_PATH)

    local metadata = mp.get_property_native("metadata")

    -- track doesn't contain metadata
    if not metadata then
        return
    end

    -- we try to fetch metadata values using all possible keys
    local artist = get_value(metadata, {"artist", "ARTIST"})
    local album  = get_value(metadata, {"album", "ALBUM"})
    local title  = get_value(metadata, {"title", "TITLE", "icy-title"})

    print_debug("notify_current_track(): -> extracted metadata:")
    print_debug("artist: " .. artist)
    print_debug("album: " .. album)
    print_debug("title: " .. title)

    -- absolute filename of currently playing audio file
    local path_to_file = mp.get_property_native("path")
    local abs_filename
    if path_to_file:find("^/") ~= nil then
        abs_filename = path_to_file
    else
        abs_filename = os.getenv("PWD") .. "/" .. mp.get_property_native("path")
    end

    params = ""
    -- extract cover art: set it as icon in notification params
    if extracted_image_from_audiofile(abs_filename, COVER_ART_PATH) then
        if scaled_image(COVER_ART_PATH, ICON_PATH) then
            params = "-i " .. ICON_PATH
        end
    end

    -- form notification summary
    summary_str ="Now playing:"
    if (string.len(artist) > 0) then
        summary_str = string.htmlescape(artist)
    end
    summary = string.shellescape(summary_str)

    body_str = mp.get_property_native("filename")
    if (string.len(title) > 0) then
        if (string.len(album) > 0) then
            body_str = ("%s<br /><i>%s</i>"):format(
            string.htmlescape(title), string.htmlescape(album))
        else
            body_str = string.htmlescape(title)
        end
    end

    body = string.shellescape(body_str)

    local command = ("notify-send -a mpv %s -- %s %s"):format(params, summary, body)
    print_debug("command: " .. command)
    os.execute(command)
end

function notify_metadata_updated(name, data)
    notify_current_track()
end

function update_panel()
    local update_panel = ("pkill -10 -x lemon")
    print("executing command: " .. update_panel)
    os.execute(update_panel)
end

-- insert main() here

mp.register_event("file-loaded", update_panel)
-- mp.observe_property("metadata", nil, notify_metadata_updated)
