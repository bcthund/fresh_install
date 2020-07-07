#!/bin/sh
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

# echo
# echo   "${grey}grey${NC}"
# echo    "${red}red      ${RED}RED${NC}"
# echo  "${green}green    ${GREEN}GREEN${NC}"
# echo "${yellow}yellow   ${YELLOW}YELLOW${NC}"
# echo "${purple}purple   ${PURPLE}PURPLE${NC}"
# echo  "${white}white    ${WHITE}WHITE${NC}"
# echo   "${blue}blue     ${BLUE}BLUE${NC}"
# echo   "${cyan}cyan     ${CYAN}CYAN${NC}"
# echo     "${NC}NC${NC}"
# echo
# echo

# Save the working directory of the script
working_dir=$PWD

# trap ctrl-c and call ctrl_c()
ctrl_c() { echo; echo; exit 0; }
trap ctrl_c INT

# Setup command
DEBUG=false
VERBOSE=false
GOTOSTEP=false
GOTOCONTINUE=false
GOTO=""
FLAGS=""
OTHER_ARGUMENTS=""

for arg in "$@"
do
    case $arg in
        -d|--debug)
        DEBUG=true
        FLAGS="$FLAGS-d "
        shift # Remove --debug from processing
        ;;
        -v|--verbose)
        VERBOSE=true
        FLAGS="$FLAGS-v "
        shift # Remove --verbose from processing
        ;;
        -h|--help)
        echo "${WHITE}"
        echo "Usage: $0 <options>"
        echo
        echo "This script is intended to be run on an existing installation to backup some important user"\
             "data or software settings. The script is then intended to be run on a fresh installation"\
             "(hence the name of the script) to reinstall typical applications and restore the backups."
        echo
        echo "Options:"
        echo "  -h, --help            show this help message and exit"
        echo "  -v, --verbose         print commands being run before running them"
        echo "  -d, --debug           print commands to be run but do not execute them"
        echo "  --step=STEP           jump to an install step then exit when complete"
        echo "  --continue=STEP       jump to an install step and continue to remaining steps"
        echo
        echo "Available STEP Options:"
        echo "                        start     same as starting without a STEP option"
        echo "                        backup    perform a system backup"
        echo "                        download  download/update install scripts, apps, source installs. Always exits"
        echo "                        symlinks  install symlinks from a system backup"
        echo "                        upgrade   perform a system upgrade, and purge apport if desired"
        echo "                        packages  install apt packages including some dependencies for other steps"
        echo "                        pip       install pip3 packages"
        echo "                        snap      install snap packages"
        echo "                        plasmoid  install plasma plasmoids"
        echo "                        downloads install downloaded applications"
        echo "                        source    install applications from source"
        echo "                        config    perform some additional configuration, not including NFS shares"
        echo "                        nfs       setup some standard NFS shares and/or attach media server shares"
        echo "                        restore   perform a system restore from a previous backup"
        echo "${NC}"
        exit
        shift # Remove from processing
        ;;
        --step=*)
        GOTOSTEP=true
        GOTO="${arg#*=}"
        shift # Remove from processing
        ;;
        --continue=*)
        GOTOCONTINUE=true
        GOTO="${arg#*=}"
        shift # Remove from processing
        ;;
        *)
        OTHER_ARGUMENTS="$OTHER_ARGUMENTS$1 "
        echo "${RED}Unknown argument: $1${NC}"
        exit
        shift # Remove generic argument from processing
        ;;
    esac
done

cmd(){
    if [ "$VERBOSE" = true ] || [ "$DEBUG" = true ]; then echo ">> ${WHITE}$1${NC}"; fi;
    if [ "$DEBUG" = false ]; then eval $1; fi;
}

jumpto(){
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
start=${1:-"start"}
jumpto $start
start:

if [ "$GOTOSTEP" = true ] || [ "$GOTOCONTINUE" = true ]; then
    jumpto $GOTO
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
#echo "${grey}\t- Add Extra PPAs${NC}"
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
echo -n "${BLUE}Do you want to (B)ackup, (R)estore, or (D)ownload installers? ${NC}"
read mode
if [ "$mode" != "${mode#[Bb]}" ] ;then
    # ==================================================================
    #   Run backup script
    # ==================================================================
    backup:
    eval "./backup.sh $FLAGS"
    if [ "$GOTOSTEP" = true ]; then echo "${BLUE}Finished${NC}\n"; exit; fi
elif [ "$mode" != "${mode#[Dd]}" ] ;then
    # ==================================================================
    #   Run download script
    # ==================================================================
    download:
    eval "./download.sh $FLAGS"
    exit
    #if [ "$GOTOSTEP" = true ]; then echo "${BLUE}Finished${NC}\n"; exit; fi
elif [ "$mode" != "${mode#[Rr]}" ] ;then
    symlinks:
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
        if [ -d "/home/$USER/Music"     ] ;then   cmd "mv /home/$USER/Music /home/$USER/Music.bak";             fi
        if [ -d "/home/$USER/Pictures"  ] ;then   cmd "mv /home/$USER/Pictures /home/$USER/Pictures.bak";       fi
        if [ -d "/home/$USER/Templates" ] ;then   cmd "mv /home/$USER/Templates /home/$USER/Templates.bak";     fi
        if [ -d "/home/$USER/Videos"    ] ;then   cmd "mv /home/$USER/Videos /home/$USER/Videos.bak";           fi
        
        # Copy all symlinks
        cmd "sudo rsync -aR --info=progress2 ./Migration_$USER/symlinks/ /"
    fi
    if [ "$GOTOSTEP" = true ]; then echo "${BLUE}Finished${NC}\n"; exit; fi

    upgrade:
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tPerform dist-upgrade and purge apport (will ask)${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    echo -n "${BLUE}Proceed ${GREEN}(y/n/e)? ${NC}"; read answer; echo;
    cmd_string="sudo apt update && sudo apt -y dist-upgrade"
    if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "${yellow}Edit command: ${NC}" -e -i $cmd_string cmd_string; fi
    if [ "$answer" != "${answer#[YyEe]}" ] ;then
        cmd "$cmd_string"
        #cmd "sudo apt update"
        #cmd "sudo apt -y dist-upgrade"
        echo
        echo -n "${BLUE}Purge Apport ${GREEN}(y/n)? ${NC}"
        read answer
        echo
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo apt -y purge apport"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo "${BLUE}Finished${NC}\n"; exit; fi


    packages:
    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tInstall Standard Packages${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tarandr\n\taudacious\n\taudacity\n\tbaobab\n\tblender\n\tbrasero\n\tcecilia\n\tchromium-browser\n\tcifs-utils\n\tdevede\n\tdia\n\tdosbox\n\teasytag\n\texfat-utils\n\text4magic\n\tfluidsynth\n\tfontforge\n\tfreecad\n\tg++-8\n\tghex\n\tgimp\n\tgimp-gmic\n\tgimp-plugin-registry\n\tgit\n\tgit-lfs\n\tglade\n\tglmark2\n\tgmic\n\tgpick\n\thardinfo\n\tinkscape\n\tinxi\n\tiptraf\n\tkdevelop\n\tkicad\n\tkicad-footprints\n\tkicad-packages3d\n\tkicad-symbols\n\tkicad-templates\n\tkompare\n\tkrita\n\tlibssl-dev\n\tlibuv1-dev\n\tlibnode64\n\tlibnode-dev\n\tlibdvd-pkg\n\tlibdvdnav4\n\tlibdvdread7\n\tlibnoise-dev\n\tlibsdl2-dev\n\tlibsdl2-image-dev\n\tlibsdl2-mixer-dev\n\tlibsdl2-net-dev\n\tlmms\n\tmesa-utils\n\tneofetch\n\tnet-tools\n\tnetwork-manager-openconnect\n\tnetwork-manager-openvpn\n\tnetwork-manager-ssh\n\tnfs-common\n\tnfs-kernel-server\n\tnmap\n\toctave\n\topenconnect\n\topenjdk-8-jre\n\topenshot\n\topenssh-server\n\topenvpn\n\tpithos\n\tplayonlinux\n\tpython3-pip\n\tqt5-default\n\tqtcreator\n\tqtdeclarative5-dev\n\trawtherapee\n\tremmina\n\trename\n\tsamba\n\tscummvm\n\tsmb4k\n\tsolaar\n\ttexlive-fonts-extra\n\ttexlive-fonts-recommended\n\ttexlive-xetex\n\ttexstudio\n\ttilix\n\tthunderbird\n\tubuntu-restricted-extras\n\tvalgrind\n\tveusz\n\tvim\n\tvirtualbox\n\tvlc\n\tvlc-plugin-access-extra\n\tvlc-plugin-fluidsynth\n\tvlc-plugin-samba\n\tvlc-plugin-skins2\n\tvlc-plugin-visualization\n\twarzone2100\n\twhois\n\twinff\n\twireshark\n\txrdp\n\txterm\n\t${NC}\n"
    echo "${grey}* Answer yes again to apt if it successfully prepares to install packeges.${NC}"
    echo "${grey}* Take caution, if apt has errors then abort the script with ctrl+c and resolve errors manually.${NC}"
    echo
    echo -n "${BLUE}Proceed ${GREEN}(y/n/e)? ${NC}"
    read answer
    echo
    cmd_string1="sudo apt install arandr audacious audacity baobab blender brasero cecilia chromium-browser cifs-utils devede dia dosbox easytag exfat-utils ext4magic fluidsynth fontforge freecad g++-8 ghex gimp gimp-gmic gimp-plugin-registry git git-lfs glade glmark2 gmic gpick hardinfo inkscape inxi iptraf kdevelop kicad kicad-footprints kicad-packages3d kicad-symbols kicad-templates kompare krita libdvd-pkg libssl-dev libuv1-dev libnode64 libnode-dev libdvdnav4 libdvdread7 libnoise-dev libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-net-dev lmms mesa-utils neofetch net-tools network-manager-openconnect network-manager-openvpn network-manager-ssh nfs-common nfs-kernel-server nmap octave openconnect openjdk-8-jre openshot openssh-server openvpn pithos playonlinux python3-pip qt5-default qtcreator qtdeclarative5-dev rawtherapee remmina rename samba scummvm smb4k solaar texlive-fonts-extra texlive-fonts-recommended texlive-xetex texstudio tilix thunderbird ubuntu-restricted-extras valgrind veusz vim virtualbox vlc vlc-plugin-access-extra vlc-plugin-fluidsynth vlc-plugin-samba vlc-plugin-skins2 vlc-plugin-visualization warzone2100 whois winff wireshark xrdp xterm zenity zenity-common"
    cmd_string2="sudo dpkg-reconfigure libdvd-pkg"
    if [ "$answer" != "${answer#[Ee]}" ] ;then
        read -p "${yellow}Edit command 1/2: ${NC}" -e -i $cmd_string1 cmd_string1
        read -p "${yellow}Edit command 2/2: ${NC}" -e -i $cmd_string2 cmd_string2
    fi
    if [ "$answer" != "${answer#[YyEe]}" ] ;then
        cmd "$cmd_string1"
        cmd "$cmd_string2"
        #cmd "sudo apt install arandr audacious audacity baobab blender brasero cecilia chromium-browser cifs-utils devede dia dosbox easytag exfat-utils ext4magic fluidsynth fontforge freecad g++-8 ghex gimp gimp-gmic gimp-plugin-registry git git-lfs glade glmark2 gmic gpick hardinfo inkscape inxi iptraf kdevelop kicad kicad-footprints kicad-packages3d kicad-symbols kicad-templates kompare krita libdvd-pkg libssl-dev libuv1-dev libnode64 libnode-dev libdvdnav4 libdvdread7 libnoise-dev libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-net-dev lmms mesa-utils neofetch net-tools network-manager-openconnect network-manager-openvpn network-manager-ssh nfs-common nfs-kernel-server nmap octave openconnect openjdk-8-jre openshot openssh-server openvpn pithos playonlinux python3-pip qt5-default qtcreator qtdeclarative5-dev rawtherapee remmina rename samba scummvm smb4k solaar texlive-fonts-extra texlive-fonts-recommended texlive-xetex texstudio tilix thunderbird ubuntu-restricted-extras valgrind veusz vim virtualbox vlc vlc-plugin-access-extra vlc-plugin-fluidsynth vlc-plugin-samba vlc-plugin-skins2 vlc-plugin-visualization warzone2100 whois winff wireshark xrdp xterm zenity zenity-common && sudo dpkg-reconfigure libdvd-pkg"
        #cmd "sudo dpkg-reconfigure libdvd-pkg"
    fi
    if [ "$GOTOSTEP" = true ]; then echo "${BLUE}Finished${NC}\n"; exit; fi
   
   
    ppa:
    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tInstall PPA Packages${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tx-tile${NC}\n\n"
    echo -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        echo
        printf "${BLUE}Installing x-tile ${GREEN}(y/n/e)? ${NC}"; read answer; echo
        cmd_string="sudo apt-add-repository -y ppa:giuspen/ppa && sudo apt -y install x-tile"
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "${yellow}Edit command: ${NC}" -e -i $cmd_string cmd_string; fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string"
            #cmd "sudo apt-add-repository -y ppa:giuspen/ppa"
            #cmd "sudo apt -y install x-tile"
            #printf "${BLUE}Installing Knossos:${NC}\n"
            #cmd "sudo apt -y install knossos"              # Currently not supported
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo "${BLUE}Finished${NC}\n"; exit; fi


    pip:
    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tInstall PIP Packages${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tbCNC${NC}\n\n"
    echo -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        echo
        printf "${BLUE}Installing bCNC ${GREEN}(y/n/e)? ${NC}"; read answer; echo
        cmd_string="pip3 install --no-input --upgrade bCNC"
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "${yellow}Edit command: ${NC}" -e -i $cmd_string cmd_string; fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string"
            #cmd "pip3 install --no-input --upgrade bCNC"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo "${BLUE}Finished${NC}\n"; exit; fi


    snap:
    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tInstall Snap packages${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tckan${NC}\n"
    printf "${grey}\tshotcut${NC}\n"
    printf "${grey}\tsublime-text${NC}\n"
    echo
    echo -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"; read answer; echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        echo
        printf "${BLUE}Installing ckan ${GREEN}(y/n/e)? ${NC}"; read answer; echo
        cmd_string="sudo snap install ckan"
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "${yellow}Edit command: ${NC}" -e -i $cmd_string cmd_string; fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string"
            cmd "sudo snap install ckan"
        fi
        
        echo
        printf "${BLUE}Installing shotcut ${GREEN}(y/n/e)? ${NC}"; read answer; echo
        cmd_string="sudo snap install --classic shotcut"
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "${yellow}Edit command: ${NC}" -e -i $cmd_string cmd_string; fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string"
            cmd "sudo snap install --classic shotcut"
        fi
        
        echo
        printf "${BLUE}Installing sublime-text ${GREEN}(y/n/e)? ${NC}"; read answer; echo
        cmd_string="sudo snap install --classic sublime-text"
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "${yellow}Edit command: ${NC}" -e -i $cmd_string cmd_string; fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string"
            cmd "sudo snap install --classic sublime-text"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo "${BLUE}Finished${NC}\n"; exit; fi

    
    plasmoid:
    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tInstall Plasmoids${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tplaces widget${NC}\n\n"
    echo -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"; read answer; echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        echo
        printf "${BLUE}Installing places widget ${GREEN}(y/n/e)? ${NC}"; read answer; echo
        cmd_string="plasmapkg2 -i ./Apps/places-widget-1.3.plasmoid"
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "${yellow}Edit command: ${NC}" -e -i $cmd_string cmd_string; fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string"
            #cmd "plasmapkg2 -i ./Apps/places-widget-1.3.plasmoid"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo "${BLUE}Finished${NC}\n"; exit; fi
    

    downloads:
    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tInstal Downloaded Apps${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\t- bricscad${NC}\n"
    printf "${grey}\t- camotics${NC}\n"
    printf "${grey}\t- chrome${NC}\n"
    printf "${grey}\t- nomachine${NC}\n"
    printf "${grey}\t- multisystem${NC}\n"
    printf "${grey}\t- eclipse${NC}\n"
    printf "${grey}\t- Brother HL3040CN${NC}\n"
    printf "${grey}\t- Plex Media Player${NC}\n"

    echo -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"
    read answer
    echo
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        echo
        printf "${BLUE}BricsCAD v20.2.08 (deb)${NC}"
        echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/BricsCAD-V20.2.08-1-en_US-amd64.deb"
        fi
        
        echo
        printf "${BLUE}Camotics v1.2.0 (deb)${NC}"
        echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/camotics_1.2.0_amd64.deb"
        fi
        
        echo
        printf "${BLUE}Chrome v83.0.4103 (deb)${NC}"
        echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/google-chrome-stable_current_amd64.deb"
        fi
        
        echo
        printf "${BLUE}No Machine v6.11.2 (deb)${NC}"
        echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/nomachine_6.11.2_1_amd64.deb"
        fi
        
        echo
        printf "${BLUE}Steam v20 (deb)${NC}"
        echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/steam_latest.deb"
        fi
        
        echo
        printf "${BLUE}Mutisystem (sh)${NC}"
        echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo chmod +x ./Apps/install-depot-multisystem.sh"
            cmd "sudo ./Apps/install-depot-multisystem.sh"
        fi
        
        echo
        printf "${BLUE}Eclipse v2020-06 (bin)${NC}"
        echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo chmod +x ./Apps/eclipse-installer/eclipse-inst"
            cmd "./Apps/eclipse-installer/eclipse-inst"
        fi
        
        echo
        printf "${BLUE}Printer (HL-3040CN)${NC}\n"
        printf "${YELLOW}NOTE: The install script has been modified, it did not allow directories with spaces in them and the version included here does.${NC}\n"
        echo -n "${GREEN}Continue (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "cd ./Apps/brother/"
            cmd "sudo ./linux-brprinter-installer-2.2.2-1"
            cmd "cd '${working_dir}'"
        fi
        
        echo
        printf "${BLUE}Plex Media Player v2.58.0 (AppImage)${NC}"
        echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            install_dir="/home/$USER/Programs/PlexMP"
            echo
            printf "${BLUE}Where do you want to install to:${NC}\n"
            printf "${YELLOW}  1) ~/Programs/PlexMP/ (default)${NC}\n"
            printf "${YELLOW}  2) Other (user write permission assumed)${NC}\n"
            echo -n "${GREEN}Option? ${NC}"; read answer; if [ "$answer" != "${answer#[2]}" ] ;then
                printf "${BLUE}Directory: ${NC}"
                read install_dir
            fi
            echo
            printf "${YELLOW}Select YES when asked if you want to integrate, close after it has started.${NC}"
            echo
            cmd "mkdir -pv ${install_dir}"
            cmd "rsync -a ./Apps/Plex_Media_Player_2.58.0.1076-38e019da_x64.AppImage ${install_dir}/"
            cmd "${install_dir}/Plex_Media_Player_2.58.0.1076-38e019da_x64.AppImage"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo "${BLUE}Finished${NC}\n"; exit; fi

    
    source:
    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tInstall from Source${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    echo
    echo "${BLUE}Do you want to install programs from source?${NC}"
    echo "${grey}\t- gzdoom${NC}"
    echo "${grey}\t- knossos${NC}"
    echo "${grey}\t- qucs${NC}"
    echo "${grey}\t- valkyrie${NC}"
    #echo "${grey}\t- plex media player${NC}"
    #echo "${grey}\t- flatcam${NC}"
    echo -n "${GREEN}Continue (y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        eval "./gzdoom.sh $FLAGS"
        eval "./knossos.sh $FLAGS"
        eval "./qucs.sh $FLAGS"
        eval "./valkyrie.sh $FLAGS"
        #eval "./plexmp.sh $FLAGS"
        #eval "./flatcam.sh $FLAGS"
    fi
    if [ "$GOTOSTEP" = true ]; then echo "${BLUE}Finished${NC}\n"; exit; fi
    
    
    config:
    echo
    echo "${PURPLE}==========================================================================${NC}"
    echo "${PURPLE}\tAdditional Configuration${NC}"
    echo "${PURPLE}--------------------------------------------------------------------------${NC}"
    # ==================================================================
    #   Add user to vboxusers (should give USB permission)
    # ==================================================================
    echo -n "${BLUE}Add user to vboxusers ${GREEN}(y/n)? ${NC}"
    read answer
    cmd_string="sudo usermod -a -G vboxusers $USER"
    if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "${yellow}Edit command: ${NC}" -e -i $cmd_string cmd_string; fi
    if [ "$answer" != "${answer#[YyEe]}" ] ;then
        cmd "$cmd_string"
        #printf "${BLUE}Adding $USER to vboxusers${NC}\n"
        #cmd "sudo usermod -a -G vboxusers $USER"
    fi
    
    # ==================================================================
    #   Set Samba share password
    # ==================================================================
    echo
    echo -n "${BLUE}Set samba password ${GREEN}(y/n)? ${NC}"
    read answer
    cmd_string="sudo smbpasswd -a $USER"
    if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "${yellow}Edit command: ${NC}" -e -i $cmd_string cmd_string; fi
    if [ "$answer" != "${answer#[YyEe]}" ] ;then
        cmd "$cmd_string"
        #printf "${BLUE}Setting Samba share password for $USER: ${NC}\n"
        #cmd "sudo smbpasswd -a $USER"
    fi
    
    # ==================================================================
    #   Ensure libGL.so exists
    # ==================================================================
    echo
    echo -n "${BLUE}Check for libGL.so links ${GREEN}(y/n)? ${NC}"
    read answer
    cmd_string1="sudo ln -s /usr/lib/i386-linux-gnu/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so"
    cmd_string2="sudo ln -s /usr/lib/x86_64-linux-gnu/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so"
    if [ "$answer" != "${answer#[Ee]}" ] ;then
        read -p "${yellow}Edit command 1/2: ${NC}" -e -i $cmd_string1 cmd_string1;
        read -p "${yellow}Edit command 2/2: ${NC}" -e -i $cmd_string2 cmd_string2;
    fi
    if [ "$answer" != "${answer#[YyEe]}" ] ;then
        cmd "$cmd_string1"
        cmd "$cmd_string2"
        #cmd "sudo ln -s /usr/lib/i386-linux-gnu/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so"
        #cmd "sudo ln -s /usr/lib/x86_64-linux-gnu/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so"
    fi
    if [ "$GOTOSTEP" = true ]; then echo "${BLUE}Finished${NC}\n"; exit; fi
    
    nfs:
    # ==================================================================
    #   Create User and Downloads NFS shares
    # ==================================================================
    echo
    echo "${BLUE}Create standard NFS shares:${NC}"
    echo "${grey}  /home/$USER (ro)${NC}"
    echo "${grey}  /home/$USER/Downloads (rw)${NC}"
    echo -n "${BLUE}Continue ${GREEN}(y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${BLUE}Creating NFS shares: ${NC}\n"
        
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
            echo
            printf "${YELLOW}Erase existing exports (this will erase entire contents of the exports file)${GREEN}(y/n)?${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
                cmd "sudo truncate -s 0 /etc/exports"
            fi
            cmd "echo '' | sudo tee -a /etc/exports"
            cmd "echo '# Exports added by fresh_install.sh' | sudo tee -a /etc/exports"
            cmd "echo '/home/$USER                ${iprange}(ro,sync,no_subtree_check,fsid=root)' | sudo tee -a /etc/exports"
            cmd "echo '/home/$USER/Downloads      ${iprange}(rw,no_root_squash,sync,no_subtree_check,crossmnt)' | sudo tee -a /etc/exports"

        # Restart NFS service
            cmd "sudo exportfs -arv"

        # Ensure firewall access if enabled
            cmd "sudo ufw allow from ${iprange} to any port nfs"
    fi

    # ==================================================================
    #   Mount User and Downloads shares
    # ==================================================================
    echo
    echo "${BLUE}Do you want to mount:${NC}"
    echo "${grey}  /home/<user>${NC}"
    echo "${grey}  /home/<user>/Downloads${NC}"
    echo -n "${BLUE}shares from another pc (you will need the IP and username) ${GREEN}(y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${YELLOW}What is the IP of the target? ${NC}"
        read remoteip
        printf "${YELLOW}What is the username of the target? ${NC}"
        read remoteuser

        # Create mount points
            cmd "sudo mkdir -p /nfs/${remoteip}/Downloads"
            cmd "sudo mkdir -p /nfs/${remoteip}/${remoteuser}"

        # Mount shares
            cmd "sudo mount ${remoteip}:/home/${remoteuser} /nfs/${remoteip}/${remoteuser}"
            cmd "sudo mount ${remoteip}:/home/${remoteuser}/Downloads /nfs/${remoteip}/Downloads"
        
        echo
        printf "${BLUE}Make permanant ${GREEN}(y/n)?${NC}"
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            echo
            printf "${YELLOW}Erase existing mounts (this will look for existing mounts added with this script) ${GREEN}(y/n)?${NC}";
            read answer;
            if [ "$answer" != "${answer#[Yy]}" ] ;then
                cmd "sed -i 's/#FISTD_S.*#FISTD_E\n//gms' /etc/fstab"
            fi
            cmd "echo '' | sudo tee -a /etc/fstab"
            cmd "echo '#FISTD_S: Standard (do not modify)' | sudo tee -a /etc/fstab"
            cmd "echo '${remoteip}:/home/${remoteuser}           /nfs/${remoteip}/${remoteuser}   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo '${remoteip}:/home/${remoteuser}/Downloads /nfs/${remoteip}/Downloads       nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo '#FISTD_E' | sudo tee -a /etc/fstab"
        fi
    fi
    
    # ==================================================================
    #   Create NFS shares to media server
    # ==================================================================
    echo
    echo "${BLUE}Do you want to mount media server shares:${NC}"
    echo "${grey}\t- /mnt/Database${NC}"
    echo "${grey}\t- /home/<user>/Documents${NC}"
    echo "${grey}\t- /home/<user>/Projects${NC}"
    echo "${grey}\t- /home/<user>/Videos${NC}"
    echo "${grey}\t- /home/<user>/Music${NC}"
    echo "${grey}\t- /home/<user>/Pictures${NC}"
    echo -n "${GREEN}Continue (y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${YELLOW}What is the IP of the target? ${NC}"
        read remoteip
        printf "${YELLOW}What is the username of the target? ${NC}"
        read remoteuser

        # Create mount points
            cmd "sudo mkdir -p /nfs/${remoteip}/Database"
            cmd "sudo mkdir -p /nfs/${remoteip}/Documents"
            cmd "sudo mkdir -p /nfs/${remoteip}/Projects"
            cmd "sudo mkdir -p /nfs/${remoteip}/Videos"
            cmd "sudo mkdir -p /nfs/${remoteip}/Music"
            cmd "sudo mkdir -p /nfs/${remoteip}/Pictures"

        # Mount shares
            cmd "sudo mount ${remoteip}:/mnt/Database /nfs/${remoteip}/Database"
            cmd "sudo mount ${remoteip}:/home/${remoteuser}/Documents /nfs/${remoteip}/Documents"
            cmd "sudo mount ${remoteip}:/home/${remoteuser}/Projects /nfs/${remoteip}/Projects"
            cmd "sudo mount ${remoteip}:/home/${remoteuser}/Videos /nfs/${remoteip}/Videos"
            cmd "sudo mount ${remoteip}:/home/${remoteuser}/Music /nfs/${remoteip}/Music"
            cmd "sudo mount ${remoteip}:/home/${remoteuser}/Pictures /nfs/${remoteip}/Pictures"
        
        echo
        printf "${BLUE}Make permanant ${GREEN}(y/n)?${NC}"
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            echo
            printf "${YELLOW}Erase existing mounts (this will look for existing mounts added with this script) ${GREEN}(y/n)?${NC}";
            read answer;
            if [ "$answer" != "${answer#[Yy]}" ] ;then
                cmd "sed -i 's/#FIDS_S.*#FIDS_E\n//gms' /etc/fstab"
            fi
            cmd "echo '' | sudo tee -a /etc/fstab"
            cmd "echo '#FIDS_S: Datasaerver (do not modify)' | sudo tee -a /etc/fstab"
            cmd "echo '${remoteip}:/mnt/Database                 /nfs/${remoteip}/Database  nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo '${remoteip}:/home/${remoteuser}/Documents /nfs/${remoteip}/Documents nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo '${remoteip}:/home/${remoteuser}/Projects  /nfs/${remoteip}/Projects  nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo '${remoteip}:/home/${remoteuser}/Videos    /nfs/${remoteip}/Videos    nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo '${remoteip}:/home/${remoteuser}/Music     /nfs/${remoteip}/Music     nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo '${remoteip}:/home/${remoteuser}/Pictures  /nfs/${remoteip}/Pictures  nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo '#FIDS_E' | sudo tee -a /etc/fstab"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo "${BLUE}Finished${NC}\n"; exit; fi
    
    
    # ==================================================================
    #   Restore Backup
    # ==================================================================
    restore:
    eval "./restore.sh $FLAGS"
    if [ "$GOTOSTEP" = true ]; then echo "${BLUE}Finished${NC}\n"; exit; fi

    echo 
    echo "${PURPLE}==========================================================================${YELLOW}"
    echo "Downlaod only: None, unless DEB/script section failed"
    echo "         Todo:"
    echo "          - Install Chrome-Plasma Integration"
    echo "          - VirtualBox Extensions"
    echo "          - NVidia Drivers"
    echo "              - Generate xorg.conf"
    echo "              - Add Modelines"
    echo "${PURPLE}==========================================================================${NC}"
    
    if [ "$GOTOSTEP" = true ] || [ "$GOTOCONTINUE" = true ]; then exit; fi
else
    echo "${RED}Invalid option: ${mode}"
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
#libssl-dev
#libuv1-dev
#libnode64
#libnode-dev
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


















