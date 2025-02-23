A simple taskwarrior plugin for NeoVim. Made this mostly for my self to have as a sidebar with my tasks inside neovim. 

![gif example v0.1.4 1](./docs/gif/neowarrior-0.1.4_1.gif)
![gif example v0.1.4 2](./docs/gif/neowarrior-0.1.4_2.gif)

# Requirements

- [Neovim >=0.10.0](https://github.com/neovim/neovim/releases/tag/v0.10.0)
- [Taskwarrior](https://taskwarrior.org/)

## Optional and/or recommended

- A nerd font is highly recommended for the icons. Se config for setting custom icons.
- [folke/noice.nvim](https://github.com/folke/noice.nvim) for a nice cmdline UI.
- [ibhagwan/fzf-lua](https://github.com/ibhagwan/fzf-lua) for a easier select experience (see [https://github.com/ibhagwan/fzf-lua/blob/main/OPTIONS.md#neovim-api](https://github.com/ibhagwan/fzf-lua/blob/main/OPTIONS.md#neovim-api))
  - Alternatively [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim).

# Features

- Add, start, modify and mark tasks done
- Filter tasks
  - Select from common filter
  - Custom filter input
- Select report
- Select dependency/parent task
- Show task details
- Task detail float (enabled on active line)
- Grouped and tree views (based on task project)
- Customizable keymaps
- Customizable reports and filters
- Customize config per directory


# Installation

## Simple setup with lazy.nvim

```lua
return {
    'duckdm/neowarrior.nvim',
    event = 'VeryLazy',
    opts = {}, --- Se config below
}
```

## Example setup with dir specific configs

```lua
{
  'duckdm/neowarrior.nvim',
  config = function()

    local nw = require('neowarrior')
    local home = vim.env.HOME
    nw.setup({
      report = "next",
      filter = "\\(due.before:2d or due: \\)",
      dir_setup = {
        {
          dir = home .. "/dev/nvim/neowarrior.nvim",
          filter = "project:neowarrior",
          mode = "tree",
          expanded = true,
        },
      }
    })
    vim.keymap.set("n", "<leader>nl", function() nw.open_left() end, { desc = "Open nwarrior on the left side" })
    vim.keymap.set("n", "<leader>nc", function() nw.open_current() end, { desc = "Open nwarrior below current buffer" })
    vim.keymap.set("n", "<leader>nb", function() nw.open_below() end, { desc = "Open nwarrior below current buffer" })
    vim.keymap.set("n", "<leader>na", function() nw.open_above() end, { desc = "Open nwarrior above current buffer" })
    vim.keymap.set("n", "<leader>nr", function() nw.open_right() end, { desc = "Open nwarrior on the right side" })
    vim.keymap.set("n", "<leader>nt", function() nw.focus() end, { desc = "Focus nwarrior" })
  end
}
```

# Available commands

| Command | Description |
| ------- | ----------- |
| `:NeoWarriorOpen` | Open NeoWarrior (default to below current buffer) |
| `:NeoWarriorOpen float` | Open NeoWarrior in a floating window |
| `:NeoWarriorOpen current` | Open NeoWarrior in current buffer |
| `:NeoWarriorOpen left` | Open NeoWarrior to the left of current window |
| `:NeoWarriorOpen right` | Open NeoWarrior to the right of current window |
| `:NeoWarriorOpen above` | Open NeoWarrior above current window |
| `:NeoWarriorOpen below` | Open NeoWarrior below current window |
| `:NeoWarriorAdd` | Add new task |
| `:NeoWarriorFilter` | Filter |
| `:NeoWarriorFilterSelect` | Select filter |
| `:NeoWarriorReport` | Select report |
| `:NeoWarriorRefresh` | Refresh tasks |

# API methods
```lua
-- Open NeoWarrior
require('neowarrior').open() --- Default, opens below buffer
require('neowarrior').open_float() --- Open in a floating window
require('neowarrior').open_left() --- Open on the left side
require('neowarrior').open_right() --- Open on the right side
require('neowarrior').open_above() --- Open above current buffer
require('neowarrior').open_below() --- Open below current buffer
require('neowarrior').open_current() --- Open in current buffer

--- Set filter
require('neowarrior').set_filter("due.before:2d and project:neowarrior")

--- Set report
require('neowarrior').set_report("next")

--- Focus NeoWarrior
require('neowarrior').focus()
```

# Default key maps

| Key | Description |
| --- | ----------- |
| ? | Help |
| q | Close NeoWarrior/Close help |
| - | - |
| a | Add task |
| x | Delete task |
| l | Show task/Activate line action |
| h | Back |
| d | Mark task done |
| S | Start task |
| MM | Modify task |
| Mp | Modify project |
| MP | Modify priority |
| Md | Modify due date |
| D | Select dependency |
| - | - |
| F | Filter tasks |
| f | Select filter |
| r | Select report |
| X | Reset filters |
| - | - |
| o | Select task sort order |
| tg | Toggle grouped view |
| tt | Toggle tree view |
| W | Collapse all trees |
| E | Expand all trees |
| Tab | Toggle tree |
| - | - |
| R | Refresh tasks |

# Default config values
```lua
{
  ---@type table UI config
  ui = {
    ---@type "telescope"|"vim" Select UI to use for selects. NOTE: This will be set to "vim" as default in the future.
    select = "telescope",
  },

  ---@type table Task line config
  --- Note: Using more than one of these on the right currently causes some
  --- visual issues, the leftmost value's color will be used for the entire right
  --- "column".
  task_line = {
    ---@type false|"left"|"right" Show warning icon colored based on urgency
    enable_warning_icon = "left",
    ---@type false|"eol"|"right" Show urgency
    enable_urgency = "eol",
    ---@type false|"left" Show task-has-recurrance indicator
    enable_recur_icon = "left",
    ---@type false|"left" Show priority (H, M, L)
    enable_priority = "left",
    ---@type false|"left" Show due date
    enable_due_date = "left",
    ---@type false|"left" Show annotations icon
    enable_annotations_icon = "left",
    ---@type false|"left" Show tags in task line
    enable_tags = false,
    ---@type false|"left" Show estimate. Note: This is not a default
    ---field in taskwarrior
    enable_estimate = "left",
  },

  ---@type table Project line config.
  ---
  --- Note: These values are not always shown (on the task detail page for
  --- instance). Set values to either false, "eol" or "right" to enable
  --- or show them at specific positions.
  ---
  --- Note: Using more than one of these on the right currently causes some
  --- visual issues, the leftmost value's color will be used for the entire right
  --- "column".
  project_line = {
    ---@type false|"eol"|"right" Show task count
    enable_task_count = "eol",
    ---@type false|"eol"|"right" Show average urgency
    enable_average_urgency = "eol",
    ---@type false|"eol"|"right" Show total urgency
    enable_total_urgency = false,
    ---@type false|"eol"|"right" Show total estimate (Note: This is not a
    ---default field in taskwarrior)
    enable_total_estimate = "eol",
  },

  ---@type boolean|table Add custom colors to specific projects or disable with false.
  project_colors = {
    neowarrior = { match = "neowarrior.*", color = "neowarrior" },
  },

  ---@type table Header config
  header = {
    ---@type string|table|nil Custom header text (disable with nil)
    text = {
      { text = " NeoWarrior ", color = "neowarrior" },
      { text = " {version} ", color = "neowarrior_inverted" },
    },
    ---@type boolean Whether to show help line
    enable_help_line = true,
    ---@type boolean Whether to show the current report at the top
    enable_current_report = true,
    ---@type boolean Whether to show the current view on the report line
    enable_current_view = true,
    ---@type boolean Whether to show the current filter at the top
    enable_current_filter = true,
    ---@type boolean Whether to show the current sort option on the filter line
    enable_current_sort = false,
    ---@type boolean|table Show task info. Disable with false.
    task_info = {
      { text = "Tasks: " },
      { text = "{count}", color = "info" },
      {
        text = " Due soon: ",
        tasks = { "next", "due.before:2d and due.after:today" },
        active = function(tasks) return tasks:count() > 0 end
      },
      {
        text = " {count} ",
        tasks = { "next", "due.before:2d and due.after:today" },
        active = function(tasks) return tasks:count() > 0 end,
        color = function(tasks)
          if tasks:count() > 3 then
            return "danger_bg"
          end
          return "warning"
        end,
      },
    }
  },

  ---@type string Default taskwarrior filter
  filter = "",

  ---@type string Default taskwarrior report
  report = "next",

  ---@type "normal"|"grouped"|"tree"|"agenda" Default view mode
  mode = "normal",

  ---@type string Default sort option
  sort = "urgency",

  ---@type string Sort direction, ascending (asc) or descending (desc)
  sort_direction = "desc",

  ---@type boolean Whether to expand all trees at start
  expanded = false,

  ---@type string Default project name for tasks without project
  no_project_name = "no-project",

  ---@type table NeoWarrior float settings
  float = {
    ---@type number Width of float in columns, or if set to a number below 1,
    ---it will be calculated as a percentage of the window width.
    width = 60,
    ---@type number Height of float in rows, or if set to a number below 1,
    ---it will be calculated as a percentage of the window height.
    height = 0.8,
  },

  ---@type table Task float
  task_float = {
    ---@type boolean|string Set to true to enable task float on hover. Alternatively
    ---you can set it to a key (string) to enable it on key press.
    enabled = true,
    ---@type number Time in milliseconds before detail float is shown. Only used if
    ---enabled is set to true.
    delay = 200,
    ---@type number Max width of float in columns
    max_width = 60,
  },

  ---@type table Project float
  project_float = {
    ---@type boolean|string Set to true to enable project float on hover. Alternatively
    ---you can set it to a key (string) to enable it on key press.
    enabled = "e",
    ---@type number Time in milliseconds before detail float is shown
    delay = 200,
    ---@type number Max width of float in columns
    max_width = 40,
  },

  ---@type number Timezone offset in hours
  time_offset = 0,

  ---@type table Colors and hl groups.
  ---You can use custom hl groups or just define colors for the existing
  ---highlight groups. A nil/false value for a color means it's
  ---disabled/transparent.
  colors = {
    neowarrior = { group = "NeoWarrior", fg = "#3eeafa", bg = "black" },
    neowarrior_inverted = { group = "NeoWarriorInverted", fg = "black", bg = "#3cc8d7" },
    default = { group = "", fg = nil, bg = nil },
    dim = { group = "NeoWarriorTextDim", fg = "#333333", bg = nil },
    danger = { group = "NeoWarriorTextDanger", fg = "#cc0000", bg = nil },
    warning = { group = "NeoWarriorTextWarning", fg = "#ccaa00", bg = nil },
    success = { group = "NeoWarriorTextSuccess", fg = "#00cc00", bg = nil },
    info = { group = "NeoWarriorTextInfo", fg = "#00aaff", bg = nil },
    danger_bg = { group = "NeoWarriorTextDangerBg", fg = "#ffffff", bg = "#cc0000" },
    info_bg = { group = "NeoWarriorTextInfoBg", fg = "#000000", bg = "#00aaff" },
    project = { group = "NeoWarriorGroup", fg = "#00aaff", bg = nil },
    annotation = { group = "NeoWarriorAnnotation", fg = "#00aaff", bg = nil },
    tag = { group = "NeoWarriorTag", fg = "#ffffff", bg = "#333333" },
    current_date = { group = "NeoWarriorCurrentDate", fg = "#000000", bg = "#00aaff" },
    marked_date = { group = "NeoWarriorMarkedDate", fg = "#ffffff", bg = "#00aa66" },
  },
  --- Example using builtin highlight groups:
  -- colors = {
  --   default = { group = "" },
  --   dim = { group = "Whitespace" },
  --   danger = { group = "ErrorMsg" },
  --   warning = { group = "WarningMsg" },
  --   success = { group = "FloatTitle" },
  --   info = { group = "Question" },
  --   danger_bg = { group = "ErrorMsg" },
  --   project = { group = "Directory" },
  -- },

  ---@type table Breakpoints for coloring urgency, priorities etc.
  breakpoints = {

    ---@type table Urgency breakpoints. Uses equal or greater than for comparison.
    urgency = {
      { -100, "dim" }, --- Equal or higher than -100
      { 5, "warning" }, --- Equal or higher than 5
      { 10, "danger" }, --- Equal or higher than 10
    },

    ---@type table Estimate breakpoints (note that this is not a default
    ---taskwarrior field). Uses equal or greater than for comparison.
    estimate = {
      { 0, "danger" }, --- Equal or higher than 0
      { 1, "warning" }, --- Equal or higher than 1
      { 8, "default" }, --- Equal or higher than 8
    },

    ---@type table Due date breakpoints. Uses hours, and equal or lesser than
    ---for comparison. Use nil for a "catch all" value.
    due = {
      { 0.5, "danger_bg" }, --- Equal or lesser than 0.5 hours
      { 4, "danger" }, --- Equal or lesser than 4 hours
      { 48, "warning" }, --- Equal or lesser than 48 hours
      { nil, "dim" }, --- "Catch all" for the rest
    },

    ---@type table Priority colors.
    priority = {
      H = "danger",
      M = "warning",
      L = "success",
      None = "default",
    },
  },

  ---@type table|boolean Tag colors. Set to false to disable all. You can also use a table
  ---to specify a match pattern and color.
  tag_colors = {
    next = "danger_bg", --- matches tags called "next"
    blocked = "danger_bg", --- matches tags called "blocked"
    version = { match = "v.%..", color = "info_bg" }, -- match v*.*, v1.*, etc.
    version_full = { match = "v.%..%..", color = "info_bg" }, -- match v*.*.*, v1.*.*, etc.
    default = { match = ".*", color = "tag" }, -- match all other tags
  },

  ---@type nil|string Pad start of tags with this string. Use nil to disable.
  tag_padding_start = "+",
  ---@type nil|string Pad end of tags with this string. Use nil to disable.
  tag_padding_end = nil,

  ---@type table|nil Set config values for specific directories.
  --- Most config values from this file should work per dir
  --- basis too. Example:
  -- dir_setup = {
  --   {
  --     dir = HOME .. "/dev/neowarrior",
  --     mode = "tree",
  --     --- ... other config values
  --   },
  --   {
  --     match = "neowarrior", --- matches paths with "neowarrior" in the name
  --     mode = "tree",
  --     --- ... other config values
  --   }
  -- },
  dir_setup = nil,

  ---@type table Default reports available (valid taskwarrior reports). Used
  ---in selects.
  reports = {
    "active", "all", "blocked", "blocking", "completed", "list", "long",
    "ls", "minimal", "newest", "next", "oldest", "overdue", "projects",
    "ready", "recurring", "summary", "tags", "unblocked", "waiting",
  },

  ---@type string[]|table[] Default filters available (valid taskwarrior filters). Used
  ---in selects.
  filters = {
    { name = "Has due date", filter = "due.not:" },
    { name = "Has no due date", filter = "due:" },
    { name = "Due today", filter = "\\(due.before:2d and due.not: \\)" },
    { name = "Is not scheduled", filter = "scheduled:" },
    { name = "Is scheduled", filter = "scheduled.not:" },
    { name = "High priority", filter = "priority:H" },
    { name = "Medium priority", filter = "priority:M" },
    { name = "Low priority", filter = "priority:L" },
    { name = "No priority", filter = "priority:" },
    { name = "Has priority", filter = "priority.not:" },
    { name = "Has no project", filter = "project:" },
    { name = "Has project", filter = "project.not:" },
    {
      name = "Overdue",
      filter = "due.before:today and status:pending",
      sort = "due",
      sort_order = "asc",
    },
    {
      name = "Est. under 1 hour, this week",
      filter = "\\(est.before:1 and est.not: \\) and \\(due.before:7d or due: \\)",
      sort = "estimate",
      sort_order = "asc",
    },
  },

  ---@type table Task sort options for selects.
  task_sort_options = {
    { name = "Urgency (desc)", key = "urgency", direction = "desc" },
    { name = "Urgency (asc)", key = "urgency", direction = "asc" },
    { name = "Due (asc)", key = "due", direction = "asc" },
    { name = "Due (desc)", key = "due", direction = "desc" },
    { name = "Scheduled (asc)", key = "scheduled", direction = "asc" },
    { name = "Sceduled (desc)", key = "schedlued", direction = "desc" },
    { name = "Entry (from newest)", key = "entry", direction = "desc" },
    { name = "Entry (from oldest)", key = "entry", direction = "asc" },
    { name = "Modified (latest)", key = "modified", direction = "desc" },
    { name = "Modified (oldest)", key = "modified", direction = "asc" },
    { name = "Estimate (asc)", key = "estimate", direction = "asc" },
    { name = "Estimate (desc)", key = "estimate", direction = "desc" },
  },

  ---@type table Default key mappings. Disable all by setting keys to nil or false.
  keys = {
    help = '?', --- Show help
    add = 'a', --- Add task
    delete = 'x', --- Delete task
    done = 'd', --- Mark task as done
    start = 'S', --- Start task
    select_dependency = 'Md', --- Select dependency
    search = 's', --- Search all tasks
    filter = 'F', --- Input filter
    select_filter = 'f', --- Select filter
    select_sort = 'o', --- Select sort
    toggle_group_view = 'tg', --- Toggle grouped view
    toggle_tree_view = 'tt', --- Toggle tree view
    toggle_agenda_view = 'ta', --- Toggle tree view
    select_report = 'r', --- Select report
    refresh = 'R', --- Refresh tasks
    reset = 'X', --- Reset filter
    collapse_all = 'W', --- Collapse all tree nodes
    expand_all = 'E', --- Expand all tree nodes
    toggle_tree = '<Tab>', --- Toggle tree node
    enter = 'l', --- Enter task/Activate line action
    back = 'h', --- Go back
    close = 'q', --- Close taskwarrior/close help
    modify = 'MM', --- Modify task
    modify_select_project = 'Mp', --- Modify project
    modify_select_priority = 'MP', --- Modify priority
    modify_due = 'MD', --- Modify due date
    next_tab = "L", --- Tab navigation, next tab
    prev_tab = "H", --- Tab navigation, previous tab
  },

  ---@type table Default icons
  icons = {
    task = "\u{f1db}",
    task_completed = "\u{f14a}",
    recur = "\u{f021}",
    project = "\u{f07b}",
    project_alt = "\u{f0256}",
    project_open = "\u{f115}",
    warning = "\u{f071}",
    annotated = "\u{f1781}",
    start = "\u{f040a}",
    due = "\u{f1442}",
    est = "\u{f0520}",
    deleted = "\u{f014}",
    depends = "\u{f111}",
  },
}
```
