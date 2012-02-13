-- Copyright 2007-2010 Mitchell mitchell<att>caladbolg.net. See LICENSE.

local M = {}

--[[ This comment is for LuaDoc.
---
-- Text-based file browser for the textadept module.
-- Pressing the spacebar activates the item on the current line.
module('_M.textadept.file_browser')]]

local lfs = require 'lfs'
local SEP = WIN32 and '\\' or '/'

-- Returns a string of files in a given directory delimited by newlines and
-- indented by a specified amount.
-- @param dir The directory to list the contents of.
-- @param indent_level The level to indent each listing by.
local function get_listing(dir, indent_level, tabs)
  local listing = {}
  if not indent_level then indent_level = 0 end
  for file in lfs.dir(dir) do
    if not file:match('^%.%.?$') then
      if lfs.attributes(dir..SEP..file).mode == 'directory' then
        file = file..SEP
      end
      listing[#listing + 1] = file
    end
  end
  table.sort(listing)
  local indent = string.rep(tabs and '\t' or ' ', indent_level)
  return indent..table.concat(listing, '\n'..indent)
end

---
-- Displays a textual file browser for a directory.
-- @param dir Directory to show initially. The user is prompted for one if none
--   is given.
-- @name init
function M.init(dir)
  if not dir then
    dir = gui.dialog('fileselect',
                     '--title', 'Open Directory',
                     '--select-only-directories',
                     '--no-newline')
    if #dir == 0 then return end
  end
  local buffer = new_buffer()
  buffer._type = '[File Browser] - '..dir:match('^(.-)[/\\]?$')
  buffer:add_text(get_listing(dir))
  buffer:set_save_point()
  buffer.read_only = true
end

-- Expand/contract directory or open file.
events.connect('char_added', function(code)
  if not (code == 32 and (buffer._type or ''):match('^%[File Browser%]')) then
    return
  end
  local buffer = buffer

  -- Identify the root and tail of the directory path.
  local line_num = buffer:line_from_position(buffer.current_pos)
  local root = buffer._type:match('^%[File Browser%]%s%-%s(.+)$')..SEP
  local tail = buffer:get_line(line_num):match('^%s*([^\r\n]+)')
  local parts = { root, tail }

  -- Determine parent directories of the tail all the way up to the root.
  -- Subdirectories are indented.
  local indent = buffer.line_indentation[line_num]
  local level = indent
  for i = line_num, 0, -1 do
    local j = buffer.line_indentation[i]
    if j < level then
      table.insert(parts, 2, buffer:get_line(i):match('^%s*([^\r\n]+)'))
      level = j
    end
    if j == 0 then break end
  end

  -- Open/Close the directory or open the file.
  local path = table.concat(parts)
  if path:sub(-1, -1) == SEP then
    buffer.read_only = false
    if buffer.line_indentation[line_num + 1] <= indent then
      -- Show directory contents.
      buffer:line_end()
      buffer:new_line()
      buffer.line_indentation[line_num + 1] = 0
      buffer:insert_text(-1, get_listing(path, indent + buffer.indent,
                                         buffer.use_tabs))
    else
      -- Collapse directory contents.
      local s, e = buffer:position_from_line(line_num + 1), nil
      level = indent
      for i = line_num + 1, buffer.line_count do
        if buffer:get_line(i):match('^[^\r\n]') and
           buffer.line_indentation[i] <= indent then break end
        e = buffer:position_from_line(i + 1)
      end
      buffer:set_sel(s, e)
      buffer:replace_sel('')
      buffer:line_up()
    end
    buffer:set_save_point()
    buffer.read_only = true
  else
    -- Open file in a new split or other existing split.
    if #_VIEWS == 1 then
      _, new_view = view:split(true)
      gui.goto_view(_VIEWS[new_view])
    else
      for i, other_view in ipairs(_VIEWS) do
        if view ~= other_view then
          gui.goto_view(_VIEWS[other_view])
          break
        end
      end
    end
    io.open_file(path)
  end
end)

return M
