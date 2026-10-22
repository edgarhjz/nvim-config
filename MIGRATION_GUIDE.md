# Neovim Configuration Migration Guide

This guide walks you through migrating your exact Neovim setup to a new computer (macOS or Linux).

Because your setup uses **`lazy.nvim`** with a locked **`lazy-lock.json`**, the migration is completely automated: Neovim will self-bootstrap and download the exact same plugin versions when first opened on the new machine.

---

## 1. Prerequisites on the New Machine

Before cloning your config, install Neovim and the core CLI tools required for fuzzy finding, code analysis, and syntax highlighting:

### macOS (via Homebrew)
```bash
brew install neovim git ripgrep fd node
```

### Linux (Ubuntu / Debian)
```bash
sudo apt update
sudo apt install -y neovim git ripgrep fd-find nodejs npm build-essential
```

### Linux (Arch Linux)
```bash
sudo pacman -S neovim git ripgrep fd nodejs npm base-devel
```

### Terminal Nerd Font
To ensure file icons, git symbols, and statusline glyphs render correctly:
1. Download and install any font from **[Nerd Fonts](https://www.nerdfonts.com/)** (recommended: *JetBrainsMono Nerd Font*).
2. Set it as your font in your terminal application (iTerm2, Alacritty, Kitty, WezTerm, Ghostty, or Terminal.app).

---

## 2. Option A: Using a Git Repository (Recommended)

### Step 1: Push Your Configuration (On Current Computer)
Run the following commands on your current machine to push your config to GitHub (or GitLab):

```bash
cd ~/.config/nvim

# Initialize git if not already done
git init

# Stage all files (includes lua/, init.lua, lazy-lock.json, etc.)
git add .

# Commit
git commit -m "feat: complete LazyVim + Josean keybindings setup"

# Push to your repository
git remote add origin https://github.com/<your-username>/nvim-config.git
git branch -M main
git push -u origin main
```

> [!IMPORTANT]
> Always ensure **`lazy-lock.json`** is committed and pushed. It freezes the exact commit hash of every installed plugin, ensuring nothing breaks when cloned on another machine.

---

### Step 2: Clone and Launch (On New Computer)

```bash
# 1. Back up any existing default nvim directory if present
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak

# 2. Clone your repository into ~/.config/nvim
git clone https://github.com/<your-username>/nvim-config.git ~/.config/nvim

# 3. Launch Neovim
nvim
```

---

## 3. Option B: Direct Copy / Offline Transfer (USB, AirDrop, Rsync)

If you prefer not to use GitHub, you can create a compressed archive of your config:

### Step 1: Create Archive (On Current Computer)
```bash
tar -czvf nvim-config.tar.gz -C ~/.config nvim
```

### Step 2: Extract (On New Computer)
Transfer `nvim-config.tar.gz` to the new computer, then run:

```bash
# Ensure ~/.config exists
mkdir -p ~/.config

# Extract into ~/.config/
tar -xzvf nvim-config.tar.gz -C ~/.config/

# Launch Neovim
nvim
```

---

## 4. What Happens on First Launch

When you open `nvim` for the first time:

1. **`lazy.nvim` auto-bootstraps**: Clones itself into `~/.local/share/nvim/lazy/lazy.nvim`.
2. **Plugin sync**: Automatically clones and checks out every plugin at the exact commit specified in `lazy-lock.json`.
3. **Treesitter parsers compile**: Syntax highlighters for your languages are compiled automatically.
4. **Mason installs tools**: Language servers, linters, and formatters defined in your configuration will download and set up.

Once the initial installation popups finish:
1. Close Neovim: `:qa`
2. Reopen Neovim: `nvim`
3. Everything is ready to go!

---

## 5. Verification & Health Check

Inside Neovim on the new machine, you can run these commands to verify everything is operating properly:

* `:checkhealth` — checks Neovim environment, clipboard, and tool dependencies.
* `:Lazy` — opens the plugin manager UI showing all active plugins.
* `:Mason` — opens the LSP / linter / formatter manager UI.

---

## 6. Troubleshooting / Clean Reset

If an interrupted internet connection or partial clone causes an issue during the first boot, you can cleanly reset the runtime data without touching your config:

```bash
# Clear downloaded plugins and caches (safe, does not delete ~/.config/nvim)
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

# Relaunch Neovim to restart the automatic setup
nvim
```
