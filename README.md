# dotfiles
Dotfiles used for my Arch / OsX installation

## Usage
To install a specific configuration file, simply type:
```bash
./deploy.bash vim bash ...
```

To install all configuration, call the script with no parameters
```bash
./deploy.bash
```

The flag `-u` can be used to **Uninstall** instead of linking the dotfiles


## Notes
Some of the dotfiles are not fully supported (zsh/oh-my-zsh in particular).
Some tweaks are required to make it work on Linux or Mac
