#! /bin/bash

INSTALL_SCRIPT_PATH="$(readlink -f "${BASH_SOURCE}")"
INSTALL_SCRIPT_DIR_PATH="$(dirname "$INSTALL_SCRIPT_PATH")"

if [[ "$1" != "--no-deps" ]]; then
    echo "Install dependencies"
    echo ""

    $INSTALL_SCRIPT_DIR_PATH/install_dependencies.sh

    echo ""
    echo "---------------"
fi

echo "Backing up the current dot files"
echo ""

mkdir -v ~/dotfiles_backup || exit -1
mkdir -v ~/dotfiles_backup/.config
mkdir -v ~/dotfiles_backup/.local
mkdir -v ~/dotfiles_backup/.local/share

mv -v ~/.icons ~/dotfiles_backup
mv -v ~/.themes/ ~/dotfiles_backup
mv -v ~/.Xresources ~/dotfiles_backup
mv -v ~/.gtkrc-2.0 ~/dotfiles_backup

mv -v ~/.local/share/aurorae ~/dotfiles_backup/.local/share/
mv -v ~/.local/share/color-schemes ~/dotfiles_backup/.local/share/
mv -v ~/.local/share/icons ~/dotfiles_backup/.local/share/
mv -v ~/.local/share/plasma ~/dotfiles_backup/.local/share/

mv -v ~/.config/alacritty ~/dotfiles_backup/.config/
mv -v ~/.config/dconf ~/dotfiles_backup/.config/
mv -v ~/.config/dolphinrc ~/dotfiles_backup/.config/
mv -v ~/.config/dunst ~/dotfiles_backup/.config/
mv -v ~/.config/fish ~/dotfiles_backup/.config/
mv -v ~/.config/garuda-pkgbuilds ~/dotfiles_backup/.config/
mv -v ~/.config/gtkrc ~/dotfiles_backup/.config/
mv -v ~/.config/gtkrc-2.0 ~/dotfiles_backup/.config/
mv -v ~/.config/gtk-3.0 ~/dotfiles_backup/.config/
mv -v ~/.config/gtk-4.0 ~/dotfiles_backup/.config/
mv -v ~/.config/hypr ~/dotfiles_backup/.config/
mv -v ~/.config/katerc ~/dotfiles_backup/.config/
mv -v ~/.config/kcminputrc ~/dotfiles_backup/.config/
mv -v ~/.config/kdedefaults ~/dotfiles_backup/.config/
mv -v ~/.config/kdeglobals ~/dotfiles_backup/.config/
mv -v ~/.config/kscreenlockerrc ~/dotfiles_backup/.config/
mv -v ~/.config/ksplashrc ~/dotfiles_backup/.config/
mv -v ~/.config/Kvantum ~/dotfiles_backup/.config/
mv -v ~/.config/kwalletrc ~/dotfiles_backup/.config/
mv -v ~/.config/kwinrc ~/dotfiles_backup/.config/
mv -v ~/.config/nvim/ ~/dotfiles_backup/.config/
mv -v ~/.config/nvim-web ~/dotfiles_backup/.config/
mv -v ~/.config/nvim-latex ~/dotfiles_backup/.config/
mv -v ~/.config/plasmarc ~/dotfiles_backup/.config/
mv -v ~/.config/plasma-localerc ~/dotfiles_backup/.config/
mv -v ~/.config/qt5ct ~/dotfiles_backup/.config/
mv -v ~/.config/qt6ct ~/dotfiles_backup/.config/
mv -v ~/.config/rofi ~/dotfiles_backup/.config/
mv -v ~/.config/starship.toml ~/dotfiles_backup/.config/
mv -v ~/.config/Trolltech.conf ~/dotfiles_backup/.config/
mv -v ~/.config/waybar ~/dotfiles_backup/.config/
mv -v ~/.config/xsettingsd ~/dotfiles_backup/.config/

echo ""
echo "---------------"

echo "Installing/Symlinking dot files"
echo ""

ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.icons" ~/ 
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.themes/" ~/
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.Xresources" ~/
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.gtkrc-2.0" ~/

ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.local/share/aurorae" ~/.local/share/
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.local/share/color-schemes" ~/.local/share/
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.local/share/icons" ~/.local/share/
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.local/share/plasma" ~/.local/share/

ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/alacritty" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/dconf" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/dolphinrc" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/dunst" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/fish" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/garuda-pkgbuilds" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/gtkrc" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/gtkrc-2.0" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/gtk-3.0" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/gtk-4.0" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/hypr" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/katerc" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/kcminputrc" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/kdedefaults" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/kdeglobals" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/kscreenlockerrc" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/ksplashrc" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/Kvantum" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/kwalletrc" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/kwinrc" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/nvim/" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/nvim-web" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/nvim-latex" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/plasmarc" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/plasma-localerc" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/qt5ct" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/qt6ct" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/rofi" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/starship.toml" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/Trolltech.conf" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/waybar" ~/.config
ln -sv "${INSTALL_SCRIPT_DIR_PATH}/.config/xsettingsd" ~/.config

echo ""
echo "---------------"
