vim.b.render_pdf_on_save = vim.b.render_pdf_on_save or false

local function paths()
  local md = vim.api.nvim_buf_get_name(0)
  if md == "" then
    return nil, nil
  end

  local tmp_dir = (vim.uv and vim.uv.os_tmpdir and vim.uv.os_tmpdir()) or "/tmp"
  local out_dir = tmp_dir .. "/nvim-markdown-pdf"
  vim.fn.mkdir(out_dir, "p")

  local stem = vim.fn.fnamemodify(md, ":t:r")
  local digest = vim.fn.sha256(md):sub(1, 8)
  local pdf = string.format("%s/%s-%s.pdf", out_dir, stem, digest)
  return md, pdf
end

local function pick_pdf_engine()
  local engines = { "xelatex", "lualatex", "pdflatex" }
  for _, engine in ipairs(engines) do
    if vim.fn.executable(engine) == 1 then
      return engine
    end
  end
  return nil
end

local has_skim = vim.fn.has("macunix") == 1
  and vim.fn.isdirectory("/Applications/Skim.app") == 1
  and vim.fn.executable("osascript") == 1

local function skim_refresh(pdf)
  local escaped_pdf = pdf:gsub("\\", "\\\\"):gsub('"', '\\"')
  local script = string.format([[
set theFile to POSIX file "%s" as alias
tell application "Skim"
  set theDocs to get documents whose path is (get POSIX path of theFile)
  if (count of theDocs) > 0 then
    revert theDocs
  else
    open theFile
  end if
end tell
]], escaped_pdf)

  vim.fn.jobstart({ "osascript", "-e", script }, { detach = true })
end

local function open_pdf(pdf)
  if has_skim then
    skim_refresh(pdf)
    return
  end

  if vim.ui and vim.ui.open then
    vim.ui.open(pdf)
    return
  end

  if vim.fn.has("macunix") == 1 then
    vim.fn.jobstart({ "open", pdf }, { detach = true })
    return
  end

  if vim.fn.has("unix") == 1 and vim.fn.executable("xdg-open") == 1 then
    vim.fn.jobstart({ "xdg-open", pdf }, { detach = true })
    return
  end

  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    vim.fn.jobstart({ "cmd.exe", "/c", "start", "", pdf }, { detach = true })
    return
  end

  vim.notify("PDF generated but no system opener found.", vim.log.levels.WARN)
end

local function build_pdf()
  local md, pdf = paths()
  if not md then
    return
  end

  if vim.fn.executable("pandoc") ~= 1 then
    vim.notify("pandoc not found in PATH", vim.log.levels.ERROR)
    return
  end

  local engine = pick_pdf_engine()
  if not engine then
    vim.notify("No TeX PDF engine found (xelatex/lualatex/pdflatex).", vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart({
    "pandoc",
    md,
    "-o", pdf,
    "--pdf-engine=" .. engine,
    "--pdf-engine-opt=-synctex=1",
  }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.schedule(function()
          open_pdf(pdf)
        end)
      else
        vim.schedule(function()
          vim.notify("PDF build failed", vim.log.levels.ERROR)
        end)
      end
    end,
  })
end

local function toggle_render()
  vim.b.render_pdf_on_save = not vim.b.render_pdf_on_save
  if vim.b.render_pdf_on_save then
    vim.notify("PDF render on save: ON")
    build_pdf()
  else
    vim.notify("PDF render on save: OFF")
  end
end

vim.api.nvim_create_autocmd("BufWritePost", {
  buffer = 0,
  callback = function()
    if vim.b.render_pdf_on_save then
      build_pdf()
    end
  end,
})

vim.keymap.set("n", "<leader>mmr", toggle_render, { buffer = 0, desc = "Toggle auto PDF rendering on save" })
vim.keymap.set("n", "<leader>mmp", build_pdf, { buffer = 0, desc = "Render PDF now" })
