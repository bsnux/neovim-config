# neovim config

Personal configuration for NeoVim editor

Creating symlinks to your home configuration folder:

```sh
mkdir -p ~/.config/nvim/pack
ln -s ~/github/bsnux/neovim-config/init.lua ~/.config/nvim/init.lua
ln -s ~/github/bsnux/neovim-config/plugins ~/.config/nvim/pack/plugins
```

Installing coc.nvim:

```sh
cd plugins/start/coc.nvim
yarn install
yarn build
```

Adding a new submodule for a new plugin:

```sh
git submodule add https://github.com/neovim/nvim-lspconfig.git plugins/start/nvim-lspconfig
```

or

```sh
./add-submodule.sh https://github.com/neovim/nvim-lspconfig.git
```

Adding a new submodule for a new plugin as optional:

```sh
git submodule add https://github.com/neovim/nvim-lspconfig.git plugins/opt/nvim-lspconfig
```
