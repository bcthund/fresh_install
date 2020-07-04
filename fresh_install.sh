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

# Save the working directory of the script
working_dir=$PWD

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
echo "${grey}This script backs up the current configuration in preparation${NC}"
echo "${grey}for a complete OS reinstall.${NC}"
echo
echo "${grey}A backup will create a './Migration_$USER' folder that${NC}"
echo "${grey}will be used for restore. If the folder already exists then${NC}"
echo "${grey}it will be renamed with a timestamp appended.${NC}"
echo
echo "${grey}A restore will perform an upgrade, software installation, and${NC}"
echo "${grey}settings restoration with a prompt at each step. The restore${NC}"
echo "${grey}performes the following actions:${NC}"
echo "${grey}\t- Create Folder Links${NC}"
echo "${grey}\t\t- This creates links to common folders stored on a different${NC}"
echo "${grey}\t\t  drive such as Videos, Music, Steam, etc.${NC}"
echo "${grey}\t- Add Extra PPAs${NC}"
echo "${grey}\t- Preliminary upgrade and Purge Apport${NC}"
echo "${grey}\t- Install Standard Packages${NC}"
echo "${grey}\t- Install PPA Packages${NC}"
echo "${grey}\t- Install PIP Packages${NC}"
echo "${grey}\t- Install Snap packages${NC}"
echo "${grey}\t- Install Plasmoids${NC}"
echo "${grey}\t- Install Downloaded Apps${NC}"
echo "${grey}\t- Install from Source${NC}"
echo "${grey}\t- Additional Configuration${NC}"
echo "${grey}\t\t- Add user to vboxusers${NC}"
echo "${grey}\t\t- Create Samba password for user${NC}"
echo "${grey}\t- Custom Migration Files${NC}"
echo "${grey}\t\t- This section depends on the bakup in './Migration_$USER'${NC}"
echo
echo "${grey}In the Custom Migration Files section you can answer (y/n/a) which${NC}"
echo "${grey}is yes/no/all. Answering Yes will allow you to choose every migration${NC}"
echo "${grey}section that is applied. All will apply everything. Backups are${NC}"
echo "${grey}made for system configuration files (Plasma, Shortcuts, Power${NC}"
echo "${grey}Management, etc).${NC}"
#echo "${grey}${NC}"
echo
echo -n "${BLUE}Do you want to (B)ackup or (R)estore? ${NC}"
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
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tPerforming Backup${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    
    echo -n "${BLUE}Creating directory './Migration_$USER'...${NC}"
    cmd "mkdir ./Migration_$USER"
    echo "${BLUE}DONE${NC}"
    
    # Keyring
        echo
        echo "${BLUE}Keyring${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.local/share/keyrings/ ./Migration_$USER/root/"
    
    # VPN
        echo
        echo "${BLUE}VPNs${NC}"
        cmd "sudo rsync -aR --info=progress2 /etc/NetworkManager/system-connections/Mikrotik_OVPN_Home2 ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /etc/NetworkManager/system-connections/Mikrotik_OVPN_Karen ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /etc/NetworkManager/system-connections/MSELEC ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /etc/NetworkManager/system-connections/.cert ./Migration_$USER/root/"
    
    # Warzone 2100
        echo
        echo "${BLUE}Warzone 2100${NC}"
        cmd "sudo rsync -aR --info=progress2 /usr/share/games/warzone2100/sequences.wz ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.warzone2100-3.2 ./Migration_$USER/root/"
    
    # Knossos
        echo
        echo "${BLUE}Knossos${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/knossos ./Migration_$USER/root/"
    
    # RawTherapee
        echo
        echo "${BLUE}RawTherapee${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/RawTherapee ./Migration_$USER/root/"
    
    # BricsCAD
        echo
        echo "${BLUE}BricsCAD${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/BricsCAD ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /var/bricsys/BricsCAD_ShapeV18.lic ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /var/bricsys/BricsCADV17.lic ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /var/bricsys/BricsCADV18.lic ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /var/bricsys/BricsCADV20.lic ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /var/bricsys/CommunicatorV18.lic ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /opt/bricsys/bricscad/v20/RenderMaterialStatic ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /opt/bricsys/communicator ./Migration_$USER/root/"
    
    # DosBox
        echo
        echo "${BLUE}DosBox${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.dosbox ./Migration_$USER/root/"
    
    # Frictional Games
        echo
        echo "${BLUE}Frictional Games${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.frictionalgames ./Migration_$USER/root/"
    
    # ThunderBird
        echo
        echo "${BLUE}ThunderBird${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.thunderbird/profiles.ini ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.thunderbird/eu3c43qa.default ./Migration_$USER/root/"
    
    # KiCAD
        echo
        echo "${BLUE}KiCAD${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kicad ./Migration_$USER/root/"
    
    # gzdoom
        echo
        echo "${BLUE}gzdoom${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/gzdoom ./Migration_$USER/root/"
    
    # Audacious
        echo
        echo "${BLUE}Audacious${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/audacious ./Migration_$USER/root/"
    
    # VLC
        echo
        echo "${BLUE}VLC${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/vlc ./Migration_$USER/root/"
    
    # Eclipse
        echo
        echo "${BLUE}Eclipse${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/Projects/Eclipse/.metadata ./Migration_$USER/root/"
    
    # KATE
        echo
        echo "${BLUE}KAte${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/katerc ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/katesyntaxhighlightingrc ./Migration_$USER/root/"
    
    # Power Management Profile (KDE) (BACKUP)
        echo
        echo "${BLUE}Power Management${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/powermanagementprofilesrc ./Migration_$USER/root/"
    
    # Global Shortcuts (KDE) (BACKUP)
        echo
        echo "${BLUE}Global Shortcuts${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kglobalshortcutsrc ./Migration_$USER/root/"
    
    # Plasma Settings (Panel, Notifications, Theme, Desktop Effects) (KDE) (BACKUP)
        echo
        echo "${BLUE}Plasma Settings${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasmanotifyrc ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasmarc ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kwinrc ./Migration_$USER/root/"
    
    # Login scripts (.bashr/.profile) (BACKUP)
        echo
        echo "${BLUE}Login Scripts${NC}"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.bashrc ./Migration_$USER/root/"
        cmd "sudo rsync -aR --info=progress2 /home/$USER/.profile ./Migration_$USER/root/"
        
    # symlinks (predetermined list)
        echo
        echo "${BLUE}Symlinks${NC}"
        cp_if_link(){ [ ! -L "$1" ] || cmd "rsync -aR --info=progress2 $1 ./Migration_$USER/symlinks/"; }
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
        cp_if_link /home/$USER/.local/share/Steam
else
    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tCreate Folder Links${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    echo "${grey}WARNING! The following folders will be backed up if they already exist,${NC}"
    echo "${grey}         and you will need to check if it is safe to remove them. On a${NC}"
    echo "${grey}         fresh install these should normally all be empty.${NC}"
    echo "${grey}\t- ~/Documents${NC}"
    #echo "${grey}\t- ~/Downloads${NC}"
    echo "${grey}\t- ~/Music${NC}"
    echo "${grey}\t- ~/Pictures${NC}"
    echo "${grey}\t- ~/Templates${NC}"
    echo "${grey}\t- ~/Videos${NC}"
    echo
    echo "${grey}The following additional links will be created without any checks:${NC}"
    echo "${grey}\t- ~/.bricscad${NC}"
    echo "${grey}\t- ~/.eve${NC}"
    echo "${grey}\t- ~/.FreeCAD${NC}"
    echo "${grey}\t- ~/.minecraft${NC}"
    echo "${grey}\t- ~/.PlayOnLinux${NC}"
    echo "${grey}\t- ~/.steam${NC}"
    echo "${grey}\t- ~/Bricsys${NC}"
    echo "${grey}\t- ~/octave${NC}"
    echo "${grey}\t- ~/PlayOnLinux's virtual drives${NC}"
    echo "${grey}\t- ~/Programs${NC}"
    echo "${grey}\t- ~/Projects${NC}"
    echo "${grey}\t- ~/.local/share/Steam${NC}"
    echo
    echo -n "${BLUE}Proceed? ${GREEN}(y/n)? ${NC}"
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
        cmd "sudo rsync -aR --info=progress2 ./Migration_$USER/symlinks/ /"
    fi

    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tAdd Extra PPAs${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    echo "${grey}\tx-tile${NC}"
    echo
    echo -n "${BLUE}Proceed? ${GREEN}(y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        cmd "sudo apt-add-repository -yn ppa:giuspen/ppa"
        #cmd "sudo add-apt-repository -yn ppa:ngld/knossos"     # Currently not supported
    fi


    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tPerform dist-upgrade and purge apport (will ask)${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    echo -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        cmd "sudo apt update"
        cmd "sudo apt -y dist-upgrade"
        echo
        echo -n "${BLUE}Purge Apport ${GREEN}(y/n)? ${NC}"
        read answer
        echo
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo apt -y purge apport"
        fi
    fi


    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tInstall Standard Packages${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tarandr\n\taudacious\n\taudacity\n\tbaobab\n\tblender\n\tbrasero\n\tcecilia\n\tchromium-browser\n\tcifs-utils\n\tdevede\n\tdia\n\tdosbox\n\teasytag\n\texfat-utils\n\text4magic\n\tfluidsynth\n\tfontforge\n\tfreecad\n\tg++-8\n\tghex\n\tgimp\n\tgimp-gmic\n\tgimp-plugin-registry\n\tgit\n\tgit-lfs\n\tglade\n\tglmark2\n\tgmic\n\tgpick\n\thardinfo\n\tinkscape\n\tinxi\n\tiptraf\n\tkdevelop\n\tkicad\n\tkicad-footprints\n\tkicad-packages3d\n\tkicad-symbols\n\tkicad-templates\n\tkompare\n\tkrita\n\tlibdvd-pkg\n\tlibdvdnav4\n\tlibdvdread7\n\tlibnoise-dev\n\tlibsdl2-dev\n\tlibsdl2-image-dev\n\tlibsdl2-mixer-dev\n\tlibsdl2-net-dev\n\tlmms\n\tmesa-utils\n\tneofetch\n\tnet-tools\n\tnetwork-manager-openconnect\n\tnetwork-manager-openvpn\n\tnetwork-manager-ssh\n\tnfs-common\n\tnfs-kernel-server\n\tnmap\n\toctave\n\topenconnect\n\topenjdk-8-jre\n\topenshot\n\topenssh-server\n\topenvpn\n\tpithos\n\tplayonlinux\n\tpython3-pip\n\tqt5-default\n\tqtcreator\n\tqtdeclarative5-dev\n\trawtherapee\n\tremmina\n\trename\n\tsamba\n\tscummvm\n\tsmb4k\n\tsolaar\n\ttexlive-fonts-extra\n\ttexlive-fonts-recommended\n\ttexlive-xetex\n\ttexstudio\n\ttilix\n\tthunderbird\n\tubuntu-restricted-extras\n\tvalgrind\n\tveusz\n\tvim\n\tvirtualbox\n\tvlc\n\tvlc-plugin-access-extra\n\tvlc-plugin-fluidsynth\n\tvlc-plugin-samba\n\tvlc-plugin-skins2\n\tvlc-plugin-visualization\n\twarzone2100\n\twhois\n\twinff\n\twireshark\n\txrdp\n\txterm\n\t${NC}\n"
    echo "${grey}* Answer yes again to apt if it successfully prepares to install packeges.${NC}"
    echo "${grey}* Take caution, if apt has errors then abort the script with ctrl+c and resolve errors manually.${NC}"
    echo
    echo -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        cmd "sudo apt install arandr audacious audacity baobab blender brasero cecilia chromium-browser cifs-utils devede dia dosbox easytag exfat-utils ext4magic fluidsynth fontforge freecad g++-8 ghex gimp gimp-gmic gimp-plugin-registry git git-lfs glade glmark2 gmic gpick hardinfo inkscape inxi iptraf kdevelop kicad kicad-footprints kicad-packages3d kicad-symbols kicad-templates kompare krita libdvd-pkg libdvdnav4 libdvdread7 libnoise-dev libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-net-dev lmms mesa-utils neofetch net-tools network-manager-openconnect network-manager-openvpn network-manager-ssh nfs-common nfs-kernel-server nmap octave openconnect openjdk-8-jre openshot openssh-server openvpn pithos playonlinux python3-pip qt5-default qtcreator qtdeclarative5-dev rawtherapee remmina rename samba scummvm smb4k solaar texlive-fonts-extra texlive-fonts-recommended texlive-xetex texstudio tilix thunderbird ubuntu-restricted-extras valgrind veusz vim virtualbox vlc vlc-plugin-access-extra vlc-plugin-fluidsynth vlc-plugin-samba vlc-plugin-skins2 vlc-plugin-visualization warzone2100 whois winff wireshark xrdp xterm"
    fi



    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tInstall PPA Packages${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tx-tile${NC}\n\n"
    echo -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${BLUE}Installing x-tile${NC}\n"
        cmd "sudo apt -y install x-tile"
        #printf "${BLUE}Installing Knossos:${NC}\n"
        #cmd "sudo apt -y install knossos"              # Currently not supported
    fi


    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tInstall PIP Packages${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tbCNC${NC}\n\n"
    echo -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${BLUE}Installing bCNC${NC}\n"
        cmd "pip3 install --no-input --upgrade bCNC"
    fi


    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tInstall Snap packages${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tckan\n\tshotcut\n\tsublime-text${NC}\n\n"
    echo -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        #cmd "sudo snap install gzdoom ckan"
        printf "${BLUE}Installing ckan${NC}\n"; cmd "sudo snap install ckan"
        printf "${BLUE}Installing shotcut${NC}\n"; cmd "sudo snap install --classic shotcut"
        printf "${BLUE}Installing sublime-text${NC}\n"; cmd "sudo snap install --classic sublime-text"
    fi

    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tInstall Plasmoids${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tplaces widget${NC}\n\n"
    echo -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${BLUE}Installing places widget${NC}\n"
        cmd "plasmapkg2 -u ./Apps/places-widget-1.3.plasmoid"
    fi
    

    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tInstal Downloaded Apps${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tbricscad\n\tcamotics\n\tchrome\n\tnomachine\n\tmultisystem\n\teclipse${NC}\n\n"
    echo -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"
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
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tInstall from Source${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    cmd "./gzdoom.sh"
    cmd "./knossos.sh"
    cmd "./qucs.sh"
    
    
    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tAdditional Configuration${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    echo -n "${BLUE}Add user to vboxusers ${GREEN}(y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${BLUE}Adding $USER to vboxusers${NC}\n"
        cmd "sudo usermod -a -G vboxusers $USER"
    fi
    
    echo
    echo -n "${BLUE}Set samba password ${GREEN}(y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${BLUE}Setting Samba share password for $USER: ${NC}\n"
        cmd "sudo smbpasswd -a $USER"
    fi
    
    echo
    echo -n "${BLUE}Check for libGL.so links ${GREEN}(y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        if [ -d "/usr/lib/i386-linux-gnu" ]; then
            if [ -f "/usr/lib/i386-linux-gnu/libGL.so" ] && [ -f "/usr/lib/i386-linux-gnu/libGL.so.1" ] ; then
                printf "${YELLOW}i386: libGL.so doesn't exist, creating link to libGL.so.1${NC}\n"
                cmd "ln -s /usr/lib/i386-linux-gnu/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so"
            else
                printf "${RED}i386: Failed! Both 'libGL.so' and 'libGL.so.1' don't exist, I don't know what to link to.${NC}\n"
            fi
        else
            printf "${RED}i386: Error! Folder '/usr/lib/x86_64-linux-gnu' doesn't exist!${NC}\n"
        fi
        
        if [ -d "/usr/lib/x86_64-linux-gnu" ]; then
            if [ -f "/usr/lib/x86_64-linux-gnu/libGL.so" ] && [ -f "/usr/lib/x86_64-linux-gnu/libGL.so.1" ] ; then
                printf "${YELLOW}x86_64: libGL.so doesn't exist, creating link to libGL.so.1${NC}\n"
                cmd "ln -s /usr/lib/x86_64-linux-gnu/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so"
            else
                printf "${RED}x86_64: Failed! Both 'libGL.so' and 'libGL.so.1' don't exist, I don't know what to link to.${NC}\n"
            fi
        else
            printf "${RED}x86_64: Error! Folder '/usr/lib/x86_64-linux-gnu' doesn't exist!${NC}\n"
        fi
    fi
    
    echo
    echo -n "${BLUE}Create standard NFS shares ${GREEN}(y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        #printf "${BLUE}Creating NFS shares Downloads(rw) and $USER(ro): ${NC}\n"
        printf "${BLUE}Creating NFS shares: ${NC}\n"
        printf "${grey}\t- /home/$USER$ (ro){NC}\n"
        printf "${grey}\t- /home/$USER/Downloads (rw)${NC}\n"
        
        iprange="192.168.0.0/16"
        echo
        echo -n "${YELLOW}Do you want to change the default ip range of '$iprange' ${GREEN}(y/n)? ${NC}"
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            echo -n "${YELLOW}Enter ip range: ${GREEN}"
            read iprange
            echo -n "${NC}"
        fi
        
        # Export directory
            cmd "echo '' | sudo tee -a /etc/exports"
            cmd "echo '# Exports added by fresh_install.sh' | sudo tee -a /etc/exports"
            cmd "echo '/home/$USER                ${iprange}(ro,sync,no_subtree_check,fsid=root)' | sudo tee -a /etc/exports"
            cmd "echo '/home/$USER/Downloads      ${iprange}(rw,no_root_squash,sync,no_subtree_check,crossmnt)' | sudo tee -a /etc/exports"

        # Restart NFS service
            cmd "sudo exportfs -arv"

        # Ensure firewall access if enabled
            cmd "sudo ufw allow from ${iprange} to any port nfs"
    fi

    
    echo
    echo -n "${BLUE}Do you want to mount User(ro) and Downloads(rw) shares on another pc (you will need the IP and username) ${GREEN}(y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${BLUE}What is the IP of the target? ${NC}"
        read remoteip
        printf "${BLUE}What is the username of the target? ${NC}"
        read remoteuser

        # Create mount points
            cmd "sudo mkdir -p /nfs/${remoteip}/Downloads"
            cmd "sudo mkdir -p /nfs/${remoteip}/${remoteuser}"

        # Mount shares
            cmd "sudo mount ${remoteip}:/home/${remoteuser}/Downloads /nfs/${remoteip}/Downloads"
            #cmd "sudo mount ${remoteip}:/home/${remoteuser} /nfs/${remoteip}/${remoteuser}"
        
        printf "${BLUE}Make permanant (Make sure to only do this once) ${GREEN}(y/n)?${NC}"
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "echo '' | sudo tee -a /etc/fstab"
            cmd "echo '# Mounts added by fresh_install.sh' | sudo tee -a /etc/fstab"
            cmd "echo '${remoteip}:/home/${remoteuser}           /nfs/${remoteip}/${remoteuser}   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo '${remoteip}:/home/${remoteuser}/Downloads /nfs/${remoteip}/Downloads       nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
        fi
    fi
    
    
    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tCustom Migration Files${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tvpn settings\n\twarzone2100\n\tknossos\n\trawtherapee\n\tbricscad\n\tdosbox\n\tfrictional games\n\tthunderbird\n\tkicad\n\tgzdoom\n\taudacious${NC}\n\n"
    echo -n "${BLUE}Proceed? (y/n/a)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[AaYy]}" ] ;then

        # Yes to All?
        if [ "$answer" != "${answer#[Aa]}" ] ;then answer2="y"; else answer2=""; fi

        # VPN
        printf "${BLUE}VPN...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/etc/NetworkManager/system-connections/ /etc/NetworkManager/system-connections/"
            #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/etc/NetworkManager/system-connections/Mikrotik_OVPN_Karen /etc/NetworkManager/system-connections/"
            #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/etc/NetworkManager/system-connections/MSELEC /etc/NetworkManager/system-connections/"
            #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/etc/NetworkManager/system-connections/.cert /etc/NetworkManager/system-connections/"
        fi
        
        # Warzone 2100
        printf "${BLUE}Warzone2100...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/usr/share/games/warzone2100/ /usr/share/games/warzone2100/"
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.warzone2100-3.2/ /home/$USER/.warzone2100-3.2/"
        fi
        
        # Knossos
        printf "${BLUE}Knossos...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/knossos/ /home/$USER/.config/knossos/"
        fi
        
        # RawTherapee
        printf "${BLUE}RawTherapee...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/RawTherapee/ /home/$USER/.config/RawTherapee/"
        fi
        
        # BricsCAD
        printf "${BLUE}BricsCAD...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/BricsCAD/ /home/$USER/BricsCAD/"
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/var/bricsys/ /var/bricsys/"
            #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/var/bricsys/BricsCAD_ShapeV18.lic /var/bricsys/"
            #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/var/bricsys/BricsCADV17.lic /var/bricsys/"
            #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/var/bricsys/BricsCADV18.lic /var/bricsys/"
            #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/var/bricsys/BricsCADV20.lic /var/bricsys/"
            #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/var/bricsys/CommunicatorV18.lic /var/bricsys/"
            
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/opt/bricsys/ /opt/bricsys/"
            #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/opt/bricsys/bricscad/v18/RenderMaterialStatic/ /opt/bricsys/bricscad/v20/"
            #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/opt/bricsys/communicator /opt/bricsys/"
        fi
        
        # DosBox
        printf "${BLUE}DosBox...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.dosbox/ /home/$USER/.dosbox/"
        fi
        
        # Frictional Games
        printf "${BLUE}Frictional Games...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.frictionalgames/ /home/$USER/.frictionalgames/"
        fi
        
        # ThunderBird
        printf "${BLUE}ThunderBird...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.thunderbird/ /home/$USER/.thunderbird/"
            #cmd "mkdir -p /home/$USER/.thunderbird"
            #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.thunderbird/profiles.ini /home/$USER/.thunderbird/"
            #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.thunderbird/eu3c43qa.default /home/$USER/.thunderbird/"
            #cmd "sudo chown -R $USER:$USER /home/$USER/.thunderbird"
        fi
        
        # KiCAD
        printf "${BLUE}KiCAD...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/kicad/ /home/$USER/.config/kicad/"
        fi
        
        # gzdoom (handled in gzdoom.sh now)
        #printf "${BLUE}gzdoom...${NC}"
        #if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        #if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        #    cmd "gzdoom -norun"
        #    cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/snap/gzdoom/current/.config/gzdoom/ /home/$USER/snap/gzdoom/current/.config/"
        #fi
        
        # Audacious
        printf "${BLUE}Audacious...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/audacious/ /home/$USER/.config/audacious/"
        fi
        
        # VLC
        printf "${BLUE}VLC...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/vlc/ /home/$USER/.config/vlc/"
        fi
        
        # Eclipse
        printf "${BLUE}Eclipse...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings/ /home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings/"
            #cmd "mkdir -p /home/$USER/Projects/Eclipse/"
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/Projects/Eclipse/.metadata/ /home/$USER/Projects/Eclipse/.metadata/"
        fi
        
        # KATE
        printf "${BLUE}Kate...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/katerc /home/$USER/.config/katerc"
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/katesyntaxhighlightingrc /home/$USER/.config/katesyntaxhighlightingrc"
        fi
        
        # Power Management Profile (KDE) (BACKUP)
        printf "${BLUE}Power Management (KDE)...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.config/powermanagementprofilesrc /home/$USER/.config/powermanagementprofilesrc.bak"
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/powermanagementprofilesrc /home/$USER/.config/powermanagementprofilesrc"
        fi
        
        # Global Shortcuts (KDE) (BACKUP)
        printf "${BLUE}Global Shortcuts (KDE)...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.config/kglobalshortcutsrc /home/$USER/.config/kglobalshortcutsrc.bak"
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/kglobalshortcutsrc /home/$USER/.config/kglobalshortcutsrc"
        fi
        
        # Plasma Settings (Panel, Notifications, Theme, Desktop Effects) (KDE) (BACKUP)
        printf "${BLUE}Plasma Settings (KDE)...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc.bak"
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc"
            
            cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.config/plasmanotifyrc /home/$USER/.config/plasmanotifyrc.bak"
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/plasmanotifyrc /home/$USER/.config/plasmanotifyrc"
            
            cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.config/plasmarc /home/$USER/.config/plasmarc.bak"
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/plasmarc /home/$USER/.config/plasmarc"
            
            cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.config/kwinrc /home/$USER/.config/kwinrc.bak"
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/kwinrc /home/$USER/.config/kwinrc"
        fi
        
        # Login scripts (.bashr/.profile) (BACKUP)
        printf "${BLUE}Login Scripts (.bashrc/.profile)...${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.bashrc /home/$USER/.bashrc.bak"
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.bashrc /home/$USER/.bashrc"
            
            cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.profile /home/$USER/.profile.bak"
            cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.profile /home/$USER/.profile"
        fi
    fi

    echo 
    echo "${PURPLE}==========================================================================${YELLOW}"
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
    echo "${PURPLE}==========================================================================${NC}"
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
# cp_if_link(){ [ ! -L "$1" ] || echo "rsync -aR --info=progress2 \"$1\""; }


















