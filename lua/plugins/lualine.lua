return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
  config = function()
    -- set bufferline across all width
    vim.opt.laststatus = 3


    local lualine = require("lualine")
    require("nvim-navic").setup({ highlight = false, separator = " > " })

    -- Ascii emoji as mode in bufferline
    local mode_map = {
      n = "(ᴗ_ ᴗ。)",
      nt = "(ᴗ_ ᴗ。)",
      i = "(•̀ - •́ )",
      R = "( •̯́ ₃ •̯̀)",
      v = "(⊙ _ ⊙ )",
      V = "(⊙ _ ⊙ )",
      no = "Σ(°△°ꪱꪱꪱ)",
      ["\22"] = "(⊙ _ ⊙ )",
      t = "(⌐■_■)",
      ["!"] = "Σ(°△°ꪱꪱꪱ)",
      c = "Σ(°△°ꪱꪱꪱ)",
      s = "SUB",
    }

    lualine.setup({
      options = {
        theme = "auto", --set theme name to get the color color independent of theme
        component_separators = "",
        -- section_separators = { left = '', right = '' },
        section_separators = {
          left = "",
          right = "",
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            -- separator = { left = '' },
            fmt = function()
              return mode_map[vim.api.nvim_get_mode().mode] or vim.api.nvim_get_mode().mode
            end,
            right_padding = 2,
          },
        },
        lualine_b = {
          {
            "branch",
            fmt = function(s)
              if #s > 12 then return s:sub(1, 12) .. ".." end
              return s
            end,
          },
          "diff",
          {
            function()
              local MAX_WIDTH = math.floor(vim.o.columns * 0.6)
              local relpath = vim.fn.expand("%:.")
              if relpath == "" then return "" end
              local modified = vim.bo.modified and "+" or " "

              local path_parts = vim.split(relpath, "/", { plain = true })
              local filename = path_parts[#path_parts]
              local dirs = vim.g.statusline_show_path and {} or nil
              if dirs then
                for i = 1, #path_parts - 1 do
                  table.insert(dirs, path_parts[i])
                end
              end

              local function build(ds, fname, navic_parts)
                local p = (ds and #ds > 0) and (table.concat(ds, "/") .. "/" .. fname) or fname
                if navic_parts and #navic_parts > 0 then
                  p = p .. " > " .. table.concat(navic_parts, " > ")
                end
                return "[" .. modified .. "] " .. p
              end

              local function shorten(s)
                if #s > 4 then return s:sub(1, 2) .. ".." end
                return s
              end

              local navic_parts = {}
              if vim.g.statusline_show_breadcrumbs then
                local ok, navic = pcall(require, "nvim-navic")
                if ok and navic.is_available() then
                  local data = navic.get_data()
                  if data then
                    for _, item in ipairs(data) do
                      table.insert(navic_parts, item.name)
                    end
                  end
                end
              end

              local full = build(dirs, filename, navic_parts)
              if #full <= MAX_WIDTH then return full end

              local short_dirs = nil
              if dirs then
                short_dirs = {}
                for _, d in ipairs(dirs) do
                  table.insert(short_dirs, shorten(d))
                end
              end
              local short_navic = {}
              for _, p in ipairs(navic_parts) do
                table.insert(short_navic, shorten(p))
              end
              return build(short_dirs, filename, short_navic)
            end,
          },
        },
        lualine_c = {
          {
            function()
              local t = require("todo_pile").top_text()
              return t ~= "" and ("● " .. t) or ""
            end,
          },
        },
        lualine_x = {
          "diagnostics",
        },
        lualine_y = { "filetype", "progress" },
        lualine_z = {
          {
            "location",
            -- separator = { right = '' },
            left_padding = 2,
          },
        },
      },
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
      tabline = {},
      extensions = {},
    })
  end,
}
