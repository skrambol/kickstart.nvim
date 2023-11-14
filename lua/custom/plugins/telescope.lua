return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  config = function ()
    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      defaults = {
        -- mappings = {
        --   i = {
        --     ['<C-u>'] = false,
        --     ['<C-d>'] = false,
        --   },
        -- },
        layout_strategy = "vertical",
        layout_config = {
          horizontal = {
            preview_width = 0.4,
            preview_cutoff = 100,
          },
          vertical = {
            width = 0.8,
            preview_height = 0.4,
            preview_cutoff = 20,
          },
        },
        -- path_display = { "smart" }
      },
      pickers = {
        buffers = {
          previewer = false,
          mappings = {
            n = {
              ['D'] = require('telescope.actions').delete_buffer
            }
          }
        },
        git_files = {
          show_untracked = true,
        }
      }
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')

    -- See `:help telescope.builtin`
    vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<C-b>', require('telescope.builtin').buffers, { desc = '[b] Find existing buffers' })
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      require('telescope.builtin').current_buffer_fuzzy_find({ previewer = false, })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<C-p>', function ()
      if pcall(require('telescope.builtin').git_files) then
      else
        print("[!] Directory is not a git repository. Running search files instead.")
        require('telescope.builtin').find_files()
      end
    end, { desc = 'Search [G]it [F]iles' })
    vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<F1>', function()
      require('telescope.builtin').help_tags({
        previewer = false
      })
    end, { desc = 'Search help' })
    vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>vrc', function ()
      require('telescope.builtin').git_files({cwd = "~/.config/nvim"})
    end, {desc = 'Search neovim config'})
    vim.keymap.set('n', '<leader>o', require('telescope.builtin').oldfiles, { desc = 'Telescope [O]ldfiles'})
  end
}
