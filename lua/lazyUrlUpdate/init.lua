-- cspell:disable
local M = {}

-- TODO: ADS
-- ADS:2024ApJS..271...10W
local url_patterns = {
  {
    pattern = "https://neovim%.io/(%S+)",
    prefix = "neovim:",
    base_url = "https://neovim.io/",
  },
  {
    pattern = "https://arxiv%.org/abs/(%S+)",
    prefix = "arxiv:",
    base_url = "https://arxiv.org/abs/",
  },
  {
    pattern = "https://doi%.org/(%S+)",
    prefix = "doi:",
    base_url = "https://doi.org/",
  },
  {
    pattern = "https://orcid%.org/(%S+)",
    prefix = "orcid:",
    base_url = "https://orcid.org/",
  },
  {
    pattern = "https://root%-forum%.cern%.ch/(%S+)",
    prefix = "rootforum:",
    base_url = "https://root-forum.cern.ch/",
  },
  {
    pattern = "https://geant4%-forum%.web%.cern%.ch/t/(%S+)",
    prefix = "geant4forum:",
    base_url = "https://geant4-forum.web.cern.ch/t/",
  },
  {
    pattern = "https://ui%.adsabs%.harvard%.edu/abs/(%S+)",
    prefix = "ADS:",
    base_url = "https://ui.adsabs.harvard.edu/abs/",
  },
  {
    -- BUG: https://github.com/akira-okumura/PyTeVCat  open in a markdown file not worked?
    pattern = "https://github%.com/(%S+)",
    prefix = "github:",
    base_url = "https://github.com/",
  },
  {
    pattern = "https://bitbucket%.org/(%S+)",
    prefix = "bitbucket:",
    base_url = "https://bitbucket.org/",
  },
  {
    pattern = "https://codeberg%.org/(%S+)",
    prefix = "codeberg:",
    base_url = "https://codeberg.org/",
  },
  {
    pattern = "https://gitlab%.com/(%S+)",
    prefix = "gitlab:",
    base_url = "https://gitlab.com/",
  },
}
-- NEEDCHECK: 简化, base on AI
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

--- 从光标所在的(必要时逐层向外)lazy.nvim plugin spec 表里提取 URL。
--- 优先级: url = "..." > "owner/repo"(补成 https://github.com/...)。
--- 命中 dir = "..."(本地插件)则放弃;字符串/注释里的 {} 不参与配对,可能误判。
local function get_plugin_url()
  local view = vim.fn.winsaveview()
  local result

  for _ = 1, 20 do
    local open = vim.fn.searchpairpos("{", "", "}", "bnW")
    if open[1] == 0 then break end
    local close = vim.fn.searchpairpos("{", "", "}", "nW")
    if close[1] == 0 then break end

    local lines = vim.api.nvim_buf_get_lines(0, open[1] - 1, close[1], false)
    local block = table.concat(lines, "\n")

    local url = block:match("url%s*=%s*[\"']([^\"']+)[\"']")
    if url then
      result = url
      break
    end
    -- 本地插件:有 dir 字段,没有远程 url
    if block:match("dir%s*=%s*[\"']") then break end
    -- 默认:owner/repo 字符串 -> github
    local repo = block:match("[\"']([%w_%-.]+/[%w_%-.]+)[\"']")
    if repo then
      result = "https://github.com/" .. repo
      break
    end
    -- 本层没有,光标挪到当前 { 左侧,继续找更外层的表
    vim.api.nvim_win_set_cursor(0, { open[1], math.max(0, open[2] - 2) })
  end

  vim.fn.winrestview(view)
  return result
end

--- 根据 plugin spec 的 url + 光标处的 #N,自动打开 issue/PR/discussion。
--- 支持 ISSUE:#1 / pull #2 / DISCUSSION:#3 —— 前缀可大写,冒号或空格分隔,也可无前缀(默认 issue)。
--- 前缀词决定类型: pr/pull -> pull, discuss/discussion -> discussions, 其余 -> issues。
--- 跨平台路径: github pull, codeberg pulls, bitbucket pull-requests;issues 通用。
local function open_url_ext()
  local base = get_plugin_url()
  if not base then
    vim.notify("No plugin url found under cursor {}", vim.log.levels.WARN)
    return
  end
  base = base:gsub("/+$", "")

  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local host = base:match("^https?://([^/]+)") or ""

  local num, path
  local best = math.huge
  for word, hpos, n in line:gmatch("(%a*)[%s:]-()#(%d+)") do
    local w = word:lower()
    local p = "issues"
    if w == "pr" or w == "pull" then
      p = host:find("codeberg") and "pulls" or host:find("bitbucket") and "pull-requests" or "pull"
    elseif w == "discuss" or w == "discussion" then
      p = "discussions"
    end
    local dist = math.abs(col - hpos)
    if dist < best then
      best, num, path = dist, n, p
    end
  end

  if not num then
    vim.notify("No #N found on this line", vim.log.levels.WARN)
    return
  end

  local url = base .. "/" .. path .. "/" .. num
  vim.fn.system("open " .. url)
  vim.notify(url, vim.log.levels.INFO)
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
  for _, entry in ipairs(url_patterns) do
    local id = string.match(strr, entry.prefix .. "(%S+)")
    if id then
      local url = entry.base_url .. id
      vim.fn.system("open " .. url)
      vim.notify("O" .. url, vim.log.levels.INFO)
    end
  end
  -- local arxiv_id = string.match(strr, "arxiv:(%S+)")
  -- local doi_id = string.match(strr, "doi:(%S+)")
  -- local orcid_id = string.match(strr, "orcid:(%S+)")
  -- local github_id = string.match(strr, "github:(%S+)")
  -- local rootforum_id = string.match(strr, "rootforum:(%S+)")
  --
  -- if arxiv_id then
  --   local url = "https://arxiv.org/abs/" .. arxiv_id
  --   vim.fn.system("open " .. url)
  --   vim.notify("O arxiv: " .. url, vim.log.levels.INFO)
  -- end
  -- if doi_id then
  --   local url = "https://doi.org/" .. doi_id
  --   vim.fn.system("open " .. url)
  --   vim.notify("O doi: " .. url, vim.log.levels.INFO)
  -- end
  -- if orcid_id then
  --   local url = "https://orcid.org/" .. orcid_id
  --   vim.fn.system("open " .. url)
  --   vim.notify("O orcid: " .. url, vim.log.levels.INFO)
  -- end
  -- if github_id then
  --   local url = "https://github.com/" .. github_id
  --   vim.fn.system("open " .. url)
  --   vim.notify("O orcid: " .. url, vim.log.levels.INFO)
  -- end
  -- if rootforum_id then
  --   local url = "https://root-forum.cern.ch/" .. rootforum_id
  --   vim.fn.system("open " .. url)
  --   vim.notify("O root forum: " .. url, vim.log.levels.INFO)
  -- end
end

local function open_url_chrome()
  local strr = extract_string()
  for _, entry in ipairs(url_patterns) do
    local id = string.match(strr, entry.prefix .. "(%S+)")
    if id then
      local url = entry.base_url .. id
      vim.fn.system('open -b com.google.Chrome ' .. url)
      vim.notify("O" .. url, vim.log.levels.INFO)
    end
  end
end

local function short_url()
  local url = extract_string()  -- 假设 extract_string() 返回输入的 URL 字符串
  for _, entry in ipairs(url_patterns) do
  local id = string.match(url, entry.pattern)
  if id then
    local short = entry.prefix .. id
    vim.notify("Shorter URL: " .. short, vim.log.levels.INFO)
    return short
  end
end

  vim.notify("No matching URL pattern found", vim.log.levels.WARN)
  return url
end

local function replace_url_under_cursor()
  local cur_word = vim.fn.expand("<cWORD>")
  local short = short_url(cur_word)
  if short == cur_word then
    return
  end

  local cur_line = vim.api.nvim_get_current_line()
  -- INFO: from GTP
  -- local escaped_cur_word = vim.fn.escape(cur_word, "/%^$().[]*+-?")
  -- local escaped_cur_word = vim.fn.escape(cur_word, "^$ ")
  local escaped_cur_word = cur_word:gsub("([^%w])", "%%%1")
  local new_line = string.gsub(cur_line, escaped_cur_word, short, 1)
  vim.api.nvim_set_current_line(new_line)
  -- vim.notify("替换为短格式: " .. short, vim.log.levels.INFO)
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
  vim.api.nvim_create_user_command("LazyUrlOpenChrome", function() open_url_chrome() end, {})
  vim.api.nvim_create_user_command("LazyUrlShort", function() replace_url_under_cursor() end, {})
  vim.api.nvim_create_user_command("LazyUrlOpenExt", function() open_url_ext() end, {})
  vim.api.nvim_create_user_command("CheckHealth", function() check_health_plugin() end, {})
end

return M
