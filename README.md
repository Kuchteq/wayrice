# The Wayrice (Mariusz Kuchta's <https://kuchta.dev> dotfiles)
These are the dotfiles deployed by [MARBS](https://github.com/Kuchteq/MARBS). The project has been heavily influenced (and includes many parts of Luke Smith <https://lukesmith.xyz>'s [voidrice](https://github.com/LukeSmithxyz/voidrice). However, my config is adjusted to run on wayland and uses the replacements for what was previously used on xorg and implements a lot of new features on its own. Don't know what all this jumbo mean? If you want your system to be more modern, lean and more secure, hop on and use this config instead! 

Most importantly, my goal is to teach you what every single file does and how to use the provided tooling so visit my YouTube playlist (WIP). 
- Useful semi-program bash scripts are in `~/.local/bin`
- Settings for:
        - neovim (text editor)
        - lf (file manager)
        - zsh (shel)
        - foot (terminal emulator)
        - tmux (terminal multiplexer)
        - xkb layout (for extra mappable buttons)
        - bemenu (app launcher)
        - keyd (keyboard remapper)
        - and other stuff
- Super features:
        - One click live GLOBAL dark/light theming
        - LF in neovim integration
        - LF as a universal file picker, easy file picking/saving on browsers
        - Others...
- Similarly to Luke's config I try to minimize what's directly in ~ so:
        - All configs that can be in `~/.config/` are.
        - Most environmental variables have been set in `~/.zprofile` to move configs into `~/.config/`
- Bookmarks in text files used by various scripts (like ~/.local/bin/shortcuts)
        - File bookmarks in `~/.config/shell/bm-files`
        - Directory bookmarks in `~/.config/shell/bm-dirs`

# Usage
These dotfiles are intended to go with numerous suckless-like programs I use:
### My specific builds that are meant to go along with these dotfiles:
- [dwl](https://github.com/Kuchteq/dwl)
- [somebar + someblocks](https://github.com/Kuchteq/somebar)
- [xdg-desktop-portal-wlr-plus-filechooser](https://github.com/Kuchteq/xdg-desktop-portal-wlr-plus-filechooser)
### Other programs/dependencies you should install are listed [here](https://github.com/Kuchteq/MARBS/blob/main/progs.csv)

# Install these dotfiles and all dependencies
Use MARBS to autoinstall everything:
`curl -LO `marbs.kuchta.dev/marbs.sh`
or clone the repo files directly to your home directory and install the [dependencies](https://github.com/Kuchteq/MARBS/blob/main/marbs.sh).
