vim.g.mapleader = " "
vim.opt.mouse = ""
vim.opt.swapfile = false
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.cmd([[hi @lsp.type.number gui=italic]])
vim.cmd([[set completeopt+=menuone,noselect,popup]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "oskarnurm/koda.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("koda").setup({ transparent = true })
      vim.cmd("colorscheme koda")
    end,
  },

  {
    "fnune/recall.nvim",
    opts = {},
    keys = {
      { "mm", "<cmd>RecallToggle<cr>", mode = "n", silent = true },
      { "mn", "<cmd>RecallNext<cr>", mode = "n", silent = true },
      { "mp", "<cmd>RecallPrevious<cr>", mode = "n", silent = true },
      { "mc", "<cmd>RecallClear<cr>", mode = "n", silent = true },
      { "ml", "<cmd>Telescope recall<cr>", mode = "n", silent = true },
    },
  },

  { "chentoast/marks.nvim", config = true },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup()
      vim.diagnostic.config({ virtual_text = false })
    end,
  },

  {
    "nvim-mini/mini.surround",
    version = false,
    config = function()
      require("mini.surround").setup()
    end,
  },

  {
    "nvim-mini/mini.move",
    version = false,
    config = function()
      require("mini.move").setup()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "python", "javascript", "bash" },
      highlight = { enable = true },
    },
    config = true,
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            width = { padding = 0 },
            height = { padding = 0 },
            preview_width = 0.5,
          },
        },
      },
    },
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").setup({ extensions = { ["ui-select"] = {} } })
      require("telescope").load_extension("ui-select")
    end,
  },

  {
    "LinArcX/telescope-env.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    lazy = false,
    opts = {
      servers = {
        tsserver = {
          on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
          end,
        },
      },
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_enable = true,
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
        },
      })
    end,
  },

  {
    "stevearc/oil.nvim",
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  { "github/copilot.vim" },

  { "aznhe21/actions-preview.nvim" },

  {
    "kylechui/nvim-surround",
    version = "^3.0.0",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  {
    "folke/zen-mode.nvim",
    opts = {},
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = true,
    },
  },
})

local telescope = require("telescope")
telescope.setup({
  defaults = {
    preview = { treesitter = false },
    sorting_strategy = "ascending",
    layout_config = { prompt_position = "top", preview_cutoff = 40 },
    borderchars = { "", "", "", "", "", "", "", "" },
    path_displays = { "smart" },
  },
})
telescope.load_extension("ui-select")

require("actions-preview").setup({
  backend = { "telescope" },
  extensions = { "env" },
  telescope = vim.tbl_extend("force", require("telescope.themes").get_dropdown(), {}),
})

require("oil").setup({
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
    autosave_changes = true,
  },
  columns = {
    "permissions",
    "icon",
  },
  float = {
    max_width = 0.7,
    max_height = 0.6,
    border = "rounded",
  },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

vim.lsp.config.tsserver = {
  settings = {
    typescript = {
      preferences = {
        importModuleSpecifier = "non-relative",
      },
    },
    javascript = {
      preferences = {
        importModuleSpecifier = "non-relative",
      },
    },
  },
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach", {}),
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  end,
})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "gr", builtin.lsp_references)
vim.keymap.set("n", "<leader><leader>", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>,", builtin.buffers)
vim.keymap.set("n", "<leader>sd", builtin.diagnostics)
vim.keymap.set("n", "<leader>sg", builtin.git_bcommits)
vim.keymap.set("n", "<leader>se", "<cmd>Telescope env<CR>")
vim.keymap.set("n", "<leader>sa", require("actions-preview").code_actions)

vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")
vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

vim.cmd(":hi statusline guibg=NONE")

local kitty_group = vim.api.nvim_create_augroup("kitty_mp", { clear = true })

local function kitty_spacing(padding, margin)
  local to = os.getenv("KITTY_LISTEN_ON")
  if not to then
    return
  end

  vim.fn.jobstart({
    "kitty",
    "@",
    "--to",
    to,
    "set-spacing",
    "padding=" .. padding,
    "margin=" .. margin,
  }, { detach = true })
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = kitty_group,
  callback = function()
    kitty_spacing(0, 0)
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = kitty_group,
  callback = function()
    kitty_spacing(20, 0)
  end,
})

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })
