local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ dir = '~/Documents/Code/ForestBerry', lazy = true },
	{
		'rktjmp/lush.nvim'
	},

	{
		'github/copilot.vim',
		config = function()
			vim.cmd('Copilot disable')
		end
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "github/copilot.vim" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		opts = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
		-- See Commands section for default commands if you want to lazy load on them
	},

	{
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		 dependencies = { 'nvim-lua/plenary.nvim' },
		 config = function()
			 vim.keymap.set('n', '<Leader>b', '<cmd>Telescope buffers<cr>')
			 vim.keymap.set('n', '<Leader>f', '<cmd>Telescope find_files<cr>')
		 end,
    	},

	{
  		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
    			-- LSP Support
    			{"neovim/nvim-lspconfig"},             -- Required
    			{"williamboman/mason.nvim"},           -- Optional
    			{"williamboman/mason-lspconfig.nvim"}, -- Optional

    			-- Autocompletion
    			{"hrsh7th/nvim-cmp"},     -- Required
    			{"hrsh7th/cmp-nvim-lsp"}, -- Required
    			{"L3MON4D3/LuaSnip"},     -- Required
		}
	},

	{
		"preservim/nerdtree"
	},

	{
		"nvim-treesitter/nvim-treesitter",
	},

	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {} -- this is equalent to setup({}) function
	},
	
	{
		'mfussenegger/nvim-dap',
		config = function()
			local dap = require('dap')
			dap.adapters.lldb = {
				type = 'executable',
				command = vim.api.nvim_exec2('echo exepath("lldb-vscode")', {output = true})['output'],
				name = 'lldb',
			}
			dap.configurations.cpp = {
				{
					name = 'Launch',
					type = 'lldb',
					request = 'launch',
					program = function()
						-- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
						return './debugProg'
					end,
					cwd = '${workspaceFolder}',
					stopOnEntry = false,
					args = {},
					runInTerminal = true,
				},
			}


		dap.configurations.c = dap.configurations.cpp

		local widgets = require('dap.ui.widgets')
		local sidebar = widgets.sidebar(widgets.scopes)

		vim.keymap.set('n', 't', dap.toggle_breakpoint)
		vim.keymap.set('n', '<Leader>c', dap.continue)
		vim.keymap.set('n', '<Leader>n', dap.step_over)
		vim.keymap.set('n', '<Leader>s', dap.step_into)
		vim.keymap.set('n', '<Leader>w', sidebar.toggle)
		vim.keymap.set('n', '<Leader>r', dap.repl.toggle)
		vim.keymap.set('n', '<Leader>q', dap.terminate)
		end,
	},

	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			local lualine = require('lualine')
			lualine.setup({})
		end
	}
})

vim.opt.termguicolors = true
vim.cmd("colorscheme ForestBerry")

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr})
end)

lspcfg = require("lspconfig")

lspcfg.pyright.setup({})
lspcfg.clangd.setup({})
lspcfg.tsserver.setup({})

lsp.setup()

local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.setup({
	mapping = {
		['<CR>'] = cmp.mapping.confirm({select = false}),
	}
})

cmp.event:on(
	'confirm_done',
	cmp_autopairs.on_confirm_done()
)

vim.keymap.set("n", "<C-t>", "<cmd>NERDTreeToggle<cr>")

-- autocmd TermOpen * setlocal nonumber norelativenumber

vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.relativenumber = true

vim.api.nvim_set_option("clipboard","unnamed")

-- autocmds
local autocmd = vim.api.nvim_create_autocmd

autocmd({"TermOpen"}, {
	command = "setlocal nonumber norelativenumber"
})

-- latex
autocmd({"FileType"}, {
	pattern = {"tex"},
	command = "set textwidth=80"
})

autocmd({"FileType"}, {
	pattern = {"tex"},
	command = "setlocal spell spelllang=en_us"
})

-- C++
autocmd({"FileType"}, {
	pattern = {"cpp"},
	command = "nnoremap <buffer> <leader>b :!c++ % -o debugProg -g<CR>"
})

autocmd({"BufWritePost"}, {
	pattern = {"*.tex"},
	command = "silent! !pdflatex <afile>"
})
