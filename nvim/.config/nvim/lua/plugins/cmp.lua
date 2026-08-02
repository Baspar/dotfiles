local cmp = require('blink.cmp')
cmp.build():pwait()
cmp.setup({
  keymap = {
    preset = 'default',
    ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
    ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },
    ['<C-l>'] = { 'select_and_accept', 'fallback' },
  },
  completion = {
    menu = {
      draw = {
        components = {
            kind_icon = {
                ellipsis = false,
                text = function(ctx)
                    local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                    return kind_icon
                end,
            }
        }
      }
    }
  }
})
