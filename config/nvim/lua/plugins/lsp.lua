local lspconfig = require('lspconfig');

local prettier = {
  formatCommand = "./node_modules/.bin/prettier --stdin-filepath ${INPUT}",
  formatStdin = true
}

local eslint = {
    lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"},
    formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
    formatStdin = true
}

local tsserver_args = {}

table.insert(tsserver_args, prettier)
table.insert(tsserver_args, eslint)

local format_async = function(err, _, result, _, bufnr)
  if err ~= nil or result == nil then return end
  if not vim.api.nvim_buf_get_option(bufnr, "modified") then
    local view = vim.fn.winsaveview()
    vim.lsp.util.apply_text_edits(result, bufnr)
    vim.fn.winrestview(view)
    if bufnr == vim.api.nvim_get_current_buf() then
      vim.api.nvim_command("noautocmd :update")
    end
  end
end

vim.lsp.handlers["textDocument/formatting"] = format_async

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  buf_set_keymap('n', '<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  buf_set_keymap('n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  buf_set_keymap('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  buf_set_keymap('n', 'U', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  buf_set_keymap('n', '<leader>lr', '<cmd>Telescope lsp_references<cr>', opts)
  buf_set_keymap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)
  buf_set_keymap('n', '<leader>lS', '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>', opts)
  buf_set_keymap('n', '<leader>lR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  buf_set_keymap('n', '<leader>lA', '<cmd>Telescope lsp_code_actions<cr>', opts)
  buf_set_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
  buf_set_keymap('n', '<c-t>', '<cmd>Telescope lsp_workspace_symbols<cr>', opts)

  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_exec([[
       augroup LspAutocommands
           autocmd! * <buffer>
           autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()
       augroup END
       ]], true
     )
  end
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "bashls", "cssls", "html", "jsonls", "rust_analyzer", "solargraph", "vimls", "vuels", "yamlls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 100,
    }
  })
end

lspconfig.tsserver.setup({
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    on_attach(client)
  end
})

lspconfig.sqlls.setup({
  cmd = { '/usr/local/bin/sql-language-server', 'up', '--method', 'stdio' },
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  }
})

lspconfig.efm.setup({
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 100,
  },
  init_options = {
    documentFormatting = true,
    hover = true,
    documentSymbol = true,
    codeAction = true,
    completion = true
  },
  filetypes = {"javascriptreact", "javascript", "typescript", "typescriptreact", "sh", "html", "css", "yaml", "markdown", "vue"},
  settings = {
    rootMarkers = {".git/"},
    languages = {
      javascript = tsserver_args,
      javascriptreact = tsserver_args,
      typescript = tsserver_args,
      typescriptreact = tsserver_args,
      vue = tsserver_args,
      html = {prettier},
      css = {prettier},
      json = {prettier},
      yaml = {prettier}
    }
  }
})
