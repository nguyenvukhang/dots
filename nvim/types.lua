
---@class MiniFzfEntryData
---@field filename string
---@field lnum number?

---@class MiniFzf
---@field data table<string, MiniFzfEntryData>
---@field fzf_choices string[]
local MiniFzf = { data = {}, fzf_choices = {} }
