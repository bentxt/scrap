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
local outputAndFlush_4486328, tmp_4486379
do
  local tmp_4485842 = _G.io
  local tmp_4486297 = tmp_4485842.stdout
  _id(string.byte)
  _id(string.sub)
  local tmp_4486309 = table.concat
  local Io__tag_4486324 = {"Io"}
  local BlockingNotSupported__tag_4486325 = {"BlockingNotSupported"}
  local BlockingNotSupported_4486326 = {tag = BlockingNotSupported__tag_4486325}
  local LINE__BUF_4486327 = "LINE_BUF"
  outputAndFlush_4486328 = function(tmp_4486330, content_4486329)
    do
      local tmp_4486332 = tmp_4486330.tag
      local tmp_4486333 = tmp_4486332 == "LUA_WRITABLE"
      if tmp_4486333 then
        goto then_4486395
      else
        goto else_4486396
      end
    end
    ::then_4486395::
    do
      local name_4486337, tmp_4486338
      do
        local tmp_4486334 = tmp_4486330.payload
        local writable_4486335 = tmp_4486334.writable
        local tmp_4486336 = tmp_4486330.payload
        name_4486337 = tmp_4486336.name
        local tmp_4486339
        tmp_4486339, tmp_4486338 = writable_4486335:write(content_4486329)
        local tmp_4486340 = not tmp_4486339
        if tmp_4486340 then
          goto then_4486397
        else
          writable_4486335:flush()
          return nil
        end
      end
      ::then_4486397::
      do
        local tmp_4486341 = _Fail(tmp_4486338)
        local tmp_4486342 = {cause = tmp_4486341, ["function"] = "output", name = name_4486337}
        local tmp_4486343 = {tag = Io__tag_4486324, payload = tmp_4486342}
        _raise(tmp_4486343, "text-io.sml:290:43")
      end
    end
    ::else_4486396::
    do
      local tmp_4486345 = tmp_4486330.tag
      local tmp_4486346 = tmp_4486345 == "PRIM_WRITER"
      if tmp_4486346 then
        goto then_4486398
      else
        _raise(_Match, "text-io.sml:392:9")
      end
    end
    ::then_4486398::
    do
      local name_4486350, writeVec_4486354, buffer_4486356, tmp_4486359
      do
        local tmp_4486347 = tmp_4486330.payload
        local tmp_4486348 = tmp_4486347.writer
        local tmp_4486349 = tmp_4486348
        name_4486350 = tmp_4486349.name
        local tmp_4486351 = tmp_4486330.payload
        local tmp_4486352 = tmp_4486351.writer
        local tmp_4486353 = tmp_4486352
        writeVec_4486354 = tmp_4486353.writeVec
        local tmp_4486355 = tmp_4486330.payload
        buffer_4486356 = tmp_4486355.buffer
        local x_4486357 = buffer_4486356[1]
        local tmp_4486358 = {content_4486329, x_4486357}
        do
          local tmp_4486399, tmp_4486400 = tmp_4486358, nil
          ::cont_4486385::
          do
            local tmp_4486387, ys_4486386 = tmp_4486399, tmp_4486400
            local tmp_4486388 = tmp_4486387 == nil
            if tmp_4486388 then
              tmp_4486359 = ys_4486386
              goto cont_4486375
            end
            local tmp_4486389 = tmp_4486387 == nil
            local tmp_4486390 = not tmp_4486389
            if tmp_4486390 then
              local tmp_4486391 = tmp_4486387[1]
              local tmp_4486392 = tmp_4486387[2]
              local tmp_4486393 = {tmp_4486391, ys_4486386}
              tmp_4486399 = tmp_4486392
              tmp_4486400 = tmp_4486393
              goto cont_4486385
            else
              _raise(_Match, "list.sml:60:5")
            end
          end
        end
      end
      ::cont_4486375::
      local content_PRIME_4486360
      do
        local tmp_4486372 = _VectorOrArray_fromList(tmp_4486359)
        local tmp_4486373 = tmp_4486309(tmp_4486372)
        content_PRIME_4486360 = tmp_4486373
      end
      ::cont_4486371::
      do
        local tmp_4486361 = writeVec_4486354.tag
        local tmp_4486362 = tmp_4486361 == "SOME"
        if tmp_4486362 then
          goto then_4486401
        else
          goto else_4486402
        end
      end
      ::then_4486401::
      do
        local writeVec_4486363 = writeVec_4486354.payload
        local tmp_4486364 = #content_PRIME_4486360
        local tmp_4486365 = {base = content_PRIME_4486360, length = tmp_4486364, start = 0}
        local tmp_4486403 = writeVec_4486363(tmp_4486365)
        buffer_4486356[1] = nil
        return nil
      end
      ::else_4486402::
      local tmp_4486367 = writeVec_4486354.tag
      local tmp_4486368 = tmp_4486367 == "NONE"
      if tmp_4486368 then
        local tmp_4486369 = {cause = BlockingNotSupported_4486326, ["function"] = "output", name = name_4486350}
        local tmp_4486370 = {tag = Io__tag_4486324, payload = tmp_4486369}
        _raise(tmp_4486370, "text-io.sml:397:26")
      else
        _raise(_Match, "text-io.sml:395:14")
      end
    end
  end
  local tmp_4486377 = {LINE__BUF_4486327}
  local tmp_4486378 = {buffer_mode = tmp_4486377, name = "<stdout>", writable = tmp_4486297}
  tmp_4486379 = {tag = "LUA_WRITABLE", payload = tmp_4486378}
  local tmp_4486404 = outputAndFlush_4486328(tmp_4486379, "hellollll\n")
end
local tmp_4486405 = outputAndFlush_4486328(tmp_4486379, "hellollll\n")
