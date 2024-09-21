local colors = require "neowarrior.colors"
local Line = require "neowarrior.Line"

---@class ProjectLine
---@field neowarrior NeoWarrior
---@field line_no number
---@field project Project
---@field arg table
local ProjectLine = {}

--- Create a new ProjectLine
---@param neowarrior NeoWarrior
---@param tram Trambampolin
---@param project Project
---@return ProjectLine
function ProjectLine:new(neowarrior, tram, project)
    local project_component = {}
    setmetatable(project_component, self)
    self.__index = self

    self.neowarrior = neowarrior
    self.tram = tram
    self.project = project

    return self
end

--- Get project line data
---@param arg table
---@return Line[]
function ProjectLine:into_line(arg)

  local conf = self.neowarrior.config
  local indent = arg.indent or ""
  local open = arg.open or false
  local icon = open and conf.icons.project_open or conf.icons.project
  local icon_alt = conf.icons.project_alt
  local name = self.project.name
  local disable_meta = arg.disable_meta or false
  local meta = arg.meta or { project = self.project.id }
  if disable_meta then meta = nil end

  if arg.id_as_name then
    name = self.project.id
  end
  name = string.gsub(name, "%.", " " .. icon_alt .. " ")
  self.tram:col(indent .. icon .. " " .. name, "NeoWarriorTextInfo")

  local task_count = self.project.task_count
  if arg.enable_task_count == "eol" and task_count > 0 then
    self.tram:col(" " .. conf.icons.task .. " " .. task_count, "NeoWarriorTextDefault")
  end

  local total_estimate = self.project.estimate.total
  if arg.enable_total_estimate == "eol" and total_estimate > 0 then
    self.tram:col(
      " " .. conf.icons.est .. " " .. string.format("%.1f", total_estimate) .. "h",
      colors.get_urgency_color(total_estimate)
    )
  end

  if arg.enable_average_urgency == "eol" then
    self.tram:col(
      " " .. string.format("%.2f", self.project.urgency.average),
      colors.get_urgency_color(self.project.urgency.average)
    )
  end

  if arg.enable_total_urgency == "eol" then
    self.tram:col(
      " " .. string.format("%.2f", self.project.urgency.total),
      colors.get_urgency_color(self.project.urgency.total)
    )
  end

  self.tram:into_line({
    meta = meta,
  })

  local has_right_aligned_items = false
  if arg.enable_task_count == "right" and task_count > 0 then
    self.tram:col(" " .. conf.icons.task .. " " .. task_count, "NeoWarriorTextDefault")
    has_right_aligned_items = true
  end

  if arg.enable_total_estimate == "right" and total_estimate > 0 then
    self.tram:col(
      " " .. conf.icons.est .. " " .. string.format("%.1f", total_estimate) .. "h",
      colors.get_urgency_color(total_estimate)
    )
    has_right_aligned_items = true
  end

  if arg.enable_average_urgency == "right" then
    self.tram:col(
      " " .. string.format("%.2f", self.project.urgency.average),
      colors.get_urgency_color(self.project.urgency.average)
    )
    has_right_aligned_items = true
  end

  if arg.enable_total_urgency == "right" then
    self.tram:col(
      " " .. string.format("%.2f", self.project.urgency.total),
      colors.get_urgency_color(self.project.urgency.total)
    )
    has_right_aligned_items = true
  end

  if has_right_aligned_items then

    self.tram:into_virt_line({
      pos = "right_align"
    })

  end

  return self
end

return ProjectLine
