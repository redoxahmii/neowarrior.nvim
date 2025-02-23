local Task = require("neowarrior.Task")
local TaskCollection = require("neowarrior.TaskCollection")

---@class Taskwarrior
---@field last_cmd string
---@field syscall fun(self: Taskwarrior, cmd: string[]): string
local Taskwarrior = {}

--- Create new taskwarrior instance
---@return Taskwarrior
function Taskwarrior:new()
  local taskwarrior = {}
  setmetatable(taskwarrior, self)
  self.__index = self

  taskwarrior.last_cmd = nil

  return taskwarrior
end

--- Execute system call
---@param cmd table
---@return string
function Taskwarrior:syscall(cmd)
  local result = vim.fn.system(table.concat(cmd, " "))
  self.last_cmd = table.concat(cmd, " ")
  return result
end

--- Get single task by UUID
---@param uuid string
---@return Task
function Taskwarrior:task(uuid)

  local json_data = self:syscall({ "task", uuid, "export" })
  local task = vim.json.decode(json_data)

  return Task:new(task[1])
end

--- Get tasks
---@param report string
---@param filter string
---@return TaskCollection
function Taskwarrior:tasks(report, filter)

  local default_limit = "limit:1000000"

  if filter and string.find(filter, "limit:") then
    default_limit = ""
  end
  local cmd = { "task", default_limit, "export", report }

  if filter then
    cmd = { "task", default_limit, filter, "export", report }
  end

  local json_data = self:syscall(cmd)
  local data = vim.json.decode(json_data:match("%b[]"))
  local task_collection = TaskCollection:new()

  --- NOTE: We use the constructor of Task here (instead of perhaps
  --- a task_collection:set method) to parse and process some
  --- of the data, like dates etc.
  --- TODO: Make set method that can handle all that jazz too
  for _, task in ipairs(data) do
    task_collection:add(Task:new(task))
  end

  return task_collection
end

--- Add new task
---@param input string
function Taskwarrior:add(input)
  self:syscall({ "task", "add", input })
end
---
--- Modify task
---@param task Task
---@param mod_string string
function Taskwarrior:modify(task, mod_string)
  if not (mod_string == "") then
    self:syscall({ "task", "modify", task.uuid, mod_string })
  end
end
--
-- Add dependency
---@param task Task
---@param dependency_uuid string
function Taskwarrior:add_dependency(task, dependency_uuid)
  self:syscall({ "task", task.uuid, "modify", "depends:" .. dependency_uuid })
end

--- Start task
---@param task Task
---@return Task
function Taskwarrior:start(task)
  self:syscall({ "task", "start", task.uuid })
  return Taskwarrior:task(task.uuid)
end

--- Stop task
---@param task Task
function Taskwarrior:stop(task)
  self:syscall({ "task", "stop", task.uuid })
  return Taskwarrior:task(task.uuid)
end

--- Annotate task
---@param task Task
---@param annotation string
function Taskwarrior:annotate(task, annotation)
  self:syscall({ "task", "annotate", task.uuid, annotation })
end

--- Complete task / mark done
---@param task Task
function Taskwarrior:done(task)
  self:syscall({ "task", "done", task.uuid })
end

--- Mark task as undone
---@param task Task
function Taskwarrior:undone(task)
  self:modify(task, "status:pending")
end

--- Delete task
---@param task Task 
function Taskwarrior:delete(task)
  self:syscall({ "task", "delete", task.uuid, "rc.confirmation=off" })
end

return Taskwarrior
