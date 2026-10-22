-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local keymap = vim.keymap

-- -----------------------------------------------------------------------------
-- 1. General & Navigation (from nvim-josean)
-- -----------------------------------------------------------------------------
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })

-- Close current split / editor (keeps NvimTree open on the left at fixed width, closes editor or split)
local function close_split_or_editor()
  local tab_wins = vim.api.nvim_tabpage_list_wins(0)
  local tree_win = nil
  local editor_wins = {}

  for _, w in ipairs(tab_wins) do
    local b = vim.api.nvim_win_get_buf(w)
    if vim.bo[b].filetype == "NvimTree" then
      tree_win = w
    else
      table.insert(editor_wins, w)
    end
  end

  if #editor_wins > 1 then
    -- Multiple editor splits exist: close the current split window and delete its buffer
    local cur = vim.api.nvim_get_current_win()
    local target_win = (cur ~= tree_win) and cur or editor_wins[#editor_wins]
    local target_buf = vim.api.nvim_win_get_buf(target_win)

    vim.api.nvim_win_close(target_win, false)
    if vim.api.nvim_buf_is_valid(target_buf) and vim.bo[target_buf].buflisted and vim.api.nvim_buf_get_name(target_buf) ~= "" then
      pcall(vim.api.nvim_buf_delete, target_buf, { force = true })
    end
    if tree_win and vim.api.nvim_win_is_valid(tree_win) then
      vim.api.nvim_set_current_win(tree_win)
    end
  elseif #editor_wins == 1 then
    -- Only one editor window next to NvimTree:
    -- 1. Create an UNLISTED scratch buffer (buflisted=false so bufferline never opens a tab for it!)
    local ed_win = editor_wins[1]
    local old_buf = vim.api.nvim_win_get_buf(ed_win)
    local empty_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[empty_buf].buftype = "nofile"
    vim.bo[empty_buf].bufhidden = "wipe"
    vim.api.nvim_win_set_buf(ed_win, empty_buf)

    -- 2. Fully delete the old buffer so it's closed and removed from bufferline!
    if vim.api.nvim_buf_is_valid(old_buf) and vim.api.nvim_buf_get_name(old_buf) ~= "" then
      pcall(vim.api.nvim_buf_delete, old_buf, { force = true })
    end

    -- 3. Return focus to NvimTree on the left
    if tree_win and vim.api.nvim_win_is_valid(tree_win) then
      vim.api.nvim_set_current_win(tree_win)
    end
  elseif tree_win then
    -- NvimTree is full screen: create right split with unlisted scratch buffer
    vim.api.nvim_set_current_win(tree_win)
    vim.cmd("belowright vsplit")
    local new_win = vim.api.nvim_get_current_win()
    local empty_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[empty_buf].buftype = "nofile"
    vim.bo[empty_buf].bufhidden = "wipe"
    vim.api.nvim_win_set_buf(new_win, empty_buf)
    vim.api.nvim_set_current_win(tree_win)
  else
    vim.cmd("close")
  end
end

keymap.set("n", "<leader>sx", close_split_or_editor, { desc = "Close current split window" })

-- maximize/minimize split (josean: vim-maximizer, lazyvim: snacks zoom)
keymap.set("n", "<leader>sm", function()
  if vim.fn.exists(":MaximizerToggle") == 2 then
    vim.cmd("MaximizerToggle")
  elseif _G.Snacks and Snacks.zen and Snacks.zen.zoom then
    Snacks.zen.zoom()
  else
    vim.cmd("wincmd _ | wincmd |")
  end
end, { desc = "Maximize/minimize a split" })

-- tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })

-- Close current tab (if multiple tabs exist, close tab; otherwise close buffer safely)
keymap.set("n", "<leader>tx", function()
  if vim.fn.tabpagenr("$") > 1 then
    vim.cmd("tabclose")
  else
    if _G.Snacks and Snacks.bufdelete then
      Snacks.bufdelete()
    else
      vim.cmd("bdelete")
    end
  end
end, { desc = "Close current tab" })

-- Next tab (if multiple tabs exist, next tab; otherwise next buffer)
keymap.set("n", "<leader>tn", function()
  if vim.fn.tabpagenr("$") > 1 then
    vim.cmd("tabnext")
  else
    vim.cmd("bnext")
  end
end, { desc = "Go to next tab" })

-- Previous tab (if multiple tabs exist, previous tab; otherwise previous buffer)
keymap.set("n", "<leader>tp", function()
  if vim.fn.tabpagenr("$") > 1 then
    vim.cmd("tabprev")
  else
    vim.cmd("bprev")
  end
end, { desc = "Go to previous tab" })

keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- -----------------------------------------------------------------------------
-- 2. File Explorer (NvimTree like in nvim-josean)
-- -----------------------------------------------------------------------------
local function toggle_explorer()
  local ok, api = pcall(require, "nvim-tree.api")
  if ok then
    api.tree.toggle()
  elseif _G.Snacks and Snacks.explorer then
    Snacks.explorer()
  else
    vim.cmd("Ex")
  end
end

local function reveal_in_explorer()
  local ok, api = pcall(require, "nvim-tree.api")
  if ok then
    api.tree.find_file({ open = true, focus = true })
  elseif _G.Snacks and Snacks.explorer then
    Snacks.explorer.reveal()
  else
    vim.cmd("Ex")
  end
end

local function collapse_explorer()
  local ok, api = pcall(require, "nvim-tree.api")
  if ok then
    api.tree.collapse_all()
  elseif _G.Snacks and Snacks.explorer then
    Snacks.explorer.close()
  end
end

local function refresh_explorer()
  local ok, api = pcall(require, "nvim-tree.api")
  if ok then
    api.tree.reload()
  end
end

keymap.set("n", "<leader>ee", toggle_explorer, { desc = "Toggle file explorer" })
keymap.set("n", "<leader>e", toggle_explorer, { desc = "Toggle file explorer" })
keymap.set("n", "<leader>ef", reveal_in_explorer, { desc = "Toggle file explorer on current file" })
keymap.set("n", "<leader>ec", collapse_explorer, { desc = "Collapse file explorer" })
keymap.set("n", "<leader>er", refresh_explorer, { desc = "Refresh file explorer" })

-- -----------------------------------------------------------------------------
-- 3. Search / Fuzzy Finding (josean: telescope, lazyvim: snacks picker / telescope)
-- -----------------------------------------------------------------------------
keymap.set("n", "<leader>ff", function()
  if _G.Snacks and Snacks.picker then
    Snacks.picker.files()
  elseif vim.fn.exists(":Telescope") == 2 then
    vim.cmd("Telescope find_files")
  end
end, { desc = "Fuzzy find files in cwd" })

keymap.set("n", "<leader>fr", function()
  if _G.Snacks and Snacks.picker then
    Snacks.picker.recent()
  elseif vim.fn.exists(":Telescope") == 2 then
    vim.cmd("Telescope oldfiles")
  end
end, { desc = "Fuzzy find recent files" })

keymap.set("n", "<leader>fs", function()
  if _G.Snacks and Snacks.picker then
    Snacks.picker.grep()
  elseif vim.fn.exists(":Telescope") == 2 then
    vim.cmd("Telescope live_grep")
  end
end, { desc = "Find string in cwd (live grep)" })

keymap.set("n", "<leader>fc", function()
  if _G.Snacks and Snacks.picker then
    Snacks.picker.grep_word()
  elseif vim.fn.exists(":Telescope") == 2 then
    vim.cmd("Telescope grep_string")
  end
end, { desc = "Find string under cursor in cwd" })

keymap.set("n", "<leader>ft", function()
  if vim.fn.exists(":TodoTrouble") == 2 then
    vim.cmd("TodoTrouble")
  elseif vim.fn.exists(":TodoTelescope") == 2 then
    vim.cmd("TodoTelescope")
  elseif _G.Snacks and Snacks.picker then
    Snacks.picker.grep({ search = "TODO|FIX|FIXME|BUG|HACK|NOTE", regex = true })
  else
    vim.cmd("TodoQuickFix")
  end
end, { desc = "Find todos" })

keymap.set("n", "<leader>fk", function()
  if _G.Snacks and Snacks.picker then
    Snacks.picker.keymaps()
  elseif vim.fn.exists(":Telescope") == 2 then
    vim.cmd("Telescope keymaps")
  end
end, { desc = "Find keymaps" })

-- -----------------------------------------------------------------------------
-- 4. Code Formatting & Linting (conform & nvim-lint)
-- -----------------------------------------------------------------------------
keymap.set({ "n", "v" }, "<leader>mp", function()
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
  else
    vim.lsp.buf.format({ async = false })
  end
end, { desc = "Format file or range (in visual mode)" })

-- Map <leader>L to Lazy so <leader>l can be used for linting without losing access to Lazy UI
keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy plugin manager" })

keymap.set("n", "<leader>l", function()
  local ok, lint = pcall(require, "lint")
  if ok then
    lint.try_lint()
  end
end, { desc = "Trigger linting for current file" })

-- -----------------------------------------------------------------------------
-- 5. Git / LazyGit & Gitsigns
-- -----------------------------------------------------------------------------
keymap.set("n", "<leader>lg", function()
  if vim.fn.exists(":LazyGit") == 2 then
    vim.cmd("LazyGit")
  elseif _G.Snacks and Snacks.lazygit then
    Snacks.lazygit()
  end
end, { desc = "Open lazy git" })

local function gs()
  return package.loaded.gitsigns
end

keymap.set("n", "<leader>hs", function() if gs() then gs().stage_hunk() end end, { desc = "Stage hunk" })
keymap.set("v", "<leader>hs", function() if gs() then gs().stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end end, { desc = "Stage hunk" })
keymap.set("n", "<leader>hr", function() if gs() then gs().reset_hunk() end end, { desc = "Reset hunk" })
keymap.set("v", "<leader>hr", function() if gs() then gs().reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end end, { desc = "Reset hunk" })
keymap.set("n", "<leader>hS", function() if gs() then gs().stage_buffer() end end, { desc = "Stage buffer" })
keymap.set("n", "<leader>hR", function() if gs() then gs().reset_buffer() end end, { desc = "Reset buffer" })
keymap.set("n", "<leader>hu", function() if gs() then gs().undo_stage_hunk() end end, { desc = "Undo stage hunk" })
keymap.set("n", "<leader>hp", function() if gs() then gs().preview_hunk() end end, { desc = "Preview hunk" })
keymap.set("n", "<leader>hb", function() if gs() then gs().blame_line({ full = true }) end end, { desc = "Blame line" })
keymap.set("n", "<leader>hB", function() if gs() then gs().toggle_current_line_blame() end end, { desc = "Toggle line blame" })
keymap.set("n", "<leader>hd", function() if gs() then gs().diffthis() end end, { desc = "Diff this" })
keymap.set("n", "<leader>hD", function() if gs() then gs().diffthis("~") end end, { desc = "Diff this ~" })

-- -----------------------------------------------------------------------------
-- 6. Trouble Diagnostics (trouble.nvim)
-- -----------------------------------------------------------------------------
keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Open trouble workspace diagnostics" })
keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Open trouble document diagnostics" })
keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix toggle<cr>", { desc = "Open trouble quickfix list" })
keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Open trouble location list" })
keymap.set("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "Open todos in trouble" })

-- -----------------------------------------------------------------------------
-- 7. Workspace Sessions (josean: auto-session, lazyvim: persistence.nvim)
-- -----------------------------------------------------------------------------
keymap.set("n", "<leader>wr", function()
  if vim.fn.exists(":AutoSession") == 2 then
    vim.cmd("AutoSession restore")
  else
    local ok, persistence = pcall(require, "persistence")
    if ok then
      persistence.load()
    end
  end
end, { desc = "Restore session for cwd" })

keymap.set("n", "<leader>ws", function()
  if vim.fn.exists(":AutoSession") == 2 then
    vim.cmd("AutoSession save")
  else
    local ok, persistence = pcall(require, "persistence")
    if ok then
      persistence.save()
    end
  end
end, { desc = "Save session for cwd" })

-- -----------------------------------------------------------------------------
-- 8. LSP Navigation & Actions (josean style: gR, gi, gt, <leader>rn, <leader>d, <leader>D, <leader>rs)
-- -----------------------------------------------------------------------------
keymap.set("n", "gR", function()
  if _G.Snacks and Snacks.picker then
    Snacks.picker.lsp_references()
  elseif vim.fn.exists(":Telescope") == 2 then
    vim.cmd("Telescope lsp_references")
  else
    vim.lsp.buf.references()
  end
end, { desc = "Show LSP references" })

keymap.set("n", "gi", function()
  if _G.Snacks and Snacks.picker then
    Snacks.picker.lsp_implementations()
  elseif vim.fn.exists(":Telescope") == 2 then
    vim.cmd("Telescope lsp_implementations")
  else
    vim.lsp.buf.implementation()
  end
end, { desc = "Show LSP implementations" })

keymap.set("n", "gt", function()
  if _G.Snacks and Snacks.picker then
    Snacks.picker.lsp_type_definitions()
  elseif vim.fn.exists(":Telescope") == 2 then
    vim.cmd("Telescope lsp_type_definitions")
  else
    vim.lsp.buf.type_definition()
  end
end, { desc = "Show LSP type definitions" })

keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart rename" })
keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

keymap.set("n", "<leader>D", function()
  if _G.Snacks and Snacks.picker then
    Snacks.picker.diagnostics({ filter = { bufnr = 0 } })
  elseif vim.fn.exists(":Telescope") == 2 then
    vim.cmd("Telescope diagnostics bufnr=0")
  else
    vim.diagnostic.setqflist()
  end
end, { desc = "Show buffer diagnostics" })

keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP" })

-- Diagnostic navigation (support Neovim 0.10+ and legacy)
keymap.set("n", "[d", function()
  if vim.diagnostic.jump then
    vim.diagnostic.jump({ count = -1, float = true })
  else
    vim.diagnostic.goto_prev()
  end
end, { desc = "Go to previous diagnostic" })

keymap.set("n", "]d", function()
  if vim.diagnostic.jump then
    vim.diagnostic.jump({ count = 1, float = true })
  else
    vim.diagnostic.goto_next()
  end
end, { desc = "Go to next diagnostic" })

-- -----------------------------------------------------------------------------
-- 9. Substitute (substitute.nvim if installed)
-- -----------------------------------------------------------------------------
local sub_ok, substitute = pcall(require, "substitute")
if sub_ok then
  keymap.set("n", "<leader>r", substitute.operator, { desc = "Substitute with motion" })
  keymap.set("n", "<leader>rr", substitute.line, { desc = "Substitute line" })
  keymap.set("n", "<leader>R", substitute.eol, { desc = "Substitute to end of line" })
  keymap.set("x", "<leader>r", substitute.visual, { desc = "Substitute in visual mode" })
end
