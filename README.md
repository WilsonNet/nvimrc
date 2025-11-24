# Neovim Configuration

A modern, feature-rich Neovim configuration focused on productivity and extensibility.

## Features

- **Plugin Management**: Lazy-loaded plugins via [lazy.nvim](https://github.com/folke/lazy.nvim)
- **File Navigation**: [Telescope](https://github.com/nvim-telescope/telescope.nvim) for fuzzy finding
- **Syntax Highlighting**: [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) for advanced parsing
- **LSP Support**: Built-in LSP with [lsp-zero](https://github.com/VonHeikemen/lsp-zero.nvim) and [Mason](https://github.com/williamboman/mason.nvim)
- **Debugging**: [DAP](https://github.com/mfussenegger/nvim-dap) integration with Python support
- **Git Integration**: [Fugitive](https://github.com/tpope/vim-fugitive)
	- **Database Management**: [vim-dadbod](https://github.com/tpope/vim-dadbod) with UI and completion
	- **File Explorer**: [Oil](https://github.com/stevearc/oil.nvim) for filesystem editing
- **AI Assistance**: [CopilotChat](https://github.com/CopilotC-Nvim/CopilotChat.nvim) and [OpenCode](https://github.com/NickvanDyke/opencode.nvim)
- **Themes**: Support for [Tokyo Night](https://github.com/folke/tokyonight.nvim) and [Rose Pine](https://github.com/rose-pine/neovim)

## Installation

1. **Backup** your existing Neovim config:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone** this repository:
   ```bash
   git clone https://github.com/yourusername/your-repo-name.git ~/.config/nvim
   ```

3. **Install** Neovim (0.9+ recommended):
   - Ubuntu/Debian: `sudo apt install neovim`
   - Fedora: `sudo dnf install neovim`
   - Arch Linux: `sudo pacman -S neovim`
   - macOS: `brew install neovim`
   - Or download from [neovim.io](https://neovim.io/)

4. **Install** dependencies:
   - Node.js (for LSP servers)
   - Python (for DAP)
   - Git
   - ripgrep (for Telescope)

5. **Launch** Neovim and let lazy.nvim install plugins automatically.

## Key Mappings

### General
- `<Space>` - Leader key
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep (Telescope)
- `<leader>fb` - Buffers (Telescope)
- `<leader>fh` - Help tags (Telescope)

### LSP
- `gd` - Go to definition
- `gr` - References
- `K` - Hover documentation
- `<leader>ca` - Code actions

### Debugging
- `<F5>` - Start/Continue debugging
- `<F10>` - Step over
- `<F11>` - Step into
- `<F12>` - Step out

### Git
- `<leader>gs` - Git status
- `<leader>gc` - Git commit
- `<leader>gp` - Git push

### File Explorer
- `-` - Open Oil file explorer
- `<CR>` - Open file/directory in Oil

## Configuration Structure

```
~/.config/nvim/
├── lua/wilson/
│   ├── init.lua          # Main entry point
│   ├── lazy.lua          # Plugin definitions
│   ├── lazy/             # Individual plugin configs
│   ├── remap.lua         # Key mappings
│   └── set.lua           # Vim options
├── after/plugin/         # Plugin-specific configs
└── README.md             # This file
```

## Customization

- **Plugins**: Add/remove plugins in `lua/wilson/lazy.lua`
- **Keymaps**: Modify in `lua/wilson/remap.lua`
- **Settings**: Adjust in `lua/wilson/set.lua`
- **Themes**: Change in `lua/wilson/lazy.lua` (currently set to Tokyo Night)

## Requirements

- Neovim 0.9+
- Git
- Node.js 16+ (for some LSP servers)
- Python 3.8+ (for DAP)
- ripgrep (optional, for better search performance)

## Troubleshooting

- **Plugins not loading**: Run `:Lazy sync` in Neovim
- **LSP not working**: Install language servers with `:Mason`
- **Performance issues**: Check `:Lazy profile` for slow plugins

## License

This configuration is provided as-is. Feel free to use and modify for your own setup.
