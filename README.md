# dotfiles

> "We become what we behold. We shape our tools and then our tools shape us".

## Configs
```bash
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/tmux ~/.config/tmux
ln -sf ~/dotfiles/yazi ~/.config/yazi
ln -sf ~/dotfiles/.zshrc ~/.zshrc
```
### test
## Scripts
```bash
./symlink_dotfiles.sh
```

The symlink script will:
- Create necessary config directories
- Backup any existing configs (with .backup extension)
- Create symlinks for nvim, tmux, yazi configs and .zshrc
- Provide feedback on the process

```

