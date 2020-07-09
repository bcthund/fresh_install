#!/bin/bash

# grey='\033[1;30m'
# red='\033[0;31m'
# RED='\033[1;31m'
# green='\033[0;32m'
# GREEN='\033[1;32m'
# yellow='\033[0;33m'
# YELLOW='\033[1;33m'
# purple='\033[0;35m'
# PURPLE='\033[1;35m'
# white='\033[0;37m'
# WHITE='\033[1;37m'
# blue='\033[0;34m'
# BLUE='\033[1;34m'
# cyan='\033[0;36m'
# CYAN='\033[1;36m'
# NC='\033[0m'

grey='\e[0m\e[37m'
GREY='\e[1m\e[90m'
red='\e[0m\e[91m'
RED='\e[1m\e[31m'
green='\e[0m\e[92m'
GREEN='\e[1m\e[32m'
yellow='\e[0m\e[93m'
YELLOW='\e[1m\e[33m'
purple='\e[0m\e[95m'
PURPLE='\e[1m\e[35m'
white='\e[0m\e[37m'
WHITE='\e[1m\e[37m'
blue='\e[0m\e[94m'
BLUE='\e[1m\e[34m'
cyan='\e[0m\e[96m'
CYAN='\e[1m\e[36m'
NC='\e[0m\e[39m'
#INTRO='\e[30m\e[44m'   # Sample foreground/background

# echo -e
# echo -e   "${grey}grey${NC}"
# echo -e    "${red}red      ${RED}RED${NC}"
# echo -e  "${green}green    ${GREEN}GREEN${NC}"
# echo -e "${yellow}yellow   ${YELLOW}YELLOW${NC}"
# echo -e "${purple}purple   ${PURPLE}PURPLE${NC}"
# echo -e  "${white}white    ${WHITE}WHITE${NC}"
# echo -e   "${blue}blue     ${BLUE}BLUE${NC}"
# echo -e   "${cyan}cyan     ${CYAN}CYAN${NC}"
# echo -e     "${NC}NC${NC}"
# echo -e
# echo -e

# Save the working directory of the script
working_dir=$PWD

# trap ctrl-c and call ctrl_c()
ctrl_c() { echo -e; echo -e; exit 0; }
trap ctrl_c INT

# Setup command
DEBUG=false
VERBOSE=false
GOTOSTEP=false
GOTOCONTINUE=false
BACKUP_DIR="./Migration_$USER"
ARCHIVE_FILE="${BACKUP_DIR}.tar.gz"
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
        -z|--zip)
        COMPRESS=true
        FLAGS="$FLAGS-z "
        shift # Remove from processing
        ;;
        -x)
        NOCOMPRESS=true
        FLAGS="$FLAGS-x "
        shift # Remove from processing
        ;;
        -h|--help)
        echo -e "${WHITE}"
        echo -e "Usage: $0 <options>"
        echo -e
        echo -e "This script is intended to be run on an existing installation to backup some important user"\
                "data or software settings. The script is then intended to be run on a fresh installation"\
                "(hence the name of the script) to reinstall typical applications and restore the backups."
        echo -e
        echo -e "Options:"
        echo -e "  -h, --help            show this help message and exit"
        echo -e "  -v, --verbose         print commands being run before running them"
        echo -e "  -d, --debug           print commands to be run but do not execute them"
        echo -e "  -z, --zip             Backup: compress the backup and remove backup folder"
        echo -e "                        Restore: the backup is compressed (hint)"
        echo -e "  -x                    Backup: do not compress backup folder"
        echo -e "                        Restore: the backup is not compressed (hint)"
        echo -e "  --dir=DIRECTORY       specify the backup directory to override './Migration_$USER'"
        echo -e "  --archive=FILE        specify the backup archive to override './Migration_$USER.tar.gz'"
        echo -e "  --step=STEP           jump to an install step then exit when complete"
        echo -e "  --continue=STEP       jump to an install step and continue to remaining steps"
        echo -e
        echo -e "Available STEP Options:"
        echo -e "                        start      same as starting without a STEP option"
        echo -e "                        uncompress extract the contents of a backup"
        echo -e "                        backup     perform a system backup"
        echo -e "                        download   download/update install scripts, apps, source installs. Always exits"
        echo -e "                        symlinks   install symlinks from a system backup"
        echo -e "                        upgrade    perform a system upgrade, and purge apport if desired"
        echo -e "                        packages   install apt packages including some dependencies for other steps"
        echo -e "                        pip        install pip3 packages"
        echo -e "                        snap       install snap packages"
        echo -e "                        plasmoid   install plasma plasmoids"
        echo -e "                        downloads  install downloaded applications"
        echo -e "                        source     install applications from source"
        echo -e "                        config     perform some additional configuration, not including NFS shares"
        echo -e "                        nfs        setup some standard NFS shares and/or attach media server shares"
        echo -e "                        restore    perform a system restore from a previous backup"
        echo -e "${NC}"
        exit
        shift # Remove from processing
        ;;
        --dir=*)
        BACKUP_DIR="$(echo ${arg#*=} | sed 's:/*$::')"
        FLAGS="$FLAGS--dir=${BACKUP_DIR} "
        shift # Remove from processing
        ;;
        --archive=*)
        ARCHIVE_FILE="${arg#*=}"
        FLAGS="$FLAGS--archive=${ARCHIVE_FILE} "
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
        echo -e "${RED}Unknown argument: $1${NC}"
        exit
        shift # Remove generic argument from processing
        ;;
    esac
done

cmd(){
    if [ "$VERBOSE" = true ] || [ "$DEBUG" = true ]; then echo -e ">> ${WHITE}$1${NC}"; fi;
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

echo -e
echo -e "${INTRO}                                                                       ${NC}"
echo -e "${INTRO}This script backs up the current configuration in preparation          ${NC}"
echo -e "${INTRO}for a complete OS reinstall.                                           ${NC}"
echo -e "${INTRO}                                                                       ${NC}"
echo -e "${INTRO}A backup will create a './Migration_<user>' folder that                ${NC}"
echo -e "${INTRO}will be used for restore. If the folder already exists then            ${NC}"
echo -e "${INTRO}it will be renamed with a timestamp appended.                          ${NC}"
echo -e "${INTRO}                                                                       ${NC}"
echo -e "${INTRO}A restore will perform an upgrade, software installation, and          ${NC}"
echo -e "${INTRO}settings restoration with a prompt at each step. The restore           ${NC}"
echo -e "${INTRO}performes the following actions:                                       ${NC}"
echo -e "${INTRO}  - Create Folder Links                                                ${NC}"
echo -e "${INTRO}    - This creates links to common folders stored on a different       ${NC}"
echo -e "${INTRO}      drive such as Videos, Music, Steam, etc.                         ${NC}"
echo -e "${INTRO}  - Preliminary upgrade and Purge Apport                               ${NC}"
echo -e "${INTRO}  - Install Standard Packages                                          ${NC}"
echo -e "${INTRO}  - Install PPA Packages                                               ${NC}"
echo -e "${INTRO}  - Install PIP Packages                                               ${NC}"
echo -e "${INTRO}  - Install Snap packages                                              ${NC}"
echo -e "${INTRO}  - Install Plasmoids                                                  ${NC}"
echo -e "${INTRO}  - Install Downloaded Apps                                            ${NC}"
echo -e "${INTRO}  - Install from Source                                                ${NC}"
echo -e "${INTRO}  - Additional Configuration                                           ${NC}"
echo -e "${INTRO}    - Add user to vboxusers                                            ${NC}"
echo -e "${INTRO}    - Create Samba password for user                                   ${NC}"
echo -e "${INTRO}  - Custom Migration Files                                             ${NC}"
echo -e "${INTRO}    - This section depends on the bakup in './Migration_<user>'        ${NC}"
echo -e "${INTRO}                                                                       ${NC}"
echo -e "${INTRO}In the Custom Migration Files section you can answer (y/n/a) which     ${NC}"
echo -e "${INTRO}is yes/no/all. Answering Yes will allow you to choose every migration  ${NC}"
echo -e "${INTRO}section that is applied. All will apply everything. Backups are        ${NC}"
echo -e "${INTRO}made for system configuration files (Plasma, Shortcuts, Power          ${NC}"
echo -e "${INTRO}Management, etc).                                                      ${NC}"
echo -e "${INTRO}                                                                       ${NC}"
#echo -e "${grey}${NC}"
echo -e
echo -e "${YELLOW}Using backup directory: '${BACKUP_DIR}'${NC}"
echo -e "${YELLOW}Using archive: '${ARCHIVE_FILE}'${NC}"
echo -e -n "${BLUE}Do you want to (B)ackup, (R)estore, or (D)ownload installers? ${NC}"
read mode
if [ "$mode" != "${mode#[Bb]}" ] ;then
    # ==================================================================
    #   Run backup script
    # ==================================================================
    backup:
    eval "./backup.sh $FLAGS"
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
elif [ "$mode" != "${mode#[Dd]}" ] ;then
    # ==================================================================
    #   Run download script
    # ==================================================================
    download:
    eval "./download.sh $FLAGS"
    exit
    #if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
elif [ "$mode" != "${mode#[Rr]}" ] ;then
    uncompress:
    echo -e "${PURPLE}==========================================================================${NC}"
    echo -e "${PURPLE}\tUncompress Backup${NC}"
    echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    if ! command -v pigz &> /dev/null; then cmd "sudo apt install pigz"; fi
    if ! command -v pv &> /dev/null; then cmd "sudo apt install pv"; fi
    cmd_string2="pv ${ARCHIVE_FILE} | sudo tar --same-owner -I pigz -x -C ./"
    
    if [ -f "${ARCHIVE_FILE}" ]; then
        if [ ! -d "${BACKUP_DIR}/" ]; then
            cmd "$cmd_string2"
        else
            echo -e -n "${YELLOW}Backup directory exists, remove before uncompress${GREEN} (y/n)? ${NC}"; read answer; echo -e;
            if [ "$answer" != "${answer#[Yy]}" ] ;then
                cmd "sudo rm -rf ${BACKUP_DIR}/"
                cmd "$cmd_string2"
            fi
        fi
    else
        if [ ! -d "${BACKUP_DIR}/" ]; then
            echo -e -n "${YELLOW}No compressed backup found and no backup directory found.\nYou should use the --dir and --archive flags for custom names and locations.\nDo you want to edit the uncompress command for a custom backup name${GREEN} (y/n)? ${NC}"; read answer; echo -e;
            if [ "$answer" != "${answer#[Yy]}" ] ;then
                read -p "$(echo -e ${yellow}Edit command: ${NC})" -e -i "${cmd_string2}" cmd_string2;
                cmd "$cmd_string2"
            else
                printf "${RED}Error! I don't have a backup directory to work with!${NC}"
                exit
            fi
        else
            echo -e -n "${YELLOW}I couldn't find a compressed backup, but I found a backup directory.\nShould I use the '${BACKUP_DIR}/' directory${GREEN} (y/n)? ${NC}"; read answer; echo -e;
            if [ "$answer" != "${answer#[Yy]}" ] ;then
                cmd "$cmd_string2"
            fi
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    symlinks:
    echo -e
    echo -e "${PURPLE}==========================================================================${NC}"
    echo -e "${PURPLE}\tCreate Folder Links${NC}"
    echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    #echo -e "${PURPLE}NOTES${NC}"
    #echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    echo -e "${grey}WARNING! The following folders will be backed up if they already exist,${NC}"
    echo -e "${grey}         and you will need to check if it is safe to remove them. On a${NC}"
    echo -e "${grey}         fresh install these should normally all be empty.${NC}"
    echo -e "${grey}\t- ~/Documents${NC}"
    echo -e "${grey}\t- ~/Downloads${NC}"
    echo -e "${grey}\t- ~/Music${NC}"
    echo -e "${grey}\t- ~/Pictures${NC}"
    echo -e "${grey}\t- ~/Templates${NC}"
    echo -e "${grey}\t- ~/Videos${NC}"
    echo -e
    echo -e "${grey}The following additional links will be created without any checks:${NC}"
    echo -e "${grey}\t- ~/.bricscad${NC}"
    echo -e "${grey}\t- ~/.eve${NC}"
    echo -e "${grey}\t- ~/.FreeCAD${NC}"
    echo -e "${grey}\t- ~/.minecraft${NC}"
    echo -e "${grey}\t- ~/.PlayOnLinux${NC}"
    echo -e "${grey}\t- ~/.steam${NC}"
    echo -e "${grey}\t- ~/Bricsys${NC}"
    echo -e "${grey}\t- ~/octave${NC}"
    echo -e "${grey}\t- ~/PlayOnLinux's virtual drives${NC}"
    echo -e "${grey}\t- ~/Programs${NC}"
    echo -e "${grey}\t- ~/Projects${NC}"
    echo -e "${grey}\t- ~/.local/share/Steam${NC}"
    echo -e
    echo -e -n "${BLUE}Proceed? ${GREEN}(y/n)? ${NC}"
    read answer
    echo -e
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        # Create Backups First
        if [ -d "/home/$USER/Documents" ] ;then   cmd "mv /home/$USER/Documents /home/$USER/Documents.bak";     fi
        if [ -d "/home/$USER/Documents" ] ;then   cmd "mv /home/$USER/Downloads /home/$USER/Downloads.bak";     fi
        if [ -d "/home/$USER/Music"     ] ;then   cmd "mv /home/$USER/Music /home/$USER/Music.bak";             fi
        if [ -d "/home/$USER/Pictures"  ] ;then   cmd "mv /home/$USER/Pictures /home/$USER/Pictures.bak";       fi
        if [ -d "/home/$USER/Templates" ] ;then   cmd "mv /home/$USER/Templates /home/$USER/Templates.bak";     fi
        if [ -d "/home/$USER/Videos"    ] ;then   cmd "mv /home/$USER/Videos /home/$USER/Videos.bak";           fi
        
        # Copy all symlinks
        cmd "sudo rsync -aR --info=progress2 ${BACKUP_DIR}/symlinks/ /"
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    upgrade:
    echo -e "${PURPLE}==========================================================================${NC}"
    echo -e "${PURPLE}\tPerform dist-upgrade and purge apport (will ask)${NC}"
    echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    #echo -e "${PURPLE}NOTES${NC}"
    #echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    echo -e -n "${BLUE}Proceed ${GREEN}(y/n/e)? ${NC}"; read answer; echo -e;
    cmd_string="sudo apt update && sudo apt -y dist-upgrade"
    if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command: ${NC})" -e -i "${cmd_string}" cmd_string; fi
    if [ "$answer" != "${answer#[YyEe]}" ] ;then
        cmd "$cmd_string"
        #cmd "sudo apt update"
        #cmd "sudo apt -y dist-upgrade"
        echo -e
        echo -e -n "${BLUE}Purge Apport ${GREEN}(y/n)? ${NC}"
        read answer
        echo -e
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo apt -y purge apport"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi


    packages:
    echo -e
    echo -e "${PURPLE}====================================================================================================${NC}"
    echo -e "${PURPLE}\tInstall Standard Packages${NC}"
    echo -e "${PURPLE}----------------------------------------------------------------------------------------------------${NC}"
    printf "${grey}arandr                      audacious                   audacity                    baobab${NC}\n"
    printf "${grey}blender                     brasero                     cecilia                     chromium-browser${NC}\n"
    printf "${grey}cifs-utils                  devede                      dia                         dosbox${NC}\n"
    printf "${grey}easytag                     exfat-utils                 text4magic                  fluidsynth${NC}\n"
    printf "${grey}fontforge                   freecad                     g++-8                       ghex${NC}\n"
    printf "${grey}gimp                        gimp-gmic                   gimp-plugin-registry        git${NC}\n"
    printf "${grey}git-lfs                     glade                       glmark2                     gmic${NC}\n"
    printf "${grey}gnome-disk-utility          gpick                       hardinfo                    inkscape${NC}\n"
    printf "${grey}inxi                        iptraf                      kdevelop                    kicad${NC}\n"
    printf "${grey}kicad-footprints            kicad-packages3d            kicad-symbols               kicad-templates${NC}\n"
    printf "${grey}kompare                     krita                       libssl-dev                  libuv1-dev${NC}\n"
    printf "${grey}libnode64                   libnode-dev                 libdvd-pkg                  libdvdnav4${NC}\n"
    printf "${grey}libdvdread7                 libnoise-dev                libsdl2-dev                 libsdl2-image-dev${NC}\n"
    printf "${grey}libsdl2-mixer-dev           libsdl2-net-dev             lmms                        mesa-utils${NC}\n"
    printf "${grey}neofetch                    net-tools                   network-manager-openconnect network-manager-openvpn${NC}\n"
    printf "${grey}network-manager-ssh         nfs-common                  nfs-kernel-server           nmap${NC}\n"
    printf "${grey}octave                      openconnect                 openjdk-8-jre               openshot${NC}\n"
    printf "${grey}openssh-server              openvpn                     pithos                      playonlinux${NC}\n"
    printf "${grey}python3-pip                 qt5-default                 qtcreator                   qtdeclarative5-dev${NC}\n"
    printf "${grey}rawtherapee                 remmina                     rename                      samba${NC}\n"
    printf "${grey}scummvm                     smb4k                       solaar                      texlive-fonts-extra${NC}\n"
    printf "${grey}texlive-fonts-recommended   texlive-xetex               texstudio                   tilix${NC}\n"
    printf "${grey}thunderbird                 ubuntu-restricted-extras    valgrind                    veusz${NC}\n"
    printf "${grey}vim                         vlc                         vlc-plugin-access-extra     vlc-plugin-fluidsynth${NC}\n"
    printf "${grey}vlc-plugin-samba            vlc-plugin-skins2           vlc-plugin-visualization    warzone2100${NC}\n"
    printf "${grey}whois                       winff                       wireshark                   xrdp${NC}\n"
    printf "${grey}xterm${NC}\n"
    echo -e "${grey}* Answer yes again to apt if it successfully prepares to install packeges.${NC}"
    echo -e "${grey}* Take caution, if apt has errors then abort the script with ctrl+c and resolve errors manually.${NC}"
    echo -e
    echo -e -n "${BLUE}Proceed ${GREEN}(y/n/e)? ${NC}"
    read answer
    echo -e
    cmd_string1="sudo apt install arandr audacious audacity baobab blender brasero cecilia chromium-browser cifs-utils devede dia dosbox easytag exfat-utils ext4magic fluidsynth fontforge freecad g++-8 ghex gimp gimp-gmic gimp-plugin-registry git git-lfs glade glmark2 gmic gnome-disk-utility gpick hardinfo inkscape inxi iptraf kdevelop kicad kicad-footprints kicad-packages3d kicad-symbols kicad-templates kompare krita libdvd-pkg libssl-dev libuv1-dev libnode64 libnode-dev libdvdnav4 libdvdread7 libnoise-dev libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-net-dev lmms mesa-utils neofetch net-tools network-manager-openconnect network-manager-openvpn network-manager-ssh nfs-common nfs-kernel-server nmap octave openconnect openjdk-8-jre openshot openssh-server openvpn pithos playonlinux python3-pip qt5-default qtcreator qtdeclarative5-dev rawtherapee remmina rename samba scummvm smb4k solaar texlive-fonts-extra texlive-fonts-recommended texlive-xetex texstudio tilix thunderbird ubuntu-restricted-extras valgrind veusz vim vlc vlc-plugin-access-extra vlc-plugin-fluidsynth vlc-plugin-samba vlc-plugin-skins2 vlc-plugin-visualization warzone2100 whois winff wireshark xrdp xterm zenity zenity-common"
    cmd_string2="sudo dpkg-reconfigure libdvd-pkg"
    if [ "$answer" != "${answer#[Ee]}" ] ;then
        read -p "$(echo -e ${yellow}Edit command 1/2: ${NC})" -e -i "${cmd_string1}" cmd_string1;
        read -p "$(echo -e ${yellow}Edit command 2/2: ${NC})" -e -i "${cmd_string1}" cmd_string2;
    fi
    if [ "$answer" != "${answer#[YyEe]}" ] ;then
        cmd "$cmd_string1"
        cmd "$cmd_string2"
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
   
   
    ppa:
    echo -e
    echo -e "${PURPLE}==========================================================================${NC}"
    echo -e "${PURPLE}\tInstall PPA Packages${NC}"
    echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    #echo -e "${PURPLE}NOTES${NC}"
    #echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tx-tile${NC}\n\n"
    echo -e -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        echo -e
        printf "${BLUE}Installing x-tile ${GREEN}(y/n/e)? ${NC}"; read answer; echo -e
        cmd_string="sudo apt-add-repository -y ppa:giuspen/ppa && sudo apt -y install x-tile"
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command: ${NC})" -e -i "${cmd_string}" cmd_string; fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi


    pip:
    echo -e
    echo -e "${PURPLE}==========================================================================${NC}"
    echo -e "${PURPLE}\tInstall PIP Packages${NC}"
    echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    #echo -e "${PURPLE}NOTES${NC}"
    #echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tbCNC${NC}\n\n"
    echo -e -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        echo -e
        printf "${BLUE}Installing bCNC ${GREEN}(y/n/e)? ${NC}"; read answer; echo -e
        cmd_string="pip3 install --no-input --upgrade bCNC"
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command: ${NC})" -e -i "${cmd_string}" cmd_string; fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi


    snap:
    echo -e
    echo -e "${PURPLE}==========================================================================${NC}"
    echo -e "${PURPLE}\tInstall Snap packages${NC}"
    echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    #echo -e "${PURPLE}NOTES${NC}"
    #echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tckan${NC}\n"
    printf "${grey}\tshotcut${NC}\n"
    printf "${grey}\tsublime-text${NC}\n"
    echo -e
    echo -e -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"; read answer; echo -e
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        echo -e
        printf "${BLUE}Installing ckan ${GREEN}(y/n/e)? ${NC}"; read answer; echo -e
        cmd_string="sudo snap install ckan"
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command: ${NC})" -e -i "${cmd_string}" cmd_string; fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string"
            cmd "sudo snap install ckan"
        fi
        
        echo -e
        printf "${BLUE}Installing shotcut ${GREEN}(y/n/e)? ${NC}"; read answer; echo -e
        cmd_string="sudo snap install --classic shotcut"
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command: ${NC})" -e -i "${cmd_string}" cmd_string; fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string"
            cmd "sudo snap install --classic shotcut"
        fi
        
        echo -e
        printf "${BLUE}Installing sublime-text ${GREEN}(y/n/e)? ${NC}"; read answer; echo -e
        cmd_string="sudo snap install --classic sublime-text"
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command: ${NC})" -e -i "${cmd_string}" cmd_string; fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string"
            cmd "sudo snap install --classic sublime-text"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    
    plasmoid:
    echo -e
    echo -e "${PURPLE}==========================================================================${NC}"
    echo -e "${PURPLE}\tInstall Plasmoids${NC}"
    echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    #echo -e "${PURPLE}NOTES${NC}"
    #echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\tplaces widget${NC}\n\n"
    echo -e -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"; read answer; echo -e
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        echo -e
        printf "${BLUE}Installing places widget ${GREEN}(y/n/e)? ${NC}"; read answer; echo -e
        cmd_string="plasmapkg2 -i ./Apps/places-widget-1.3.plasmoid"
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command: ${NC})" -e -i "${cmd_string}" cmd_string; fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string"
            #cmd "plasmapkg2 -i ./Apps/places-widget-1.3.plasmoid"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    

    downloads:
    echo -e
    echo -e "${PURPLE}==========================================================================${NC}"
    echo -e "${PURPLE}\tInstal Downloaded Apps${NC}"
    echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    #echo -e "${PURPLE}NOTES${NC}"
    #echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    printf "${grey}\t- virtualbox + extension pack${NC}\n"
    printf "${grey}\t- bricscad${NC}\n"
    printf "${grey}\t- camotics${NC}\n"
    printf "${grey}\t- chrome${NC}\n"
    printf "${grey}\t- nomachine${NC}\n"
    printf "${grey}\t- multisystem${NC}\n"
    printf "${grey}\t- eclipse${NC}\n"
    printf "${grey}\t- Brother HL3040CN${NC}\n"
    printf "${grey}\t- Plex Media Player${NC}\n"

    echo -e -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"
    read answer
    echo -e
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        echo -e
        printf "${BLUE}VirtualBox v6.1.10 (deb)${NC}"
        echo -e -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/virtualbox-6.1_6.1.10-138449_Ubuntu_eoan_amd64.deb"
            cmd "sudo VBoxManage extpack install --replace ./Apps/Oracle_VM_VirtualBox_Extension_Pack-6.1.10.vbox-extpack"
            cmd "sudo VBoxManage extpack cleanup"
        fi
        
        echo -e
        printf "${BLUE}BricsCAD v20.2.08 (deb)${NC}"
        echo -e -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/BricsCAD-V20.2.08-1-en_US-amd64.deb"
        fi
        
        echo -e
        printf "${BLUE}Camotics v1.2.0 (deb)${NC}"
        echo -e -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/camotics_1.2.0_amd64.deb"
        fi
        
        echo -e
        printf "${BLUE}Chrome v83.0.4103 (deb)${NC}"
        echo -e -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/google-chrome-stable_current_amd64.deb"
        fi
        
        echo -e
        printf "${BLUE}No Machine v6.11.2 (deb)${NC}"
        echo -e -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/nomachine_6.11.2_1_amd64.deb"
        fi
        
        echo -e
        printf "${BLUE}Steam v20 (deb)${NC}"
        echo -e -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/steam_latest.deb"
        fi
        
        echo -e
        printf "${BLUE}Mutisystem (sh)${NC}"
        echo -e -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo chmod +x ./Apps/install-depot-multisystem.sh"
            cmd "sudo ./Apps/install-depot-multisystem.sh"
        fi
        
        echo -e
        printf "${BLUE}Eclipse v2020-06 (bin)${NC}"
        echo -e -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo chmod +x ./Apps/eclipse-installer/eclipse-inst"
            cmd "./Apps/eclipse-installer/eclipse-inst"
        fi
        
        echo -e
        printf "${BLUE}Printer (HL-3040CN)${NC}\n"
        printf "${YELLOW}NOTE: The install script has been modified, it did not allow directories with spaces in them and the version included here does.${NC}\n"
        echo -e -n "${GREEN}Continue (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "cd ./Apps/brother/"
            cmd "sudo ./linux-brprinter-installer-2.2.2-1"
            cmd "cd '${working_dir}'"
        fi
        
        echo -e
        printf "${BLUE}Plex Media Player v2.58.0 (AppImage)${NC}"
        echo -e -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            install_dir="/home/$USER/Programs/PlexMP"
            echo -e
            printf "${BLUE}Where do you want to install to:${NC}\n"
            printf "${YELLOW}  1) ~/Programs/PlexMP/ (default)${NC}\n"
            printf "${YELLOW}  2) Other (user write permission assumed)${NC}\n"
            echo -e -n "${GREEN}Option? ${NC}"; read answer; if [ "$answer" != "${answer#[2]}" ] ;then
                printf "${BLUE}Directory: ${NC}"
                read install_dir
            fi
            echo -e
            printf "${YELLOW}Select YES when asked if you want to integrate, close after it has started.${NC}"
            echo -e
            cmd "mkdir -pv ${install_dir}"
            cmd "rsync -a ./Apps/Plex_Media_Player_2.58.0.1076-38e019da_x64.AppImage ${install_dir}/"
            cmd "${install_dir}/Plex_Media_Player_2.58.0.1076-38e019da_x64.AppImage"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    
    source:
    echo -e
    echo -e "${PURPLE}==========================================================================${NC}"
    echo -e "${PURPLE}\tInstall from Source${NC}"
    echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    #echo -e "${PURPLE}NOTES${NC}"
    #echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    echo -e
    echo -e "${BLUE}Do you want to install programs from source?${NC}"
    echo -e "${grey}\t- gzdoom${NC}"
    echo -e "${grey}\t- knossos${NC}"
    echo -e "${grey}\t- qucs${NC}"
    echo -e "${grey}\t- valkyrie${NC}"
    #echo -e "${grey}\t- plex media player${NC}"
    #echo -e "${grey}\t- flatcam${NC}"
    echo -e -n "${GREEN}Continue (y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        eval "./gzdoom.sh $FLAGS"
        eval "./knossos.sh $FLAGS"
        eval "./qucs.sh $FLAGS"
        eval "./valkyrie.sh $FLAGS"
        #eval "./plexmp.sh $FLAGS"
        #eval "./flatcam.sh $FLAGS"
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    
    config:
    echo -e
    echo -e "${PURPLE}==========================================================================${NC}"
    echo -e "${PURPLE}\tAdditional Configuration${NC}"
    echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    #echo -e "${PURPLE}NOTES${NC}"
    #echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    # ==================================================================
    #   Add user to vboxusers (should give USB permission)
    # ==================================================================
    echo -e -n "${BLUE}Add groups for virtualbox usb/tty access${NC}"
    echo -e "${grey}\t- vboxusers${NC}"
    echo -e "${grey}\t- dialout${NC}"
    echo -e -n "${GREEN}Continue (y/n)? ${NC}"
    read answer
    cmd_string1="sudo usermod -a -G vboxusers,dialout $USER"
    if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command 1: ${NC})" -e -i "${cmd_string1}" cmd_string1; fi
    if [ "$answer" != "${answer#[YyEe]}" ] ;then
        cmd "$cmd_string1"
    fi
    
    # ==================================================================
    #   Set Samba share password
    # ==================================================================
    echo -e
    echo -e -n "${BLUE}Set samba password ${GREEN}(y/n)? ${NC}"
    read answer
    cmd_string="sudo smbpasswd -a $USER"
    if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command: ${NC})" -e -i "${cmd_string}" cmd_string; fi
    if [ "$answer" != "${answer#[YyEe]}" ] ;then
        cmd "$cmd_string"
    fi
    
    # ==================================================================
    #   Ensure libGL.so exists
    # ==================================================================
    echo -e
    echo -e -n "${BLUE}Check for libGL.so links ${GREEN}(y/n)? ${NC}"
    read answer
    cmd_string1="sudo ln -s /usr/lib/i386-linux-gnu/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so"
    cmd_string2="sudo ln -s /usr/lib/x86_64-linux-gnu/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so"
    if [ "$answer" != "${answer#[Ee]}" ] ;then
        read -p "$(echo -e ${yellow}Edit command 1/2: ${NC})" -e -i "${cmd_string1}" cmd_string1;
        read -p "$(echo -e ${yellow}Edit command 2/2: ${NC})" -e -i "${cmd_string2}" cmd_string2;
    fi
    if [ "$answer" != "${answer#[YyEe]}" ] ;then
        cmd "$cmd_string1"
        cmd "$cmd_string2"
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    nfs:
    # ==================================================================
    #   Create User and Downloads NFS shares
    # ==================================================================
    echo -e
    echo -e "${BLUE}Create standard NFS shares:${NC}"
    echo -e "${grey}  /home/$USER (ro)${NC}"
    echo -e "${grey}  /home/$USER/Downloads (rw)${NC}"
    echo -e -n "${BLUE}Continue ${GREEN}(y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        printf "${BLUE}Creating NFS shares: ${NC}\n"
        
        iprange="192.168.0.0/16"
        echo -e
        echo -e -n "${YELLOW}Do you want to change the default ip range of '$iprange' ${GREEN}(y/n)? ${NC}"
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            echo -e -n "${YELLOW}Enter ip range: ${GREEN}"
            read iprange
            echo -e -n "${NC}"
        fi
        
        # Export directory
            echo -e
            printf "${YELLOW}Erase existing exports (this will erase entire contents of the exports file)${GREEN}(y/n)?${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
                cmd "sudo truncate -s 0 /etc/exports"
            fi
            cmd "echo -e '' | sudo tee -a /etc/exports"
            cmd "echo -e '# Exports added by fresh_install.sh' | sudo tee -a /etc/exports"
            cmd "echo -e '/home/$USER                ${iprange}(ro,sync,no_subtree_check,fsid=root)' | sudo tee -a /etc/exports"
            cmd "echo -e '/home/$USER/Downloads      ${iprange}(rw,no_root_squash,sync,no_subtree_check,crossmnt)' | sudo tee -a /etc/exports"

        # Restart NFS service
            cmd "sudo exportfs -arv"

        # Ensure firewall access if enabled
            cmd "sudo ufw allow from ${iprange} to any port nfs"
    fi

    # ==================================================================
    #   Mount User and Downloads shares
    # ==================================================================
    echo -e
    echo -e "${BLUE}Do you want to mount:${NC}"
    echo -e "${grey}  /home/<user>${NC}"
    echo -e "${grey}  /home/<user>/Downloads${NC}"
    echo -e -n "${BLUE}shares from another pc (you will need the IP and username) ${GREEN}(y/n)? ${NC}"
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
        
        echo -e
        printf "${BLUE}Make permanant ${GREEN}(y/n)?${NC}"
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            echo -e
            printf "${YELLOW}Erase existing mounts (this will look for existing mounts added with this script) ${GREEN}(y/n)?${NC}";
            read answer;
            if [ "$answer" != "${answer#[Yy]}" ] ;then
                cmd "sed -i 's/#FISTD_S.*#FISTD_E\n//gms' /etc/fstab"
            fi
            cmd "echo -e '' | sudo tee -a /etc/fstab"
            cmd "echo -e '#FISTD_S: Standard (do not modify)' | sudo tee -a /etc/fstab"
            cmd "echo -e '${remoteip}:/home/${remoteuser}           /nfs/${remoteip}/${remoteuser}   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo -e '${remoteip}:/home/${remoteuser}/Downloads /nfs/${remoteip}/Downloads       nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo -e '#FISTD_E' | sudo tee -a /etc/fstab"
        fi
    fi
    
    # ==================================================================
    #   Create NFS shares to media server
    # ==================================================================
    echo -e
    echo -e "${BLUE}Do you want to mount media server shares:${NC}"
    echo -e "${grey}\t- /mnt/Database${NC}"
    echo -e "${grey}\t- /home/<user>/Documents${NC}"
    echo -e "${grey}\t- /home/<user>/Projects${NC}"
    echo -e "${grey}\t- /home/<user>/Videos${NC}"
    echo -e "${grey}\t- /home/<user>/Music${NC}"
    echo -e "${grey}\t- /home/<user>/Pictures${NC}"
    echo -e -n "${GREEN}Continue (y/n)? ${NC}"
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
        
        echo -e
        printf "${BLUE}Make permanant ${GREEN}(y/n)?${NC}"
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            echo -e
            printf "${YELLOW}Erase existing mounts (this will look for existing mounts added with this script) ${GREEN}(y/n)?${NC}";
            read answer;
            if [ "$answer" != "${answer#[Yy]}" ] ;then
                cmd "sed -i 's/#FIDS_S.*#FIDS_E\n//gms' /etc/fstab"
            fi
            cmd "echo -e '' | sudo tee -a /etc/fstab"
            cmd "echo -e '#FIDS_S: Datasaerver (do not modify)' | sudo tee -a /etc/fstab"
            cmd "echo -e '${remoteip}:/mnt/Database                 /nfs/${remoteip}/Database  nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo -e '${remoteip}:/home/${remoteuser}/Documents /nfs/${remoteip}/Documents nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo -e '${remoteip}:/home/${remoteuser}/Projects  /nfs/${remoteip}/Projects  nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo -e '${remoteip}:/home/${remoteuser}/Videos    /nfs/${remoteip}/Videos    nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo -e '${remoteip}:/home/${remoteuser}/Music     /nfs/${remoteip}/Music     nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo -e '${remoteip}:/home/${remoteuser}/Pictures  /nfs/${remoteip}/Pictures  nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo tee -a /etc/fstab"
            cmd "echo -e '#FIDS_E' | sudo tee -a /etc/fstab"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    # ==================================================================
    #   Restore Backup
    # ==================================================================
    restore:
    eval "./restore.sh $FLAGS"
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    echo -e 
    echo -e "${PURPLE}==========================================================================${YELLOW}"
    echo -e "Downlaod only: None, unless DEB/script section failed"
    echo -e "         Todo:"
    echo -e "          - Install Chrome-Plasma Integration"
    echo -e "          - VirtualBox Extensions"
    echo -e "          - NVidia Drivers"
    echo -e "              - Generate xorg.conf"
    echo -e "              - Add Modelines"
    echo -e "${PURPLE}==========================================================================${NC}"
    
    # NOTE: This last condition is slightly different to prevent final 'else/fi' from complaining after doing a jumpto()
    if [ "$GOTOSTEP" = true ] || [ "$GOTOCONTINUE" = true ]; then exit; fi
else
    echo -e "${RED}Invalid option: ${mode}"
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
#gnome-disk-utility
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
# rm_if_link(){ [ ! -L "$1" ] || echo -e "rm -v \"$1\""; }
# cp_if_link(){ [ ! -L "$1" ] || echo -e "rsync -aR --info=progress2 \"$1\""; }


















