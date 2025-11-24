local M = {}

-- base settings for lsp
M.base = function(opts)
  opts = opts or {}
  opts.on_attach = function(_, bufnr)
    -- Disable LSP-based syntax highlighting. This introduces a color change
    -- after LSP gets attached.
    for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
      vim.api.nvim_set_hl(0, group, {})
    end
    local x = { buffer = bufnr, noremap = true }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, x)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, x)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, x)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, x)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, x)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, x)
  end
  return opts
end

M.lsp_add = setmetatable({}, {
  __newindex = function(_, key, opts)
    vim.lsp.config(key, M.base(opts))
    vim.lsp.enable(key)
  end,
})

return M
