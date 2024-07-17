local _G = _G
local error = error
local setmetatable = setmetatable
local string = string
local string_format = string.format
local table = table
local function _id(x)
  return x
end
local _exn_meta = {}
function _exn_meta:__tostring()
  local traceback = self.traceback
  if traceback then
    traceback = "\n" .. traceback
  else
    traceback = ""
  end
  return string_format("%s: %s%s", self.location or "<no location info>", self.tag[1], traceback)
end
local _Fail_tag = { "Fail" }
local function _Fail(message)
  return setmetatable({ tag = _Fail_tag, payload = message }, _exn_meta)
end
local _Error_tag = { "Error" }
local function _raise(x, location)
  local e
  if x.tag == _Error_tag then
    e = x.payload
  elseif location ~= nil then
    local traceback = debug.traceback(nil, 2)
    e = setmetatable({ tag = x.tag, payload = x.payload, location = location, traceback = traceback }, _exn_meta)
  else
    e = x
  end
  error(e, 1)
end
local Io__tag_4487054, tmp_4487069
do
  local tmp_4486579 = _G.io
  local tmp_4487027 = tmp_4486579.stdout
  _id(string.byte)
  _id(string.sub)
  _id(table.concat)
  Io__tag_4487054 = {"Io"}
  local tmp_4487070
  tmp_4487070, tmp_4487069 = tmp_4487027:write("quuuuu")
  local tmp_4487071 = not tmp_4487070
  if tmp_4487071 then
    goto then_4487117
  else
    tmp_4487027:flush()
    return
  end
end
::then_4487117::
do
  local tmp_4487072 = _Fail(tmp_4487069)
  local tmp_4487073 = {cause = tmp_4487072, ["function"] = "output", name = "<stdout>"}
  local tmp_4487074 = {tag = Io__tag_4487054, payload = tmp_4487073}
  _raise(tmp_4487074, "text-io.sml:290:43")
end
