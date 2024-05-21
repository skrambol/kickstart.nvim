return {
  'stevearc/conform.nvim',
  config = function()
    local conform = require 'conform'

    conform.setup({
      log_level = vim.log.levels.DEBUG,
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        xml = {"xmlformat"}
        -- Use a sub-list to run only the first available formatter
        -- javascript = { { "prettierd", "prettier" } },
      },
    })

    vim.api.nvim_create_user_command('FFormat', function ()
      local hunks = require("gitsigns").get_hunks()
      local format = require("conform").format
      local ignore = { "lua", "gitcommit" }

      if vim.tbl_contains(ignore, vim.bo.filetype) then
        return
      end

      for i = #hunks, 1, -1 do
        local hunk = hunks[i]
        if hunk ~= nil and hunk.type ~= "delete" then
          local start = hunk.added.start
          local last = start + hunk.added.count

          local last_hunk_line = vim.api.nvim_buf_get_lines(0, last-2, last-1, true)[1]
          local range = {start = {start, 0}, ["end"] = {last-1, last_hunk_line:len()}}
          -- print(vim.inspect(range))

          format({ range = range, async=true})
        end
      end
    end,
      {
        desc="format"
      })
  end
}
