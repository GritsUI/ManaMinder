function ManaMinder:Lerp(a, b, t)
  return (1 - t) * a + t * b
end

function ManaMinder:EaseInOutQuad(a, b, t, d)
  local c = b - a
  t = (t * d) / (d / 2)
  if t < 1 then
    return c/2*t*t + a
  end

  t = t - 1
  return -c/2 * (t*(t-2) - 1) + a
end

function ManaMinder:Splice(tbl, first, length)
  local spliced = {}

  for i = 1, table.getn(tbl), 1 do
    if i < first or i >= first + length then
      table.insert(spliced, tbl[i])
    end
  end

  return spliced
end

function ManaMinder:SecondsToRelativeTime(seconds)
  local m = math.floor((seconds + 0.5) / 60)
  local s = math.floor((seconds - m * 60) + 0.5)
  local rel = ""

  if m > 0 then
    rel = m .. ":"
  end
  if m > 0 and s < 10 then
    rel = rel .. "0"
  end
  rel = rel .. s

  return rel
end

function ManaMinder:RoundTo(num, decimalPlaces)
  return tonumber(string.format("%." .. (decimalPlaces or 0) .. "f", num))
end
