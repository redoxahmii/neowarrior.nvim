local date = require('tieske.date')

---@class DateTime
---@field date string
---@field year number?
---@field month number?
---@field day number?
---@field hour number?
---@field minute number?
---@field second number?
---@field timestamp number?
---@field offset number
---@field new fun(self: DateTime, date: string|nil): DateTime
---@field parse fun(self: DateTime, str: string|nil): number
---@field format fun(self: DateTime, format: string): string|osdate
---@field default_format fun(self: DateTime): string|osdate
---@field relative fun(self: DateTime): string
local DateTime = {}

--- Create new datetime
---@param input string|nil
---@return DateTime
function DateTime:new(input)

  local datetime = {}
  setmetatable(datetime, self)

  self.__index = self

  datetime.date = date(input)

  return datetime
end

function DateTime:copy()
  return DateTime:new(self.date)
end

--- Add time to date
---@param unit "years"|"months"|"days"|"hours"|"minutes"|"seconds"
---@param value 
function DateTime:add(unit, value)

  if unit == "years" then
    self.date:addyears(value)
  elseif unit == "months" then
    self.date:addmonths(value)
  elseif unit == "days" then
    self.date:adddays(value)
  elseif unit == "hours" then
    self.date:addhours(value)
  elseif unit == "minutes" then
    self.date:addminutes(value)
  elseif unit == "seconds" then
    self.date:addseconds(value)
  end

  return self
end

function DateTime:set(values)

    if values.year then self.date:setyear(values.year) end
    if values.month then self.date:setmonth(values.month) end
    if values.day then self.date:setday(values.day) end
    if values.hour then self.date:sethours(values.hour) end
    if values.minute then self.date:setminutes(values.minute) end
    if values.second then self.date:setseconds(values.second) end

    return self
end

function DateTime:weekday()
  return self.date:getweekday()
end

--- Format date
---@param format string
---@return string|osdate
function DateTime:format(format)
  return self.date:fmt(format)
end

--- Get default formatted date
---@return string|osdate
function DateTime:default_format()
  return self:format('%Y-%m-%d, %H:%M')
end

--- Function to calculate the time difference
---@return number Diff in seconds
function DateTime:diff()
  local now = DateTime:new(nil)
  return date.diff(self.date, now.date):spanseconds()
end

--- Function to calculate the time difference
---@return dateObject
function DateTime:diff_object()
  local now = DateTime:new(nil)
  return date.diff(self.date, now.date)
end

-- Function to calculate the relative time difference
---@return string
function DateTime:relative()

  local diff = self:diff_object()
  local years = math.floor(diff:spandays()) and math.floor(diff:spandays() / 365) or 0
  local months = math.floor(diff:spandays()) and math.floor(diff:spandays() / 30) or 0
  local days = math.floor(diff:spandays()) and math.floor(diff:spandays()) or 0
  local hours = math.floor(diff:spanhours()) and math.floor(diff:spanhours()) or 0
  local minutes = math.floor(diff:spanminutes()) and math.floor(diff:spanminutes()) or 0
  local seconds = diff:spanseconds()

  if years >= 1 or years < 0 then
    return years .. "y"
  end

  if months >= 1 or months < 0 then
    return months .. "mon"
  end

  if days >= 1 or days < 0 then
    return days .. "d"
  end

  if hours >= 1 or hours < 0 then
    return hours .. "h"
  end

  if minutes >= 1 or minutes < 0 then
    return minutes .. "m"
  end

  return seconds .. "s"

end

--- Get relative hours
--- @return number
function DateTime:relative_hours()
  local diff = self:diff_object()
  return diff:spanhours()
end

return DateTime
