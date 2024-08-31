-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
-- EXAMPLE
-- 
local servers = { "html", "cssls", "haxe_language_server"}
local nvlsp = require "nvchad.configs.lspconfig"


-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

local lsp_port = nil

local function select_hxml(client, hxml)
  if hxml and vim.fn.filereadable(hxml) then
    vim.notify('Updating Haxe configuration: '..hxml)
    client.notify('haxe/didChangeDisplayArguments', {arguments = {hxml}})
    -- set haxe build command
    if lsp_port then
      vim.opt.makeprg = 'haxe --connect '..lsp_port..' '..hxml
    else
      vim.opt.makeprg = 'haxe '..hxml
    end
  end
end

vim.lsp.handlers["haxe/didChangeDisplayPort"] = function(_, data)
  if data and data.port then
    lsp_port = data.port
  end
end

local function list_hxmls(filter)
  return vim.fs.find(
    function (name, path)
      return vim.fs.joinpath(path,name):match(filter) and name:match('.hxml$')
    end,
    { limit = math.huge, path = '.', type = 'file' }
  )
end

local function on_attach_haxe_lsp(client, bufnr)
  vim.api.nvim_set_current_dir(client.config.root_dir)

  -- add command to select a different hxml
  vim.api.nvim_create_user_command('SelectHxml', function(obj)
    local hxml = obj.fargs[1]
    select_hxml(client, hxml)
  end,{
    desc = "Select an hxml file for the Haxe display configuration",
    nargs = 1,
    complete = list_hxmls,
  })
end

local default_config = require('lspconfig.server_configurations.haxe_language_server').default_config

local function on_new_haxe_ls_config(new_config, new_root_dir)
  default_config.on_new_config(new_config, new_root_dir)

  -- if display arguments are empty, then we can't create a compilation command
  if new_config.init_options.displayArguments then
    vim.opt.makeprg = 'haxe '..table.concat(new_config.init_options.displayArguments, ' ')
  end
end

lspconfig.haxe_language_server.setup({
  cmd = {"node", "/path/to/your/haxe-language-server/bin/server.js"},
  on_attach = on_attach_haxe_lsp,
  on_new_config = on_new_haxe_ls_config,
  settings={
    haxe={
      displayPort="auto"
    }
  }
})
