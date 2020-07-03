#!/bin/sh
clear
grey='\033[1;30m'
red='\033[0;31m'
RED='\033[1;31m'
green='\033[0;32m'
GREEN='\033[1;32m'
yellow='\033[0;33m'
YELLOW='\033[1;33m'
purple='\033[0;35m'
PURPLE='\033[1;35m'
white='\033[0;37m'
WHITE='\033[1;37m'
blue='\033[0;34m'
BLUE='\033[1;34m'
cyan='\033[0;36m'
CYAN='\033[1;36m'
NC='\033[0m'

echo
echo   "${grey}grey${NC}"
echo    "${red}red      ${RED}RED${NC}"
echo  "${green}green    ${GREEN}GREEN${NC}"
echo "${yellow}yellow   ${YELLOW}YELLOW${NC}"
echo "${purple}purple   ${PURPLE}PURPLE${NC}"
echo  "${white}white    ${WHITE}WHITE${NC}"
echo   "${blue}blue     ${BLUE}BLUE${NC}"
echo   "${cyan}cyan     ${CYAN}CYAN${NC}"
echo     "${NC}NC${NC}"
echo
echo

# trap ctrl-c and call ctrl_c()
ctrl_c() { echo; echo; exit 0; }
trap ctrl_c INT

if [ "$1" != "${1#[debug]}" ] ;then
    cmd(){ echo ">> ${WHITE}$1${NC}"; }
    echo "${RED}DEBUG: Commands will be echoed to console${NC}"
else
    cmd(){ eval $1; }
    echo "${RED}LIVE: Actions will be performed! Use caution.${NC}"
fi

echo
echo
echo "${YELLOW}This script backs up the current configuration in preparation${NC}"
echo "${YELLOW}for a complete OS reinstall.${NC}"
echo
echo "${YELLOW}A backup will create a './Migration_$USER' folder that${NC}"
echo "${YELLOW}will be used for restore. If the folder already exists then${NC}"
echo "${YELLOW}it will be renamed with a timestamp appended.${NC}"
echo
echo "${YELLOW}A restore will perform an upgrade, software installation, and${NC}"
echo "${YELLOW}settings restoration with a prompt at each step. The restore${NC}"
echo "${YELLOW}performes the following actions:${NC}"
echo "${YELLOW}\t- Create Folder Links${NC}"
echo "${YELLOW}\t\t- This creates links to common folders stored on a different${NC}"
echo "${YELLOW}\t\t  drive such as Videos, Music, Steam, etc.${NC}"
echo "${YELLOW}\t- Add Extra PPAs${NC}"
echo "${YELLOW}\t- Preliminary upgrade and Purge Apport${NC}"
echo "${YELLOW}\t- Install Standard Packages${NC}"
echo "${YELLOW}\t- Install PPA Packages${NC}"
echo "${YELLOW}\t- Install PIP Packages${NC}"
echo "${YELLOW}\t- Install Snap packages${NC}"
echo "${YELLOW}\t- Install Plasmoids${NC}"
echo "${YELLOW}\t- Install Downloaded Apps${NC}"
echo "${YELLOW}\t- Install from Source${NC}"
echo "${YELLOW}\t- Additional Configuration${NC}"
echo "${YELLOW}\t\t- Add user to vboxusers${NC}"
echo "${YELLOW}\t\t- Create Samba password for user${NC}"
echo "${YELLOW}\t- Custom Migration Files${NC}"
echo "${YELLOW}\t\t- This section depends on the bakup in './Migration_$USER'${NC}"
echo
echo "${YELLOW}In the Custom Migration Files section you can answer (y/n/a) which${NC}"
echo "${YELLOW}is yes/no/all. Answering Yes will allow you to choose every migration${NC}"
echo "${YELLOW}section that is applied. All will apply everything. Backups are${NC}"
echo "${YELLOW}made for system configuration files (Plasma, Shortcuts, Power${NC}"
echo "${YELLOW}Management, etc).${NC}"
#echo "${YELLOW}${NC}"
echo
echo -n "${CYAN}Do you want to (B)ackup or (R)estore? ${NC}"
read mode
if [ "$mode" != "${mode#[Bb]}" ] ;then
    if [ -d "./Migration_$USER" ] ;then
        timestamp=$(date +%s)
        echo "${red}Error! Directory './Migration_$USER' exists.${NC}"
        echo -n "${BLUE}Moving './Migration_$USER' to './Migration_${USER}_${timestamp}'...${NC}" 
        cmd "mv ./Migration_${USER} ./Migration_${USER}_${timestamp}"
        echo "${BLUE}DONE${NC}"
    fi
        
    echo
    echo "${green}==========================================================================${NC}"
    echo "${yellow}\tPerforming Backup${NC}"
    echo "${green}--------------------------------------------------------------------------${NC}"
    
    echo -n "${BLUE}Creating directory './Migration_$USER'...${NC}"
    cmd "mkdir ./Migration_$USER"
    echo "${BLUE}DONE${NC}"
    
    # VPN
        echo "${BLUE}VPNs${NC}"
        cmd "mkdir -p ./Migration_$USER/etc/NetworkManager/system-connections/"
        cmd "sudo cp --preserve=all /etc/NetworkManager/system-connections/Mikrotik_OVPN_Home2 ./Migration_$USER/etc/NetworkManager/system-connections/"
        
        cmd "mkdir -p ./Migration_$USER/etc/NetworkManager/system-connections/"
        cmd "sudo cp --preserve=all /etc/NetworkManager/system-connections/Mikrotik_OVPN_Karen ./Migration_$USER/etc/NetworkManager/system-connections/"
        
        cmd "mkdir -p ./Migration_$USER/etc/NetworkManager/system-connections/"
        cmd "sudo cp --preserve=all /etc/NetworkManager/system-connections/MSELEC ./Migration_$USER/etc/NetworkManager/system-connections/"

        cmd "mkdir -p ./Migration_$USER/etc/NetworkManager/system-connections/"
        cmd "sudo cp --preserve=all -r /etc/NetworkManager/system-connections/.cert ./Migration_$USER/etc/NetworkManager/system-connections/"
    
    # Warzone 2100
        echo "${BLUE}Warzone 2100${NC}"
        cmd "mkdir -p ./Migration_$USER/usr/share/games/warzone2100/"
        cmd "sudo cp --preserve=all /usr/share/games/warzone2100/sequences.wz ./Migration_$USER/usr/share/games/warzone2100/"
        cmd "mkdir -p ./Migration_$USER/home/$USER/"
        cmd "sudo cp --preserve=all -r /home/$USER/.warzone2100-3.2 ./Migration_$USER/home/$USER/"
    
    # Knossos
        echo "${BLUE}Knossos${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.config/"
        cmd "sudo cp --preserve=all -r /home/$USER/.config/knossos ./Migration_$USER/home/$USER/.config/"
    
    # RawTherapee
        echo "${BLUE}RawTherapee${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.config/"
        cmd "sudo cp --preserve=all -r /home/$USER/.config/RawTherapee ./Migration_$USER/home/$USER/.config/"
    
    # BricsCAD
        echo "${BLUE}BricsCAD${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/"
        cmd "sudo cp --preserve=all -r /home/$USER/BricsCAD ./Migration_$USER/home/$USER/"
        cmd "mkdir -p ./Migration_$USER/var/bricsys/"
        cmd "sudo cp --preserve=all /var/bricsys/BricsCAD_ShapeV18.lic ./Migration_$USER/var/bricsys/"
        cmd "mkdir -p ./Migration_$USER/var/bricsys/"
        cmd "sudo cp --preserve=all /var/bricsys/BricsCADV17.lic ./Migration_$USER/var/bricsys/"
        cmd "mkdir -p ./Migration_$USER/var/bricsys/"
        cmd "sudo cp --preserve=all /var/bricsys/BricsCADV18.lic ./Migration_$USER/var/bricsys/"
        cmd "mkdir -p ./Migration_$USER/var/bricsys/"
        cmd "sudo cp --preserve=all /var/bricsys/BricsCADV20.lic ./Migration_$USER/var/bricsys/"
        cmd "mkdir -p ./Migration_$USER/var/bricsys/"
        cmd "sudo cp --preserve=all /var/bricsys/CommunicatorV18.lic ./Migration_$USER/var/bricsys/"
        cmd "mkdir -p ./Migration_$USER/opt/bricsys/bricscad/v18/"
        cmd "sudo cp --preserve=all -r /opt/bricsys/bricscad/v20/RenderMaterialStatic ./Migration_$USER/opt/bricsys/bricscad/v18/"
        cmd "mkdir -p ./Migration_$USER/opt/bricsys/"
        cmd "sudo cp --preserve=all -r /opt/bricsys/communicator ./Migration_$USER/opt/bricsys/"
    
    # DosBox
        echo "${BLUE}DosBox${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/"
        cmd "sudo cp --preserve=all -r /home/$USER/.dosbox ./Migration_$USER/home/$USER/"
    
    # Frictional Games
        echo "${BLUE}Frictional Games${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/"
        cmd "sudo cp --preserve=all -r /home/$USER/.frictionalgames ./Migration_$USER/home/$USER/"
    
    # ThunderBird
        echo "${BLUE}ThunderBird${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.thunderbird/"
        cmd "sudo cp --preserve=all /home/$USER/.thunderbird/profiles.ini ./Migration_$USER/home/$USER/.thunderbird/"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.thunderbird/"
        cmd "sudo cp --preserve=all -r /home/$USER/.thunderbird/eu3c43qa.default ./Migration_$USER/home/$USER/.thunderbird/"
        cmd "sudo chown -R $USER:$USER /home/$USER/.thunderbird"
    
    # KiCAD
        echo "${BLUE}KiCAD${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.config/"
        cmd "sudo cp --preserve=all -r /home/$USER/.config/kicad ./Migration_$USER/home/$USER/.config/"
    
    # gzdoom
        #echo "${BLUE}gzdoom${NC}"
        #cmd "mkdir -p ./Migration_$USER/snap/gzdoom/current/.config/"
        #cmd "sudo cp --preserve=all -r /home/$USER/snap/gzdoom/current/.config/gzdoom ./Migration_$USER/snap/gzdoom/current/.config/"
    
    # Audacious
        echo "${BLUE}Audacious${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.config/"
        cmd "sudo cp --preserve=all -r /home/$USER/.config/audacious ./Migration_$USER/home/$USER/.config/"
    
    # VLC
        echo "${BLUE}VLC${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.config/"
        cmd "sudo cp --preserve=all -r /home/$USER/.config/vlc ./Migration_$USER/home/$USER/.config/"
    
    # Eclipse
        echo "${BLUE}Eclipse${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings/"
        cmd "sudo cp --preserve=all -r /home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs ./Migration_$USER/home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings/"
        cmd "mkdir -p ./Migration_$USER/home/$USER/Projects/Eclipse/"
        cmd "sudo cp --preserve=all -r /home/$USER/Projects/Eclipse/.metadata ./Migration_$USER/home/$USER/Projects/Eclipse/"
    
    # KATE
        echo "${BLUE}KAte${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.config/"
        cmd "sudo cp --preserve=all /home/$USER/.config/katerc ./Migration_$USER/home/$USER/.config/"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.config/"
        cmd "sudo cp --preserve=all /home/$USER/.config/katesyntaxhighlightingrc ./Migration_$USER/home/$USER/.config/"
    
    # Power Management Profile (KDE) (BACKUP)
        echo "${BLUE}Power Management${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.config/"
        cmd "sudo cp --preserve=all /home/$USER/.config/powermanagementprofilesrc ./Migration_$USER/home/$USER/.config/"
    
    # Global Shortcuts (KDE) (BACKUP)
        echo "${BLUE}Global Shortcuts${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.config/"
        cmd "sudo cp --preserve=all /home/$USER/.config/kglobalshortcutsrc ./Migration_$USER/home/$USER/.config/"
    
    # Plasma Settings (Panel, Notifications, Theme, Desktop Effects) (KDE) (BACKUP)
        echo "${BLUE}Plasma Settings${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.config/"
        cmd "sudo cp --preserve=all /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc ./Migration_$USER/home/$USER/.config/"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.config/"
        cmd "sudo cp --preserve=all /home/$USER/.config/plasmanotifyrc ./Migration_$USER/home/$USER/.config/"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.config/"
        cmd "sudo cp --preserve=all /home/$USER/.config/plasmarc ./Migration_$USER/home/$USER/.config/"
        cmd "mkdir -p ./Migration_$USER/home/$USER/.config/"
        cmd "sudo cp --preserve=all /home/$USER/.config/kwinrc ./Migration_$USER/home/$USER/.config/"
    
    # Login scripts (.bashr/.profile) (BACKUP)
        echo "${BLUE}Login Scripts${NC}"
        cmd "mkdir -p ./Migration_$USER/home/$USER/"
        cmd "sudo cp --preserve=all /home/$USER/.bashrc ./Migration_$USER/home/$USER/"
        cmd "mkdir -p ./Migration_$USER/home/$USER/"
        cmd "sudo cp --preserve=all /home/$USER/.profile ./Migration_$USER/home/$USER/"
        
    # symlinks (predetermined list)
        echo "${BLUE}Symlinks${NC}"
        cp_if_link(){ [ ! -L "$1" ] || cmd "cp --preserve=all -P $1 ./Migration_$USER/symlinks/"; }
        cmd "mkdir -p ./Migration_$USER/symlinks"
        cp_if_link /home/$USER/Documents
        #cp_if_link /home/$USER/Downloads
        cp_if_link /home/$USER/Music
        cp_if_link /home/$USER/Pictures
        cp_if_link /home/$USER/Templates
        cp_if_link /home/$USER/Videos
        cp_if_link /home/$USER/.bricscad
        cp_if_link /home/$USER/.eve
        cp_if_link /home/$USER/.FreeCAD
        cp_if_link /home/$USER/.minecraft
        cp_if_link /home/$USER/.PlayOnLinux
        cp_if_link /home/$USER/.steam
        cp_if_link /home/$USER/Bricsys
        cp_if_link /home/$USER/octave
        cp_if_link /home/$USER/PlayOnLinux\\\'s\\\ virtual\\\ drives
        cp_if_link /home/$USER/Programs
        cp_if_link /home/$USER/Projects
        cmd "mkdir -p ./Migration_$USER/symlinks/.local/share/Steam"
        cp_if_link /home/$USER/.local/share/Steam
else
    echo
    echo "${green}==========================================================================${NC}"
    echo "${yellow}\tCreate Folder Links${NC}"
    echo "${green}--------------------------------------------------------------------------${NC}"
    echo "${red}WARNING! The following folders will be backed up if they already exist,${NC}"
    echo "${red}         and you will need to check if it is safe to remove them. On a${NC}"
    echo "${red}         fresh install these should normally all be empty.${NC}"
    echo "${red}\t- ~/Documents${NC}"
    #echo "${red}\t- ~/Downloads${NC}"
    echo "${red}\t- ~/Music${NC}"
    echo "${red}\t- ~/Pictures${NC}"
    echo "${red}\t- ~/Templates${NC}"
    echo "${red}\t- ~/Videos${NC}"
    echo
    echo "${red}The following additional links will be created without any checks:${NC}"
    echo "${red}\t- ~/.bricscad${NC}"
    echo "${red}\t- ~/.eve${NC}"
    echo "${red}\t- ~/.FreeCAD${NC}"
    echo "${red}\t- ~/.minecraft${NC}"
    echo "${red}\t- ~/.PlayOnLinux${NC}"
    echo "${red}\t- ~/.steam${NC}"
    echo "${red}\t- ~/Bricsys${NC}"
    echo "${red}\t- ~/octave${NC}"
    echo "${red}\t- ~/PlayOnLinux's virtual drives${NC}"
    echo "${red}\t- ~/Programs${NC}"
    echo "${red}\t- ~/Projects${NC}"
    echo "${red}\t- ~/.local/share/Steam${NC}"
    echo -n "${CYAN}Proceed? (y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        # Create Backups First
        if [ -d "/home/$USER/Documents" ] ;then   cmd "mv /home/$USER/Documents /home/$USER/Documents.bak";     fi
        #if [ -d "/home/$USER/Downloads" ] ;then   cmd "mv /home/$USER/Downloads /home/$USER/Downloads.bak";     fi
        if [ -d "/home/$USER/Music"     ] ;then   cmd "mv /home/$USER/Music /home/$USER/Music.bak";             fi
        if [ -d "/home/$USER/Pictures"  ] ;then   cmd "mv /home/$USER/Pictures /home/$USER/Pictures.bak";       fi
        if [ -d "/home/$USER/Templates" ] ;then   cmd "mv /home/$USER/Templates /home/$USER/Templates.bak";     fi
        if [ -d "/home/$USER/Videos"    ] ;then   cmd "mv /home/$USER/Videos /home/$USER/Videos.bak";           fi
        
        # Copy all symlinks
        cmd "sudo cp --preserve=all -r ./Migration_$USER/symlinks/* /home/$USER/"
    fi

    echo
    echo "${green}==========================================================================${NC}"
    echo "${yellow}\tAdd Extra PPAs${NC}"
    echo "${green}--------------------------------------------------------------------------${NC}"
    echo -n "${CYAN}Proceed? (y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        cmd "sudo apt-add-repository -yn ppa:giuspen/ppa"
        #cmd "sudo add-apt-repository -yn ppa:ngld/knossos"     # Currently not supported
    fi


    echo "${green}==========================================================================${NC}"
    echo "${yellow}\tPreliminary upgrade and Purge Apport${NC}"
    echo "${green}--------------------------------------------------------------------------${NC}"
    echo -n "${CYAN}Proceed (y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        cmd "sudo apt update"
        cmd "sudo apt -y dist-upgrade"
        cmd "sudo apt -y purge apport"
    fi


    echo
    echo "${green}==========================================================================${NC}"
    echo "${yellow}\tInstall Standard Packages${NC}"
    echo "${green}--------------------------------------------------------------------------${NC}"
    printf "${GREEN}Package List:${NC}\n"
    printf "${BLUE}\tarandr\n\taudacious\n\taudacity\n\tbaobab\n\tblender\n\tbrasero\n\tcecilia\n\tchromium-browser\n\tcifs-utils\n\tdevede\n\tdia\n\tdosbox\n\teasytag\n\texfat-utils\n\text4magic\n\tfluidsynth\n\tfontforge\n\tfreecad\n\tg++-8\n\tghex\n\tgimp\n\tgimp-gmic\n\tgimp-plugin-registry\n\tgit\n\tgit-lfs\n\tglade\n\tglmark2\n\tgmic\n\tgpick\n\thardinfo\n\tinkscape\n\tinxi\n\tiptraf\n\tkdevelop\n\tkicad\n\tkicad-footprints\n\tkicad-packages3d\n\tkicad-symbols\n\tkicad-templates\n\tkompare\n\tkrita\n\tlibdvd-pkg\n\tlibdvdnav4\n\tlibdvdread7\n\tlibnoise-dev\n\tlibsdl2-dev\n\tlibsdl2-image-dev\n\tlibsdl2-mixer-dev\n\tlibsdl2-net-dev\n\tlmms\n\tmesa-utils\n\tneofetch\n\tnet-tools\n\tnetwork-manager-openconnect\n\tnetwork-manager-openvpn\n\tnetwork-manager-ssh\n\tnfs-common\n\tnfs-kernel-server\n\tnmap\n\toctave\n\topenconnect\n\topenjdk-8-jre\n\topenshot\n\topenssh-server\n\topenvpn\n\tpithos\n\tplayonlinux\n\tpython3-pip\n\tqt5-default\n\tqtcreator\n\tqtdeclarative5-dev\n\trawtherapee\n\tremmina\n\trename\n\tsamba\n\tscummvm\n\tsmb4k\n\tsolaar\n\ttexlive-fonts-extra\n\ttexlive-fonts-recommended\n\ttexlive-xetex\n\ttexstudio\n\ttilix\n\tthunderbird\n\tubuntu-restricted-extras\n\tvalgrind\n\tveusz\n\tvim\n\tvirtualbox\n\tvlc\n\tvlc-plugin-access-extra\n\tvlc-plugin-fluidsynth\n\tvlc-plugin-samba\n\tvlc-plugin-skins2\n\tvlc-plugin-visualization\n\twarzone2100\n\twhois\n\twinff\n\twireshark\n\txrdp\n\txterm\n\t${NC}\n\n"
    echo "${CYAN}\t- Answer yes again to apt if it successfully prepares to install packeges.${NC}"
    echo "${CYAN}\t- Take caution, if apt has errors then abort the script with ctrl^c${NC}"
    echo -n "${CYAN}Proceed (y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        cmd "sudo apt install arandr audacious audacity baobab blender brasero cecilia chromium-browser cifs-utils devede dia dosbox easytag exfat-utils ext4magic fluidsynth fontforge freecad g++-8 ghex gimp gimp-gmic gimp-plugin-registry git git-lfs glade glmark2 gmic gpick hardinfo inkscape inxi iptraf kdevelop kicad kicad-footprints kicad-packages3d kicad-symbols kicad-templates kompare krita libdvd-pkg libdvdnav4 libdvdread7 libnoise-dev libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-net-dev lmms mesa-utils neofetch net-tools network-manager-openconnect network-manager-openvpn network-manager-ssh nfs-common nfs-kernel-server nmap octave openconnect openjdk-8-jre openshot openssh-server openvpn pithos playonlinux python3-pip qt5-default qtcreator qtdeclarative5-dev rawtherapee remmina rename samba scummvm smb4k solaar texlive-fonts-extra texlive-fonts-recommended texlive-xetex texstudio tilix thunderbird ubuntu-restricted-extras valgrind veusz vim virtualbox vlc vlc-plugin-access-extra vlc-plugin-fluidsynth vlc-plugin-samba vlc-plugin-skins2 vlc-plugin-visualization warzone2100 whois winff wireshark xrdp xterm"
    fi



    echo
    echo "${green}==========================================================================${NC}"
    echo "${yellow}\tInstall PPA Packages${NC}"
    echo "${green}--------------------------------------------------------------------------${NC}"
    printf "${BLUE}\tx-tile\n\tknossos${NC}\n\n"
    echo -n "${CYAN}Proceed (y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${BLUE}Installing x-tile:${NC}\n"
        cmd "sudo apt -y install x-tile"
        #printf "${BLUE}Installing Knossos:${NC}\n"
        #cmd "sudo apt -y install knossos"              # Currently not supported
    fi


    echo
    echo "${green}==========================================================================${NC}"
    echo "${yellow}\tInstall PIP Packages${NC}"
    echo "${green}--------------------------------------------------------------------------${NC}"
    printf "${BLUE}\tbCNC${NC}\n\n"
    echo -n "${CYAN}Proceed (y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        cmd "pip3 install --no-input --upgrade bCNC"
    fi


    echo
    echo "${green}==========================================================================${NC}"
    echo "${yellow}\tInstall Snap packages${NC}"
    echo "${green}--------------------------------------------------------------------------${NC}"
    #printf "${BLUE}\tgzdoom\n\tshotcut\n\tsublime-text${NC}\n\n"
    printf "${BLUE}\tckan\t\nshotcut\n\tsublime-text${NC}\n\n"
    echo -n "${CYAN}Proceed (y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        #cmd "sudo snap install gzdoom ckan"
        cmd "sudo snap install ckan"
        cmd "sudo snap install --classic shotcut"
        cmd "sudo snap install --classic sublime-text"
    fi

    echo
    echo "${green}==========================================================================${NC}"
    echo "${yellow}\tInstall Plasmoids${NC}"
    echo "${green}--------------------------------------------------------------------------${NC}"
    printf "${BLUE}\tplaces widget${NC}\n\n"
    echo -n "${CYAN}Proceed (y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${BLUE}Places Widget:${NC}\n"
            cmd "plasmapkg2 -u ./Apps/places-widget-1.3.plasmoid"
    fi
    

    echo
    echo "${green}==========================================================================${NC}"
    echo "${yellow}\tInstal Downloaded Apps${NC}"
    echo "${green}--------------------------------------------------------------------------${NC}"
    printf "${BLUE}\tbricscad\n\tcamotics\n\tchrome\n\tnomachine\n\tmultisystem\n\teclipse${NC}\n\n"
    echo -n "${CYAN}Proceed (y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${BLUE}BricsCAD v20.2.08 (deb)${NC}\n"
        cmd "sudo dpkg -iG ./Apps/BricsCAD-V20.2.08-1-en_US-amd64.deb"
        printf "${BLUE}Camotics v1.2.0 (deb)${NC}\n"
        cmd "sudo dpkg -iG ./Apps/camotics_1.2.0_amd64.deb"
        printf "${BLUE}Chrome v83.0.4103 (deb)${NC}\n"
        cmd "sudo dpkg -iG ./Apps/google-chrome-stable_current_amd64.deb"
        printf "${BLUE}No Machine v6.11.2 (deb)${NC}\n"
        cmd "sudo dpkg -iG ./Apps/nomachine_6.11.2_1_amd64.deb"
        printf "${BLUE}Steam v20 (deb)${NC}\n"
        cmd "sudo dpkg -iG ./Apps/steam_latest.deb"
        printf "${BLUE}Mutisystem (sh)${NC}\n"
        cmd "sudo chmod +x ./Apps/install-depot-multisystem.sh"
        cmd "sudo ./Apps/install-depot-multisystem.sh"
        printf "${BLUE}Eclipse v2020-06 (bin)${NC}\n"
        cmd "sudo chmod +x ./Apps/eclipse-installer/eclipse-inst"
        cmd "./Apps/eclipse-installer/eclipse-inst"
    fi

    
    echo
    echo "${green}==========================================================================${NC}"
    echo "${yellow}\tInstall from Source${NC}"
    echo "${green}--------------------------------------------------------------------------${NC}"
    cmd "./gzdoom.sh"
    cmd "./knossos.sh"
    cmd "./qucs.sh"
    
    
    echo
    echo "${green}==========================================================================${NC}"
    echo "${yellow}\tAdditional Configuration${NC}"
    echo "${green}--------------------------------------------------------------------------${NC}"
    echo -n "${CYAN}Add user to vboxusers (y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${BLUE}Adding $USER to vboxusers...${NC}"
        cmd "sudo usermod -a -G vboxusers $USER"
        printf "${BLUE}DONE${NC}\n"
    fi
    
    echo
    echo -n "${CYAN}Set samba password (y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${BLUE}Setting Samba share password for $USER: ${NC}\n"
        cmd "sudo smbpasswd -a $USER"
    fi
    
    echo
    echo -n "${CYAN}Create standard NFS shares (y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        #printf "${BLUE}Creating NFS shares Downloads(rw) and $USER(ro): ${NC}\n"
        printf "${BLUE}Creating NFS share Downloads: ${NC}\n"
        
        # Export directory
            cmd "echo '' | sudo tee -a /etc/exports"
            cmd "echo '# Exports added by fresh_install.sh' | sudo tee -a /etc/exports"
            cmd "echo '/home/$USER/Downloads      192.168.0.0/16(rw,no_root_squash,sync,no_subtree_check)' | sudo tee -a /etc/exports"
            #cmd "echo '/home/$USER                192.168.0.0/16(ro,sync,no_subtree_check)' | sudo tee -a /etc/exports"

        # Restart NFS service
            cmd "sudo exportfs -arv"

        # Ensure firewall access if enabled
            cmd "sudo ufw allow from 192.168.0.0/16 to any port nfs"
    fi

    
    echo
    echo -n "${CYAN}Do you want to mount Downloads(rw) and User(ro) shares on another pc (you will need the IP and username) (y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${BLUE}What is the IP of the target? ${NC}"
        read remoteip
        printf "${BLUE}What is the username of the target? ${NC}"
        read remoteuser

        # Create mount points
            cmd "sudo mkdir -p /nfs/${remoteip}/Downloads"
            #cmd "sudo mkdir -p /nfs/${remoteip}/${remoteuser}"

        # Mount shares
            cmd "sudo mount ${remoteip}:/home/${remoteuser}/Downloads /nfs/${remoteip}/Downloads"
            #cmd "sudo mount ${remoteip}:/home/${remoteuser} /nfs/${remoteip}/${remoteuser}"
        
        printf "${BLUE}Make permanant (Make sure to only do this once) (y/n)?${NC}"
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "echo '' | sudo tee -a /etc/fstab"
            cmd "echo '# Mounts added by fresh_install.sh' | sudo tee -a /etc/fstab"
            cmd "echo '${remoteip}:/home/${remoteuser}/Downloads /nfs/${remoteip}/Downloads       nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            #cmd "echo '${remoteip}:/home/${remoteuser}           /nfs/${remoteip}/${remoteuser}   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
        fi
    fi
    
    
    echo
    echo "${green}==========================================================================${NC}"
    echo "${yellow}\tCustom Migration Files${NC}"
    echo "${green}--------------------------------------------------------------------------${NC}"
    printf "${BLUE}\tvpn settings\n\twarzone2100\n\tknossos\n\trawtherapee\n\tbricscad\n\tdosbox\n\tfrictional games\n\tthunderbird\n\tkicad\n\tgzdoom\n\taudacious${NC}\n\n"
    echo -n "${CYAN}Proceed? (y/n/a)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[AaYy]}" ] ;then

        # Yes to All?
        if [ "$answer" != "${answer#[Aa]}" ] ;then answer2="y"; else answer2=""; fi

        # VPN
        printf "${BLUE}VPN...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all ./Migration_$USER/etc/NetworkManager/system-connections/Mikrotik_OVPN_Home2 /etc/NetworkManager/system-connections/"
            cmd "sudo cp --preserve=all ./Migration_$USER/etc/NetworkManager/system-connections/Mikrotik_OVPN_Karen /etc/NetworkManager/system-connections/"
            cmd "sudo cp --preserve=all ./Migration_$USER/etc/NetworkManager/system-connections/MSELEC /etc/NetworkManager/system-connections/"
            cmd "sudo cp --preserve=all -r ./Migration_$USER/etc/NetworkManager/system-connections/.cert /etc/NetworkManager/system-connections/"
        fi
        
        # Warzone 2100
        printf "${BLUE}Warzone2100...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all ./Migration_$USER/usr/share/games/warzone2100/sequences.wz /usr/share/games/warzone2100/"
            cmd "sudo cp --preserve=all -r ./Migration_$USER/home/$USER/.warzone2100-3.2 /home/$USER/"
        fi
        
        # Knossos
        printf "${BLUE}Knossos...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all -r ./Migration_$USER/home/$USER/.config/knossos/ /home/$USER/.config/"
        fi
        
        # RawTherapee
        printf "${BLUE}RawTherapee...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all -r ./Migration_$USER/home/$USER/.config/RawTherapee/ /home/$USER/.config/"
        fi
        
        # BricsCAD
        printf "${BLUE}BricsCAD...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all -r ./Migration_$USER/home/$USER/BricsCAD/ /home/$USER/"
            cmd "sudo cp --preserve=all ./Migration_$USER/var/bricsys/BricsCAD_ShapeV18.lic /var/bricsys/"
            cmd "sudo cp --preserve=all ./Migration_$USER/var/bricsys/BricsCADV17.lic /var/bricsys/"
            cmd "sudo cp --preserve=all ./Migration_$USER/var/bricsys/BricsCADV18.lic /var/bricsys/"
            cmd "sudo cp --preserve=all ./Migration_$USER/var/bricsys/BricsCADV20.lic /var/bricsys/"
            cmd "sudo cp --preserve=all ./Migration_$USER/var/bricsys/CommunicatorV18.lic /var/bricsys/"
            cmd "sudo cp --preserve=all -r ./Migration_$USER/opt/bricsys/bricscad/v18/RenderMaterialStatic/ /opt/bricsys/bricscad/v20/"
            cmd "sudo cp --preserve=all -r ./Migration_$USER/opt/bricsys/communicator /opt/bricsys/"
        fi
        
        # DosBox
        printf "${BLUE}DosBox...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all -r ./Migration_$USER/home/$USER/.dosbox/ /home/$USER/"
        fi
        
        # Frictional Games
        printf "${BLUE}Frictional Games...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all -r ./Migration_$USER/home/$USER/.frictionalgames/ /home/$USER/"
        fi
        
        # ThunderBird
        printf "${BLUE}ThunderBird...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "mkdir -p /home/$USER/.thunderbird"
            cmd "sudo cp --preserve=all ./Migration_$USER/home/$USER/.thunderbird/profiles.ini /home/$USER/.thunderbird/"
            cmd "sudo cp --preserve=all -r ./Migration_$USER/home/$USER/.thunderbird/eu3c43qa.default /home/$USER/.thunderbird/"
            cmd "sudo chown -R $USER:$USER /home/$USER/.thunderbird"
        fi
        
        # KiCAD
        printf "${BLUE}KiCAD...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all -r ./Migration_$USER/home/$USER/.config/kicad/ /home/$USER/.config/"
        fi
        
        # gzdoom (handled in gzdoom.sh now)
        #printf "${BLUE}gzdoom...${NC}"
        #if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        #if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        #    cmd "gzdoom -norun"
        #    cmd "sudo cp --preserve=all -r ./Migration_$USER/snap/gzdoom/current/.config/gzdoom/ /home/$USER/snap/gzdoom/current/.config/"
        #fi
        
        # Audacious
        printf "${BLUE}Audacious...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all -r ./Migration_$USER/home/$USER/.config/audacious /home/$USER/.config/"
        fi
        
        # VLC
        printf "${BLUE}VLC...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all -r ./Migration_$USER/home/$USER/.config/vlc /home/$USER/.config/"
        fi
        
        # Eclipse
        printf "${BLUE}Eclipse...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all -r ./Migration_$USER/home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs /home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs"
            cmd "mkdir -p /home/$USER/Projects/Eclipse/"
            cmd "sudo cp --preserve=all -r ./Migration_$USER/home/$USER/Projects/Eclipse/.metadata /home/$USER/Projects/Eclipse/"
        fi
        
        # KATE
        printf "${BLUE}Kate...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all ./Migration_$USER/home/$USER/.config/katerc /home/$USER/.config/katerc"
            cmd "sudo cp --preserve=all ./Migration_$USER/home/$USER/.config/katesyntaxhighlightingrc /home/$USER/.config/katesyntaxhighlightingrc"
        fi
        
        # Power Management Profile (KDE) (BACKUP)
        printf "${BLUE}Power Management (KDE)...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all /home/$USER/.config/powermanagementprofilesrc /home/$USER/.config/powermanagementprofilesrc.bak"
            cmd "sudo cp --preserve=all ./Migration_$USER/home/$USER/.config/powermanagementprofilesrc /home/$USER/.config/powermanagementprofilesrc"
        fi
        
        # Global Shortcuts (KDE) (BACKUP)
        printf "${BLUE}Global Shortcuts (KDE)...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all /home/$USER/.config/kglobalshortcutsrc /home/$USER/.config/kglobalshortcutsrc.bak"
            cmd "sudo cp --preserve=all ./Migration_$USER/home/$USER/.config/kglobalshortcutsrc /home/$USER/.config/kglobalshortcutsrc"
        fi
        
        # Plasma Settings (Panel, Notifications, Theme, Desktop Effects) (KDE) (BACKUP)
        printf "${BLUE}Plasma Settings (KDE)...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc.bak"
            cmd "sudo cp --preserve=all ./Migration_$USER/home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc"
            
            cmd "sudo cp --preserve=all /home/$USER/.config/plasmanotifyrc /home/$USER/.config/plasmanotifyrc.bak"
            cmd "sudo cp --preserve=all ./Migration_$USER/home/$USER/.config/plasmanotifyrc /home/$USER/.config/plasmanotifyrc"
            
            cmd "sudo cp --preserve=all /home/$USER/.config/plasmarc /home/$USER/.config/plasmarc.bak"
            cmd "sudo cp --preserve=all ./Migration_$USER/home/$USER/.config/plasmarc /home/$USER/.config/plasmarc"
            
            cmd "sudo cp --preserve=all /home/$USER/.config/kwinrc /home/$USER/.config/kwinrc.bak"
            cmd "sudo cp --preserve=all ./Migration_$USER/home/$USER/.config/kwinrc /home/$USER/.config/kwinrc"
        fi
        
        # Login scripts (.bashr/.profile) (BACKUP)
        printf "${BLUE}Login Scripts (.bashrc/.profile)...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${BLUE} (y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo cp --preserve=all /home/$USER/.bashrc /home/$USER/.bashrc.bak"
            cmd "sudo cp --preserve=all ./Migration_$USER/home/$USER/.bashrc /home/$USER/.bashrc"
            
            cmd "sudo cp --preserve=all /home/$USER/.profile /home/$USER/.profile.bak"
            cmd "sudo cp --preserve=all ./Migration_$USER/home/$USER/.profile /home/$USER/.profile"
        fi

        
    fi

    echo 
    echo "${green}==========================================================================${YELLOW}"
    echo "Downlaod only: None, unless DEB/script section failed"
    echo "  Source only: Qucs, FlatCAM, (Alleyoop/Valkyrie)"
    echo "         Todo: (* = should have been done automatically)"
    echo "          - Migrate Home Folder"
    echo "              - Migrate Keyring .......................... (~/.local/share/keyrings)"
    echo
    echo "          - Install Chrome-Plasma Integration"
    echo "          - VirtualBox Extensions"
    echo "          - NVidia Drivers"
    echo "              - Generate xorg.conf"
    echo "              - Add Modelines"
    echo "${green}==========================================================================${NC}"
fi


# Package List
#arandr
#audacious
#audacity
#baobab
#blender
#brasero
#cecilia
#chromium-browser
#cifs-utils
#devede
#dia
#dosbox
#easytag
#exfat-utils
#ext4magic
#fluidsynth
#fontforge
#freecad
#g++-8
#ghex
#gimp
#gimp-gmic
#gimp-plugin-registry
#git
#git-lfs
#glade
#glmark2
#gmic
#gpick
#hardinfo
#inkscape
#inxi
#iptraf
#kdevelop
#kicad
#kicad-footprints
#kicad-packages3d
#kicad-symbols
#kicad-templates
#kompare
#krita
#libdvd-pkg
#libdvdnav4
#libdvdread7
#libnoise-dev
#libsdl2-dev
#libsdl2-image-dev
#libsdl2-mixer-dev
#libsdl2-net-dev
#lmms
#mesa-utils
#neofetch
#net-tools
#network-manager-openconnect
#network-manager-openvpn
#network-manager-ssh
#nfs-common
#nfs-kernel-server
#nmap
#octave
#openconnect
#openjdk-8-jre
#openshot
#openssh-server
#openvpn
#pithos
#playonlinux
#python3-pip
#qt5-default
#qtcreator
#qtdeclarative5-dev
#rawtherapee
#remmina
#rename
#samba
#scummvm
#smb4k
#solaar
#texlive-fonts-extra
#texlive-fonts-recommended
#texlive-xetex
#texstudio
#tilix
#thunderbird
#ubuntu-restricted-extras
#valgrind
#veusz
#vim
#virtualbox
#vlc
#vlc-plugin-access-extra
#vlc-plugin-fluidsynth
#vlc-plugin-samba
#vlc-plugin-skins2
#vlc-plugin-visualization
#warzone2100
#whois
#winff
#wireshark
#xrdp
#xterm


# REFERENCES
# rm_if_link(){ [ ! -L "$1" ] || echo "rm -v \"$1\""; }
# cp_if_link(){ [ ! -L "$1" ] || echo "cp --preserve=all \"$1\""; }


















