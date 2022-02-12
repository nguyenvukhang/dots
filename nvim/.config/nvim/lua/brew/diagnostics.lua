local M = {}

local convert_diagnostic_type = function(severities, severity)
  -- convert from string to int
  if type(severity) == "string" then
    -- make sure that e.g. error is uppercased to ERROR
    return severities[severity:upper()]
  end
  -- otherwise keep original value, incl. nil
  return severity
end

local diagnostics_to_tbl = function(opts)
  opts = vim.F.if_nil(opts, {})
  local items = {}
  local severities = vim.diagnostic.severity
  local current_buf = vim.api.nvim_get_current_buf()

  opts.severity = convert_diagnostic_type(severities, opts.severity)
  opts.severity_limit = convert_diagnostic_type(severities, opts.severity_limit)
  opts.severity_bound = convert_diagnostic_type(severities, opts.severity_bound)

  local diagnosis_opts = { severity = {}, namespace = opts.namespace }
  if opts.severity ~= nil then
    if opts.severity_limit ~= nil or opts.severity_bound ~= nil then
      print "Invalid severity parameters. Both a specific severity and a limit/bound is not allowed"
      return {}
    end
    diagnosis_opts.severity = opts.severity
  else
    if opts.severity_limit ~= nil then
      diagnosis_opts.severity["min"] = opts.severity_limit
    end
    if opts.severity_bound ~= nil then
      diagnosis_opts.severity["max"] = opts.severity_bound
    end
  end

  local bufnr_name_map = {}
  local preprocess_diag = function(diagnostic)
    if bufnr_name_map[diagnostic.bufnr] == nil then
      bufnr_name_map[diagnostic.bufnr] = vim.api.nvim_buf_get_name(diagnostic.bufnr)
    end

    local buffer_diag = {
      bufnr = diagnostic.bufnr,
      filename = bufnr_name_map[diagnostic.bufnr],
      lnum = diagnostic.lnum + 1,
      col = diagnostic.col + 1,
      text = vim.trim(diagnostic.message:gsub("[\n]", "")),
      type = severities[diagnostic.severity] or severities[1],
    }
    return buffer_diag
  end

  for _, d in ipairs(vim.diagnostic.get(opts.bufnr, diagnosis_opts)) do
    -- filter out diagnostics on current buffer only
    if d.bufnr == current_buf then
      table.insert(items, preprocess_diag(d))
    end
  end

  -- sort results by bufnr (prioritize cur buf), severity, lnum
  table.sort(items, function(a, b)
    if a.bufnr == b.bufnr then
      if a.type == b.type then
        return a.lnum < b.lnum
      else
        return a.type < b.type
      end
    else
      -- prioritize for current bufnr
      if a.bufnr == current_buf then
        return true
      end
      if b.bufnr == current_buf then
        return false
      end
      return a.bufnr < b.bufnr
    end
  end)

  return items
end

-- sends lsp diagnostics on current window into
-- quickfix/local list
M.diagnostics = function ()
  -- close diagnostics if qflist is already open
  local utils = require('brew.core').utils
  if utils.qflist_is_open() then
    vim.cmd('cclose') print(' ') return
  end

  local diagnostics = diagnostics_to_tbl()

  -- check if there are any diagnostics
  if vim.tbl_isempty(diagnostics) then
    print "No diagnostics found" return
  else
    -- send diagnostics to qflist
    vim.fn.setqflist(diagnostics, "r")
    vim.cmd('botright copen')
    return
  end
end

return M
