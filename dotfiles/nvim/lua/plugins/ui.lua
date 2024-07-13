return {
  -- theme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('tokyonight')
    end,
  },
  -- {
  --   'kepano/flexoki-neovim',
  --   name = 'flexoki',
  --   lazy = false,
  --   config = function()
  --     vim.cmd('colorscheme flexoki-dark')
  --   end
  -- },
  -- nvim-tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'lewis6991/gitsigns.nvim',
    },
    keys = {
      { '<leader>t', '<cmd>NvimTreeToggle<cr>', desc = 'Open File Tree Toggle' },
    },
    opts = {
      filters = {
        dotfiles = false,
      },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = false,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        adaptive_size = true,
        side = "left",
        width = 30,
        preserve_window_proportions = true,
      },
      git = {
        enable = true,
        ignore = true,
      },
      filesystem_watchers = {
        enable = true,
      },
      actions = {
        open_file = {
          resize_window = true,
        },
      },
      renderer = {
        root_folder_label = false,
        highlight_git = true,
        highlight_opened_files = "none",

        indent_markers = {
          enable = true,
        },

        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },

          glyphs = {
            default = "󰈚",
            symlink = "",
            folder = {
              default = "",
              empty = "",
              empty_open = "",
              open = "",
              symlink = "",
              symlink_open = "",
              arrow_open = "",
              arrow_closed = "",
            },
            git = {
              unstaged = "✗",
              staged = " ✓",
              unmerged = " ",
              renamed = "➜",
              untracked = " ",
              deleted = "󰷇 ",
              ignored = "◌",
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)

      local uv = vim.loop
      local handle_git
      local on_exit = function(status)
        if status == 0 then
          vim.api.nvim_exec_autocmds("User", {
            pattern = "Git"
          })
        end
        uv.close(handle_git)
      end
      on_exit = vim.schedule_wrap(on_exit)
      handle_git = uv.spawn("git", { args = { "status" } }, on_exit)
    end,
  },

  -- gitsigns
  {
    'lewis6991/gitsigns.nvim',
    event = "User Git",
    opts = {
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '-' },
        topdelete    = { text = '*' },
        changedelete = { text = '~-' },
        untracked    = { text = '_' },
      },
    },
    config = function(_, opts)
      require('gitsigns').setup(opts)
    end,
  },

  -- bufferline
  {
    'akinsho/bufferline.nvim',
    event = 'User Bufferline',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          local function _trigger()
            vim.api.nvim_exec_autocmds("User", { pattern = "Bufferline" })
          end

          if vim.bo.filetype == '' then
            vim.api.nvim_create_autocmd("BufRead", {
              once = true,
              callback = _trigger,
            })
          else
            _trigger()
          end
        end,
      })
    end,
    opts = {
      options = {
        separator_style = "thin",
        themable = true,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- term
  {
    dir = "term",
    keys = {
      { '<A-h>', '<cmd>TermToggle sp htoggleTerm 0.3<cr>', desc = 'Toggle Horizontal Terminal', mode = { "n", "t" } }
    },
    config = function()
      require('term').setup()
    end,
  }
}
