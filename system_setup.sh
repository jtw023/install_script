#!/usr/bin/env bash

BLUE='\033[0;36m' # Cyan color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No color

if [[ $UID -ne 0 ]]; then

	echo -e "${RED}Please use sudo to run this script${NC}."

else

    echo "################## Editing doas config file ##################"

	touch /etc/doas.conf
	echo 'permit nopass '$user' as root' > /etc/doas.conf
	cat /etc/doas.conf
	echo -e "${BLUE}If the above line is not 'permit <yourusername> as root' then please come back to modify /etc/doas.conf${NC}"
	echo -e "${BLUE}Sleeping for 10 seconds while you read this${NC}."
	sleep 10

    echo "################## Syncing Timezones ##################"

    timedatectl set-timezone America/Los_Angeles
    systemctl enable systemd-timesyncd

    echo "################## Finding Mirrors ##################"

    reflector --verbose -l 200 -n 10 --sort rate --save /etc/pacman.d/mirrorlist

    echo "################## Updating Pacman ##################"

    pacman -Syy

    echo "################## Cloning Git Repos ##################"

    echo " ------------------------- "
    echo "| cd to /usr/share/fonts/ |"
    echo " ------------------------- "

    cd /usr/share/fonts/
    git clone https://github.com/jtw023/fonts.git

    echo " ------------- "
    echo "| cd to /opt/ |"
    echo " ------------- "

    cd /opt/
    git clone https://aur.archlinux.org/paru.git

    echo " -------------------------------- "
    echo "| cd to the users home directory |"
    echo " -------------------------------- "

    cd /home/$user

    echo " --------------------------- "
    echo "| Installing zsh extensions |"
    echo " --------------------------- "

    rm -rfv .config/
    git clone https://github.com/jtw023/.config.git

    mkdir -pv /usr/share/zsh/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh/plugins/zsh-autosuggestions/

    git clone --depth 1 https://github.com/junegunn/fzf.git /home/$user/.fzf
    /home/$user/.fzf/install --all

    echo " ------------------------------------- "
    echo "| Installing Random-Scripts directory |"
    echo " ------------------------------------- "

    git clone https://github.com/jtw023/Random-Scripts.git
    chmod -v +x /home/$user/Random-Scripts/*


    echo "################## Making directories and moving packages ##################"

    if [ -d "/usr/share/zsh/themes" ]; then
        cp -v /home/$user/.config/zsh/bira.zsh-theme /usr/share/zsh/themes/
    else
        mkdir -pv /usr/share/zsh/themes
        cp -v /home/$user/.config/zsh/bira.zsh-theme /usr/share/zsh/themes/
    fi

    if [ -d "/usr/share/rofi/themes" ]; then
        cp -v /home/$user/.config/rofi/arthur.rasi /usr/share/rofi/themes/arthur.rasi
    else
        mkdir -pv /usr/share/rofi/themes
        cp -v /home/$user/.config/rofi/arthur.rasi /usr/share/rofi/themes/arthur.rasi
    fi

    cp -v /home/$user/.config/Xresources/.Xresources /home/$user/.Xresources
    cp -v /home/$user/.config/xinit/.xinitrc /home/$user/.xinitrc
    cp -v /home/$user/.config/Xauthority/.Xauthority /home/$user/.Xauthority
    cp -v /home/$user/.config/zsh/.zshrc.root /root/.zshrc
    cp -v /home/$user/.config/zsh/.zshenv /home/$user/.zshenv
	cp -v /home/$user/Random-Scripts/set_screens.sh /usr/local/bin/set_screens.sh

    echo "################## Editing /etc/lightdm/lightdm.conf ##################"
    sed -i 's;#display-setup-script=;display-setup-script=/usr/local/bin/set_screens.sh;g' /etc/lightdm/lightdm.conf
    cat /etc/lightdm/lightdm.conf | grep display-setup-script
    echo -e "${BLUE}The above line should be 'display-setup-script=/usr/local/bin/set_screens.sh'. If it is not, please come back to edit /etc/lightdm/lightdm.conf${NC}."
    echo "Sleeping for 20 seconds while you read this."
    sleep 20


    echo "################## Changing ownership of the entire home directory ##################"

    chown -Rv $user:wheel /home/$user/

    echo -e "${GREEN} Finished. Please check home folder permissions then run the yay_and_lunarvim_setup script${NC}."

fi
