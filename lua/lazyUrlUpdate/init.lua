-- cspell:disable
local M = {}

-- TODO: 简化
local function get_plugin_name()
  local current_word = vim.fn.expand("<cfile>")
  if current_word and current_word ~= "" then
    local plugin_name = current_word:match(".*/(.+)")
    return plugin_name
  end
  return false
end

local function update_plugin()
  local current_word = vim.fn.expand("<cfile>")
  if current_word and current_word ~= "" then
    local plugin_name = get_plugin_name()
    if plugin_name then
      vim.notify("Updating plugin: " .. plugin_name, vim.log.levels.INFO)
      vim.cmd("Lazy update " .. plugin_name)
    else
      vim.notify("No valid plugin name found under cursor:", vim.log.levels.ERROR)
    end
  else
    vim.notify("No word under cursor to use as plugin name:" .. current_word, vim.log.levels.ERROR)
  end
end

local function build_plugin()
  local current_word = vim.fn.expand("<cfile>")
  if current_word and current_word ~= "" then
    local plugin_name = get_plugin_name()
    if plugin_name then
      vim.notify("Updating plugin: " .. plugin_name, vim.log.levels.INFO)
      vim.cmd("Lazy build " .. plugin_name)
    else
      vim.notify("No valid plugin name found under cursor:", vim.log.levels.ERROR)
    end
  else
    vim.notify("No word under cursor to use as plugin name:" .. current_word, vim.log.levels.ERROR)
  end
end
function M.setup(_)
  vim.api.nvim_create_user_command("LazyUrlUpdate", function() update_plugin() end, {})
  vim.api.nvim_create_user_command("LazyUrlBuild", function() build_plugin() end, {})
end

return M
