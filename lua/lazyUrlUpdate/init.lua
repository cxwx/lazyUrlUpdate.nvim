-- cspell:disable
local M = {}

-- TODO: 简化
--
local function extract_string()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], false)[1] -- 获取当前行内容
  local col = cursor[2] + 1 -- 光标列号（Lua 中字符串索引从 1 开始）
  local start = col
  while start > 1 and not string.match(line:sub(start, start), "%s") do
    start = start - 1
  end
  local finish = col
  while finish <= #line and not string.match(line:sub(finish, finish), "%s") do
    finish = finish + 1
  end
  local extracted_string = line:sub(start + 1, finish - 1)
  return extracted_string
end

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

local function open_url()
  local strr = extract_string()
  local arxiv_id = string.match(strr, "arxiv:(%S+)")
  local doi_id = string.match(strr, "doi:(%S+)")
  local orcid_id = string.match(strr, "orcid:(%S+)")
  local github_id = string.match(strr, "github:(%S+)")

  if arxiv_id then
    local url = "https://arxiv.org/abs/" .. arxiv_id
    vim.fn.system("open " .. url)
    vim.notify("O arxiv: " .. url, vim.log.levels.INFO)
  end
  if doi_id then
    local url = "https://doi.org/" .. doi_id
    vim.fn.system("open " .. url)
    vim.notify("O doi: " .. url, vim.log.levels.INFO)
  end
  if orcid_id then
    local url = "https://orcid.org/" .. orcid_id
    vim.fn.system("open " .. url)
    vim.notify("O orcid: " .. url, vim.log.levels.INFO)
  end
  if github_id then
    local url = "https://github.com/" .. github_id
    vim.fn.system("open " .. url)
    vim.notify("O orcid: " .. url, vim.log.levels.INFO)
  end
end

local function check_health_plugin()
  local current_word = vim.fn.expand("<cfile>")
  if current_word and current_word ~= "" then
    local plugin_name = get_plugin_name()
    if plugin_name then
      vim.notify("check health: " .. plugin_name, vim.log.levels.INFO)
      vim.cmd("checkhealth " .. plugin_name)
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
  vim.api.nvim_create_user_command("LazyUrlOpen", function() open_url() end, {})
  vim.api.nvim_create_user_command("CheckHealth", function() check_health_plugin() end, {})
end

return M
