local lspconfig = require"lspconfig"
local compe = require"compe"

vim.lsp.set_log_level("debug")

compe.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;
  };
}

local function exists_glob(glob)
  return vim.fn.glob(glob) ~= ""
end

function eslint_config_exists()
  return exists_glob(".eslintrc*") or exists_package_json_field("eslintConfig")
end


-- {{{ Typescript/Javascript
lspconfig.tsserver.setup{
  on_attach = function(client)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
  end
}
-- }}}

-- {{{ ESlint
local eslint = {
  lintCommand = "eslint_d -f compact --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = {'%f: line %l, col %c, %trror - %m', '%f: line %l, col %c, %tarning - %m'},
}

lspconfig.efm.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.goto_definition = false
  end,
  root_dir = function()
    if not eslint_config_exists() then
      return nil
    end
    return vim.fn.getcwd()
  end,
  settings = {
    languages = {
      javascript = {eslint},
      javascriptreact = {eslint},
      ["javascript.jsx"] = {eslint},
      typescript = {eslint},
      ["typescript.tsx"] = {eslint},
      typescriptreact = {eslint}
    }
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact"
  },
}
-- }}}

-- {{{ Rust
lspconfig.rls.setup{}
-- }}}

-- {{{ Scala
lspconfig.metals.setup{
  root_dir = lspconfig.util.find_git_ancestor;
}
-- }}}

-- vim: foldmethod=marker:foldlevel=1
