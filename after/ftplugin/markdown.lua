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

local function skim_refresh(pdf)
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
]], pdf)

  vim.fn.jobstart({ "osascript", "-e", script }, { detach = true })
end

local function build_pdf()
  local md, pdf = paths()
  if not md then
    return
  end

  vim.fn.jobstart({
    "pandoc",
    md,
    "-o", pdf,
    "--pdf-engine=xelatex",
    "--pdf-engine-opt=-synctex=1",
  }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.schedule(function()
          skim_refresh(pdf)
        end)
      else
        vim.schedule(function()
          vim.notify("PDF build fallita", vim.log.levels.ERROR)
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
