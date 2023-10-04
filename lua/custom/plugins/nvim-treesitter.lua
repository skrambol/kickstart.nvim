return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = {
        'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript',
        'vimdoc', 'vim', 'markdown', 'markdown_inline', 'elixir'
      },

      -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
      auto_install = false,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" }
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = '<C-s>',
          node_decremental = '<M-space>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    }

    -- folds
    local function get_custom_foldtxt_suffix(foldstart)
      local fold_suffix_str = string.format(
        "  %s [%s lines]",
        '┉',
        vim.v.foldend - foldstart + 1
      )

      return { fold_suffix_str, "Folded" }
    end

    local function get_custom_foldtext(foldtxt_suffix, foldstart)
      local line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, false)[1]

      return { { line, "Normal" }, foldtxt_suffix }
    end

    _G.get_foldtext = function()
      local foldstart = vim.v.foldstart
      local ts_foldtxt = vim.treesitter.foldtext()
      local foldtxt_suffix = get_custom_foldtxt_suffix(foldstart)

      if type(ts_foldtxt) == "string" then
        return get_custom_foldtext(foldtxt_suffix, foldstart)
      end
      table.insert(ts_foldtxt, foldtxt_suffix)

      return ts_foldtxt
    end

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt.foldtext = "v:lua.get_foldtext()"
    vim.opt.foldlevelstart = 99
  end
}
