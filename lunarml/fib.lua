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
local _Overflow_tag = { "Overflow" }
local _Overflow = setmetatable({ tag = _Overflow_tag }, _exn_meta)
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
local MIN_INT54 = -0x20000000000000
local MAX_INT54 = 0x1fffffffffffff
local function _Int54_add(x, y)
  local z = x + y
  if (MIN_INT54 < z and z <= MAX_INT54) or (z == MIN_INT54 and x % 2 == y % 2) then
    return z
  else
    _raise(_Overflow, "Int.+")
  end
end
local function _Int54_sub(x, y)
  local z = x - y
  if (MIN_INT54 < z and z <= MAX_INT54) or (z == MIN_INT54 and x % 2 == y % 2) then
    return z
  else
    _raise(_Overflow, "Int.-")
  end
end
local tmp_4506698, tmp_4506706, Io__tag_4506729, fib_4506737, tmp_4506819
do
  local tmp_4505951 = _G.io
  tmp_4506698 = tmp_4505951.stdout
  _id(string.byte)
  tmp_4506706 = string.gsub
  _id(string.sub)
  _id(table.concat)
  Io__tag_4506729 = {"Io"}
  fib_4506737 = function(n_4506739)
    local tmp_4506741
    do
      local tmp_4506740 = n_4506739 == 0
      if tmp_4506740 then
        tmp_4506741 = true
      else
        local tmp_4506750 = n_4506739 == 1
        tmp_4506741 = tmp_4506750
      end
    end
    ::cont_4506749::
    if tmp_4506741 then
      return 1
    end
    local tmp_4506742 = _Int54_sub(n_4506739, 1)
    local tmp_4506743 = fib_4506737(tmp_4506742)
    local tmp_4506744 = _Int54_sub(n_4506739, 2)
    local tmp_4506745 = fib_4506737(tmp_4506744)
    local tmp_4506746 = _Int54_add(tmp_4506743, tmp_4506745)
    return tmp_4506746
  end
  tmp_4506819 = 0
end
::cont_4506751::
do
  local i_4506752
  do
    i_4506752 = tmp_4506819
    local tmp_4506753 = i_4506752 >= 10
    if tmp_4506753 then
      return
    end
    local tmp_4506754 = fib_4506737(i_4506752)
    local tmp_4506755 = string_format("%d", tmp_4506754)
    local tmp_4506756 = tmp_4506706(tmp_4506755, "-", "~")
    local tmp_4506757 = tmp_4506756 .. "\n"
    do
      local tmp_4506767
      do
        local tmp_4506768
        tmp_4506768, tmp_4506767 = tmp_4506698:write(tmp_4506757)
        local tmp_4506769 = not tmp_4506768
        if tmp_4506769 then
          goto then_4506820
        else
          goto cont_4506766
        end
      end
      ::then_4506820::
      do
        local tmp_4506770 = _Fail(tmp_4506767)
        local tmp_4506771 = {cause = tmp_4506770, ["function"] = "output", name = "<stdout>"}
        local tmp_4506772 = {tag = Io__tag_4506729, payload = tmp_4506771}
        _raise(tmp_4506772, "text-io.sml:290:43")
      end
    end
  end
  ::cont_4506766::
  tmp_4506698:flush()
  local tmp_4506765 = _Int54_add(i_4506752, 1)
  tmp_4506819 = tmp_4506765
  goto cont_4506751
end
