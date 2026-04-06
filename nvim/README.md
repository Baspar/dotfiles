# Neovim Configuration

This is a fully Lua-based Neovim configuration converted from the original Vim setup.

## Structure

```
.config/nvim/
├── init.lua                    # Main entry point
└── lua/
    ├── config/
    │   ├── options.lua         # Vim options and settings
    │   ├── plugins.lua         # Plugin management (lazy.nvim)
    │   ├── mappings.lua        # Key mappings
    │   ├── lsp.lua            # LSP configuration
    │   ├── treesitter.lua     # Treesitter setup
    │   ├── statusline.lua     # Custom statusline
    │   ├── colors.lua         # Color scheme customization
    │   ├── fzf.lua            # FZF configuration
    │   ├── indent.lua         # Indent-blankline setup
    │   └── leap.lua           # Leap.nvim motion setup
    └── utils/
        ├── duplicate.lua       # Text duplication utilities
        ├── ag_helper.lua       # Search helpers
        ├── repl_it.lua         # REPL integration
        └── highlight_current_word.lua  # Word highlighting

```

## Installation

```bash
./deploy.bash nvim
```

## Plugin Manager

Uses [lazy.nvim](https://github.com/folke/lazy.nvim) instead of vim-plug.

## Key Features

- Full LSP support with nvim-lspconfig
- Treesitter for syntax highlighting
- FZF integration for fuzzy finding
- Custom statusline
- Leap.nvim for fast motion
- Git integration with fugitive
- Auto-completion with nvim-cmp
