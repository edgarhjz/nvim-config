# ⚡ Custom Neovim Configuration

A modern, fast, and feature-complete Neovim IDE built on top of **[LazyVim](https://github.com/LazyVim/LazyVim)**, customized for maximum developer productivity, ergonomic window split management, and a persistent sidebar workflow.

Refer to the official [LazyVim documentation](https://lazyvim.github.io/installation) for details on the base architecture and plugin ecosystem.

---

## 🌟 What This Configuration Does

This setup extends LazyVim with tailored keybindings, a persistent file explorer, and clean workspace tab management designed for smooth multi-file navigation:

* **Persistent Sidebar File Explorer (`nvim-tree.lua`)**:
  * Configured with custom folder icons, tree markers, and relative line numbers.
  * **Protected Split Closing (`<leader>sx`)**: Closes active editor splits without collapsing or expanding the file explorer into full screen.
  * **Multi-Split Opening from Explorer**: Open files directly into vertical splits (`<C-v>`), horizontal splits (`<C-x>`), or new tabs (`<C-t>`) straight from the file tree.
  * Quick access: Toggle with `<leader>ee` / `<leader>e`, or reveal and focus the current file with `<leader>ef`.

* **Clean Workspace Tab Management (`bufferline.nvim`)**:
  * Configured in `mode = "tabs"` so the top bar displays actual workspace tabs (`Tab 1`, `Tab 2`), keeping your screen free of file clutter.
  * Rapid tab navigation: `<leader>to` (new tab), `<leader>tx` (close tab), `<leader>tn` (next tab), `<leader>tp` (previous tab), and `<leader>tf` (open current file in new tab).

* **Ergonomic Window & Split Management**:
  * Fast window splits: `<leader>sv` (vertical split), `<leader>sh` (horizontal split), and `<leader>se` (equalize split sizes).
  * Smooth window navigation using `<C-h>`, `<C-j>`, `<C-k>`, and `<C-l>`.
  * Quick split zoom / toggle maximize with `<leader>sm`.

* **Fuzzy Finding & Code Search**:
  * Find files with `<leader>ff`, recent files with `<leader>fr`, project-wide live grep with `<leader>fs`, and cursor word search with `<leader>fc`.
  * Search project TODO comments with `<leader>ft` and view diagnostics with `<leader>xw`.

* **Formatting, Linting & LSP**:
  * Automatic formatting via **`conform.nvim`** (`<leader>mp`).
  * On-demand file linting via **`nvim-lint`** (`<leader>l`).
  * Modern, lightning-fast autocompletion powered by **`blink.cmp`**.
  * LSP symbol navigation: `gR` (references), `gi` (implementations), `gt` (type definitions), `<leader>rn` (rename), and `K` (hover documentation).

* **Git & Terminal Integration**:
  * Full interactive **LazyGit** terminal UI with `<leader>lg`.
  * Inline git hunk staging, resetting, and blame with `]h`, `[h`, `<leader>hs`, `<leader>hr`, `<leader>hp`, and `<leader>hb`.

---

## 📖 Documentation

* **[KEYMAPS.md](KEYMAPS.md)** — Comprehensive cheat sheet of all configured shortcuts and mode-specific keybindings.
* **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** — Step-by-step instructions to clone, bootstrap, and run this configuration on any other machine (macOS or Linux).

---

## 🚀 Quick Start / Installation

### 1. Prerequisites

* **Neovim** (>= 0.10.0)
* **Git**, **ripgrep**, **fd**, and **Node.js**
* Any **[Nerd Font](https://www.nerdfonts.com/)** (e.g., *JetBrainsMono Nerd Font*) set in your terminal for icons.

```bash
# macOS
brew install neovim ripgrep fd git node

# Ubuntu / Debian
sudo apt install -y neovim ripgrep fd-find git nodejs npm build-essential
```

### 2. Clone the Configuration

```bash
# Back up any existing nvim directory
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak

# Clone into ~/.config/nvim
git clone https://github.com/<your-username>/nvim-config.git ~/.config/nvim
```

### 3. Launch Neovim

```bash
nvim
```

`lazy.nvim` will automatically bootstrap itself, clone and check out all plugins at the exact locked versions in `lazy-lock.json`, compile Treesitter parsers, and set up the IDE.

---

## 📂 Project Structure

```
~/.config/nvim/
├── init.lua                  # Neovim entry point
├── lazy-lock.json            # Locked plugin commit hashes for 100% reproducibility
├── lazyvim.json              # LazyVim state & extras configuration
├── KEYMAPS.md                # Full keymap reference manual
├── MIGRATION_GUIDE.md        # Machine-to-machine migration guide
├── .gitignore                # Optimized ignore rules for Neovim repos
└── lua/
    ├── config/
    │   ├── autocmds.lua      # Custom auto-commands
    │   ├── keymaps.lua       # Unified custom keybindings
    │   ├── lazy.lua          # Lazy.nvim setup and immediate keymap loader
    │   └── options.lua       # Editor options
    └── plugins/
        ├── bufferline.lua    # Tabline configured to mode = "tabs"
        ├── nvim-tree.lua     # Persistent sidebar file explorer
        └── snacks.lua        # Snacks module customization
```
