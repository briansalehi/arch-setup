# Brian's Neovim Configuration

Personal nvim configuration.

## Setup

Install vim using package manager:

**archlinux**
```sh
sudo pacman -S nvim
```

## Plugin Manager

Use [vim-plugin](https://github.com/junegunn/vim-plug) to manage nvim plugins.

To setup this plugin run:

```sh
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

## Plugins

This will put `plug.vim` file into `~/.local/share/nvim/site/autoload` directory.

Useful plugins are written in `init.vim` file.

