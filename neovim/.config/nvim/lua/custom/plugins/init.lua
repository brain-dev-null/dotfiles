-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    'tpope/vim-fugitive',
    config = function ()
      local function create_commit(sc_line)
        local template = os.tmpname()
        local file = io.open(template, "w+")
        if not file then
          error("Faile to create template file: " .. template)
        end

        local issue_id = string.match(sc_line, "%S+")
        file:write(issue_id .. "\n\n\n# " .. sc_line .. "\n")
        file:flush()

        local command = "G commit -t " .. template
        vim.cmd(command)
      end

      local function smartcommit()
        local pickers = require "telescope.pickers"
        local finders = require "telescope.finders"
        local conf = require("telescope.config").values
        local actions = require "telescope.actions"
        local action_state = require "telescope.actions.state"

        local lines = {}
        local job = vim.fn.jobstart(
          '$HOME/scripts/smartcommitter.sh',
          {
            on_stdout = function (_, data)
              if data then
                for _, line in ipairs(data) do
                  if string.len(line) > 0 then
                    table.insert(lines, line)
                  end
                end
              end
            end
          }
        )
        vim.fn.jobwait({job})

        local result = ""
        local opts = require("telescope.themes").get_dropdown{}
        pickers.new(
          opts,
          {
            prompt_title = "Jira Issues",
            finder = finders.new_table({ results = lines }),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
              actions.select_default:replace(function ()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()[1]
                create_commit(selection)
              end)
              return true
            end
          }
        ):find()

        print(result)
      end
      vim.keymap.set('n', '<leader>sc', smartcommit, { desc = '[S]mart [C]ommit' })
    end
  },
}
-- vim: ts=2 sts=2 sw=2 et
