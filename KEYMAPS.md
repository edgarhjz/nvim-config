# Neovim Keymaps Reference Guide

> **Leader Key**: `<Space>` (Spacebar)

---

## 1. General & Editing

| Mode | Keybinding | Description |
| :---: | :--- | :--- |
| **Insert** | `jk` | Fast exit from insert mode to normal mode (`<ESC>`) |
| **Normal** | `<leader>nh` | Clear search highlights (`:nohl`) |
| **Normal** | `<leader>+` | Increment number under cursor (`<C-a>`) |
| **Normal** | `<leader>-` | Decrement number under cursor (`<C-x>`) |

---

## 2. Window Splits & Navigation

### Window Management
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `<leader>sv` | Split Vertically | Splits current window vertically (`<C-w>v`) |
| `<leader>sh` | Split Horizontally | Splits current window horizontally (`<C-w>s`) |
| `<leader>se` | Equalize Splits | Makes all split windows equal size (`<C-w>=`) |
| `<leader>sx` | Close Split | Closes current split window (protects Explorer from closing) |
| `<leader>sm` | Maximize / Restore | Toggles split window maximize / restore (`Snacks.zen.zoom`) |

### Window Navigation
| Keybinding | Description |
| :--- | :--- |
| `<C-h>` | Move cursor to **Left** window (e.g. from editor into Explorer) |
| `<C-l>` | Move cursor to **Right** window (e.g. from Explorer into editor) |
| `<C-j>` | Move cursor to **Lower** window |
| `<C-k>` | Move cursor to **Upper** window |

---

## 3. Tab Management

> **Note**: Tabline is configured in `mode = "tabs"`, displaying Vim tabpages across the top.

| Keybinding | Description |
| :--- | :--- |
| `<leader>to` | Open a new tab (`:tabnew`) |
| `<leader>tx` | Close current tab (`:tabclose`) / closes buffer if only 1 tab remains |
| `<leader>tn` | Go to **Next** tab (`:tabn`) / next buffer |
| `<leader>tp` | Go to **Previous** tab (`:tabp`) / previous buffer |
| `<leader>tf` | Open current buffer into a **New Tab** (`:tabnew %`) |

---

## 4. File Explorer (`nvim-tree`)

### Global Shortcuts (from anywhere)
| Keybinding | Description |
| :--- | :--- |
| `<leader>ee` or `<leader>e` | Toggle file explorer open / closed |
| `<leader>ef` | Find current file and **focus** inside the explorer |
| `<leader>ec` | Collapse all open folders in the explorer |
| `<leader>er` | Refresh file explorer tree |

### Shortcuts Inside the Explorer Window
| Keybinding | Description |
| :--- | :--- |
| `<CR>` or `o` | Open file in the active editor window |
| `<C-v>` | Open file in a **Vertical Split** (side-by-side, keeping current file open) |
| `<C-x>` | Open file in a **Horizontal Split** (split below, keeping current file open) |
| `<C-t>` | Open file in a **New Tab** |
| `a` | Create a new file or directory (add `/` at end for folder) |
| `d` | Delete file or directory |
| `r` | Rename file |
| `c` | Copy file |
| `p` | Paste file |
| `x` | Cut file |
| `y` | Copy file name |
| `Y` | Copy relative file path |
| `gy` | Copy absolute file path |
| `I` | Toggle hidden / gitignored files visibility |
| `H` | Toggle dotfiles visibility |
| `R` | Refresh tree |
| `q` | Close explorer |

---

## 5. Search & Fuzzy Finding

| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `<leader>ff` | Find Files | Fuzzy search files in current working directory |
| `<leader>fr` | Recent Files | Search recently opened files |
| `<leader>fs` | Live Grep | Search for text string across all project files |
| `<leader>fc` | Grep String | Search for the exact word under cursor across project |
| `<leader>ft` | Find TODOs | Search for `TODO`, `FIXME`, `BUG`, `NOTE` comments |
| `<leader>fk` | Find Keymaps | Search and discover all active keymaps |

---

## 6. Code Formatting & Linting

| Keybinding | Description |
| :--- | :--- |
| `<leader>mp` | Format current file or selected range (visual mode) via `conform.nvim` |
| `<leader>l` | Trigger linting on current file via `nvim-lint` |
| `<leader>L` | Open **Lazy** plugin manager UI |

---

## 7. Git & LazyGit (`gitsigns` & `snacks.lazygit`)

| Keybinding | Description |
| :--- | :--- |
| `<leader>lg` | Open full interactive **LazyGit** terminal UI |
| `]h` | Jump to **Next** git change hunk |
| `[h` | Jump to **Previous** git change hunk |
| `<leader>hs` | Stage current git hunk (Normal / Visual mode) |
| `<leader>hr` | Reset / discard current git hunk (Normal / Visual mode) |
| `<leader>hS` | Stage entire buffer |
| `<leader>hR` | Reset / discard entire buffer |
| `<leader>hu` | Undo last staged hunk |
| `<leader>hp` | Preview hunk diff inline |
| `<leader>hb` | Show git blame for current line |
| `<leader>hB` | Toggle inline git blame |
| `<leader>hd` | Diff against index (`diffthis`) |
| `<leader>hD` | Diff against previous commit (`diffthis ~`) |

---

## 8. LSP & Code Intelligence

| Keybinding | Description |
| :--- | :--- |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gR` | Find and show all LSP references in picker |
| `gi` | Find all implementations in picker |
| `gt` | Find all type definitions in picker |
| `K` | Hover documentation popup |
| `<leader>rn` | Smart rename symbol across project |
| `<leader>ca` | Show available Code Actions (Normal / Visual mode) |
| `<leader>d` | Show line diagnostics in floating window |
| `<leader>D` | Show all buffer diagnostics in picker list |
| `[d` | Jump to **Previous** diagnostic error/warning |
| `]d` | Jump to **Next** diagnostic error/warning |
| `<leader>rs` | Restart LSP server (`:LspRestart`) |

---

## 9. Diagnostics & Trouble (`trouble.nvim`)

| Keybinding | Description |
| :--- | :--- |
| `<leader>xw` | Open workspace diagnostics in Trouble panel |
| `<leader>xd` | Open current document diagnostics in Trouble panel |
| `<leader>xq` | Open Quickfix list in Trouble |
| `<leader>xl` | Open Location list in Trouble |
| `<leader>xt` | Open all project TODO comments in Trouble |

---

## 10. Workspace Sessions (`persistence.nvim`)

| Keybinding | Description |
| :--- | :--- |
| `<leader>wr` | Restore saved workspace session for current directory |
| `<leader>ws` | Save current workspace session |

---

## 11. Text Object & Comment Navigation

| Keybinding | Description |
| :--- | :--- |
| `]t` | Jump to **Next** TODO comment |
| `[t` | Jump to **Previous** TODO comment |
