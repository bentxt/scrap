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
local _Match_tag = { "Match" }
local _Match = setmetatable({ tag = _Match_tag }, _exn_meta)
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
local function _VectorOrArray_fromList(xs)
  local t = {}
  local n = 0
  while xs ~= nil do
    n = n + 1
    t[n] = xs[1]
    xs = xs[2]
  end
  t.n = n
  return t
end
local outputAndFlush_4490396, tmp_4490447
do
  local tmp_4489910 = _G.io
  local tmp_4490365 = tmp_4489910.stdout
  _id(string.byte)
  _id(string.sub)
  local tmp_4490377 = table.concat
  local Io__tag_4490392 = {"Io"}
  local BlockingNotSupported__tag_4490393 = {"BlockingNotSupported"}
  local BlockingNotSupported_4490394 = {tag = BlockingNotSupported__tag_4490393}
  local LINE__BUF_4490395 = "LINE_BUF"
  outputAndFlush_4490396 = function(tmp_4490398, content_4490397)
    do
      local tmp_4490400 = tmp_4490398.tag
      local tmp_4490401 = tmp_4490400 == "LUA_WRITABLE"
      if tmp_4490401 then
        goto then_4490463
      else
        goto else_4490464
      end
    end
    ::then_4490463::
    do
      local name_4490405, tmp_4490406
      do
        local tmp_4490402 = tmp_4490398.payload
        local writable_4490403 = tmp_4490402.writable
        local tmp_4490404 = tmp_4490398.payload
        name_4490405 = tmp_4490404.name
        local tmp_4490407
        tmp_4490407, tmp_4490406 = writable_4490403:write(content_4490397)
        local tmp_4490408 = not tmp_4490407
        if tmp_4490408 then
          goto then_4490465
        else
          writable_4490403:flush()
          return nil
        end
      end
      ::then_4490465::
      do
        local tmp_4490409 = _Fail(tmp_4490406)
        local tmp_4490410 = {cause = tmp_4490409, ["function"] = "output", name = name_4490405}
        local tmp_4490411 = {tag = Io__tag_4490392, payload = tmp_4490410}
        _raise(tmp_4490411, "text-io.sml:290:43")
      end
    end
    ::else_4490464::
    do
      local tmp_4490413 = tmp_4490398.tag
      local tmp_4490414 = tmp_4490413 == "PRIM_WRITER"
      if tmp_4490414 then
        goto then_4490466
      else
        _raise(_Match, "text-io.sml:392:9")
      end
    end
    ::then_4490466::
    do
      local name_4490418, writeVec_4490422, buffer_4490424, tmp_4490427
      do
        local tmp_4490415 = tmp_4490398.payload
        local tmp_4490416 = tmp_4490415.writer
        local tmp_4490417 = tmp_4490416
        name_4490418 = tmp_4490417.name
        local tmp_4490419 = tmp_4490398.payload
        local tmp_4490420 = tmp_4490419.writer
        local tmp_4490421 = tmp_4490420
        writeVec_4490422 = tmp_4490421.writeVec
        local tmp_4490423 = tmp_4490398.payload
        buffer_4490424 = tmp_4490423.buffer
        local x_4490425 = buffer_4490424[1]
        local tmp_4490426 = {content_4490397, x_4490425}
        do
          local tmp_4490467, tmp_4490468 = tmp_4490426, nil
          ::cont_4490453::
          do
            local tmp_4490455, ys_4490454 = tmp_4490467, tmp_4490468
            local tmp_4490456 = tmp_4490455 == nil
            if tmp_4490456 then
              tmp_4490427 = ys_4490454
              goto cont_4490443
            end
            local tmp_4490457 = tmp_4490455 == nil
            local tmp_4490458 = not tmp_4490457
            if tmp_4490458 then
              local tmp_4490459 = tmp_4490455[1]
              local tmp_4490460 = tmp_4490455[2]
              local tmp_4490461 = {tmp_4490459, ys_4490454}
              tmp_4490467 = tmp_4490460
              tmp_4490468 = tmp_4490461
              goto cont_4490453
            else
              _raise(_Match, "list.sml:60:5")
            end
          end
        end
      end
      ::cont_4490443::
      local content_PRIME_4490428
      do
        local tmp_4490440 = _VectorOrArray_fromList(tmp_4490427)
        local tmp_4490441 = tmp_4490377(tmp_4490440)
        content_PRIME_4490428 = tmp_4490441
      end
      ::cont_4490439::
      do
        local tmp_4490429 = writeVec_4490422.tag
        local tmp_4490430 = tmp_4490429 == "SOME"
        if tmp_4490430 then
          goto then_4490469
        else
          goto else_4490470
        end
      end
      ::then_4490469::
      do
        local writeVec_4490431 = writeVec_4490422.payload
        local tmp_4490432 = #content_PRIME_4490428
        local tmp_4490433 = {base = content_PRIME_4490428, length = tmp_4490432, start = 0}
        local tmp_4490471 = writeVec_4490431(tmp_4490433)
        buffer_4490424[1] = nil
        return nil
      end
      ::else_4490470::
      local tmp_4490435 = writeVec_4490422.tag
      local tmp_4490436 = tmp_4490435 == "NONE"
      if tmp_4490436 then
        local tmp_4490437 = {cause = BlockingNotSupported_4490394, ["function"] = "output", name = name_4490418}
        local tmp_4490438 = {tag = Io__tag_4490392, payload = tmp_4490437}
        _raise(tmp_4490438, "text-io.sml:397:26")
      else
        _raise(_Match, "text-io.sml:395:14")
      end
    end
  end
  local tmp_4490445 = {LINE__BUF_4490395}
  local tmp_4490446 = {buffer_mode = tmp_4490445, name = "<stdout>", writable = tmp_4490365}
  tmp_4490447 = {tag = "LUA_WRITABLE", payload = tmp_4490446}
  local tmp_4490472 = outputAndFlush_4490396(tmp_4490447, "hellollll\n")
end
local tmp_4490473 = outputAndFlush_4490396(tmp_4490447, "hellollll\n")
