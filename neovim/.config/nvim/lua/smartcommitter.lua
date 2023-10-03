local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local function run_sc()
  local homedir = vim.fn.getenv('HOME')
  local script = homedir .. "/scripts/smartcommitter.sh"
  local output = vim.fn.system(script)
  local lines = {}
  for s in output:gmatch("[^\r\n]+") do
      table.insert(lines, s)
  end
  return lines
end

local function extract_issue_id(selection)
  for word in selection:gmatch("%S+") do
    return word
  end
end

local function format_commit_template(selection)
  local issue_id = extract_issue_id(selection)
  return issue_id .. " \n\n# " .. selection .. "\n"
end

local tempfile_name = "/tmp/scommiter.txt"


local run_smartcommitter = function(opts)
  opts = opts or {}
  local lines = run_sc()
  pickers.new(opts, {
    prompt_title = "Select Jira Issue",
    finder = finders.new_table { results = lines },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()[1]
        local tempfile = io.open(tempfile_name, "w")
        local commit_template = format_commit_template(selection)
        if tempfile ~= nil then
          io.output(tempfile)
          io.write(commit_template)
          io.close(tempfile)
          vim.api.nvim_command(":G commit -t " .. tempfile_name)
        end
      end)
      return true
    end,
  }):find()
end

return {
  runSmartCommiter = function ()
    run_smartcommitter(require("telescope.themes").get_dropdown({layout_config={width=0.75}}))
  end
}
