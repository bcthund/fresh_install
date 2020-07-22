#!/bin/bash

# TODO: Create source install script for VLC
# TODO: Add a --log=<file> flag for logging all output (Still want to show on screen though)
# TODO: Add ~/.config/vlc to backup/restore
# TODO: 
# TODO: 
# TODO: 


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

grey='\e[0m\e[90m'
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

# Save the working directory of the script
working_dir=$PWD

# trap ctrl-c and call ctrl_c()
ctrl_c() { echo -e; echo -e; exit 0; }
trap ctrl_c INT

# Setup command
DEBUG=false
VERBOSE=false
IN_TESTING=false
EXTRACT=true
GOTOSTEP=false
GOTOCONTINUE=false
BACKUP_DIR="Migration_$USER"
TMP_DIR=${BACKUP_DIR}
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
        EXTRACT=false
        FLAGS="$FLAGS-x "
        shift # Remove from processing
        ;;
        --in-testing)
        IN_TESTING=true
        FLAGS="$FLAGS--in-testing "
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
        echo -e "                        Restore: do not unzip, no tmp directory provided (some items wont work)"
        echo -e "  --in-testing          Enable use of in-testing features (nothing currently in testing)"
        echo -e "  --tmp=DIRECTORY       do not extract archive, use this tmp directory"
        echo -e "  --dir=DIRECTORY       specify the backup directory to override './Migration_$USER'"
        echo -e "  --archive=FILE        specify the backup archive to override './Migration_$USER.tar.gz'"
        echo -e "  --step=STEP           jump to an install step then exit when complete"
        echo -e "  --continue=STEP       jump to an install step and continue to remaining steps"
        echo -e
        echo -e "Available STEP Options:"
        echo -e "                        start          same as starting without a STEP option"
        echo -e "                        uncompress     extract the contents of a backup"
        echo -e "                        backup         perform a system backup"
        echo -e "                        download       download/update install scripts, apps, source installs. Always exits"
        echo -e "                        symlinks       install symlinks from a system backup"
        echo -e "                        nosnap         remove snap packages from system (in testing)"
        echo -e "                        upgrade        perform a system upgrade, and purge apport if desired"
        echo -e "                        nvidia         install latest nvidia driver (440) (in testing)"
        echo -e "                        packages       install apt packages including some dependencies for other steps"
        echo -e "                        ppa_package    install packages requiring additional PPAs"
        echo -e "                        pip            install pip3 packages"
        echo -e "                        snap           install snap packages"
        echo -e "                        plasmoid       install plasma plasmoids"
        echo -e "                        downloads      install downloaded applications"
        echo -e "                        source         install applications from source"
        echo -e "                        config         perform some additional configuration, not including NFS shares"
        echo -e "                        nfs            setup some standard NFS shares and/or attach media server shares"
        echo -e "                        restore        perform a system restore from a previous backup"
        echo -e "                        cleanup        runs apt autoremove for lingering packages"
        echo -e "${NC}"
        exit
        shift # Remove from processing
        ;;
        --tmp=*)
        EXTRACT=false
        TMP_DIR="$(echo ${arg#*=} | sed 's:/*$::')"
        FLAGS="$FLAGS--tmp=${TMP_DIR} "
        shift # Remove from processing
        ;;
        --dir=*)
        BACKUP_DIR="$(echo ${arg#*=} | sed 's:/*$::')"          # Strip trailing /
        BACKUP_DIR="$(echo ${BACKUP_DIR} | sed 's|^\./||')"     # Strip preceeding ./
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

if [ "$DEBUG" = true ]; then
    echo -e "PREDEFINED COLORS:"
    echo -e
    echo -e   "${grey}grey     ${GREY}GREY${NC}"
    echo -e    "${red}red      ${RED}RED${NC}"
    echo -e  "${green}green    ${GREEN}GREEN${NC}"
    echo -e "${yellow}yellow   ${YELLOW}YELLOW${NC}"
    echo -e "${purple}purple   ${PURPLE}PURPLE${NC}"
    echo -e  "${white}white    ${WHITE}WHITE${NC}"
    echo -e   "${blue}blue     ${BLUE}BLUE${NC}"
    echo -e   "${cyan}cyan     ${CYAN}CYAN${NC}"
    echo -e     "${NC}NC${NC}"
fi

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
echo -e "${INTRO}You may see up to 5 choices:                                           ${NC}"
echo -e "${INTRO}  y   yes, perform the action                                          ${NC}"
echo -e "${INTRO}  n   no, do not perform the action                                    ${NC}"
echo -e "${INTRO}  a   all, perform all steps in this section                           ${NC}"
echo -e "${INTRO}  e   edit, edit the command(s) and proceed                            ${NC}"
echo -e "${INTRO}  b   beta, install beta software option (possibly unstable/buggy)     ${NC}"
echo -e "${INTRO}                                                                       ${NC}"
#echo -e "${grey}${NC}"
echo -e
echo -e "${YELLOW}Using backup directory: '${BACKUP_DIR}'${NC}"
if [ "$EXTRACT" = false ]; then echo -e "${YELLOW}        Temp directory: '${TMP_DIR}'${NC}"; fi
echo -e "${YELLOW}         Using archive: '${ARCHIVE_FILE}'${NC}"
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
    if [ "$EXTRACT" = true ]; then
        echo -e -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"; read answer; echo -e;
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command: ${NC})" -e -i "${cmd_string}" cmd_string; fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
    
            if ! command -v pigz &> /dev/null; then cmd "sudo apt install pigz"; fi
            if ! command -v pv &> /dev/null; then cmd "sudo apt install pv"; fi    
            TMP_DIR=$(mktemp -d -t $BACKUP_DIR-XXXXXX)
            ctrl_c() {
                echo -e;
                echo -e -n "${BLUE}Do you want to remove temporary files in '${TMP_DIR}' ${GREEN}(y/n)? ${NC}"; read -e -i "y" answer; echo;
                if [ "$answer" != "${answer#[Yy]}" ] ;then
                    eval "sudo rm -rf ${TMP_DIR}";
                fi
                echo -e;
                echo -e;
                exit 0;
            }
            echo -e "${YELLOW}Temp directory: '${TMP_DIR}'${NC}"
            cmd_string1="pv ${ARCHIVE_FILE} | sudo tar --same-owner -I pigz -x -C '${TMP_DIR}'"
            cmd "$cmd_string1"
        fi
    else
        echo -e "${RED}Temp directory: '${TMP_DIR}'${NC}"
        echo -e "${RED}If the Temp directory has not been set with --tmp then Restore${NC}"
        echo -e "${RED}will not work, and symlinks won't be restored.${NC}"
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
        cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/symlinks/home/$USER/ /home/$USER/"
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    # TODO: Snaps causing issues, get rid of them. Will need to double check apt install list for dependency issues
    nosnap:
    #if [ "$IN_TESTING" = true ]; then
        echo -e "${PURPLE}==========================================================================${NC}"
        echo -e "${PURPLE}\tRemove Snap and block${NC}"
        echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
        #echo -e "${PURPLE}NOTES${NC}"
        #echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
        echo -e -n "${BLUE}Proceed ${GREEN}(y/n/e)? ${NC}"; read answer; echo -e;
        cmd_string1="sudo apt purge snapd"
        cmd_string2="sudo rm -vrf /home/$USER/snap"
        cmd_string3="sudo systemctl stop snapd"
        cmd_string4="sudo rm -vrf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd"
        cmd_string5="sudo apt-mark hold snapd"
        if [ "$answer" != "${answer#[Ee]}" ] ;then
            printf "${grey}  Command 1: ${cmd_string1}${NC}\n"
            printf "${grey}  Command 2: ${cmd_string2}${NC}\n"
            printf "${grey}  Command 3: ${cmd_string3}${NC}\n"
            printf "${grey}  Command 4: ${cmd_string4}${NC}\n"
            printf "${grey}  Command 5: ${cmd_string5}${NC}\n"
            echo
            read -p "$(echo -e ${yellow}Edit command 1/5: ${NC})" -e -i "${cmd_string1}" cmd_string1;
            read -p "$(echo -e ${yellow}Edit command 2/5: ${NC})" -e -i "${cmd_string2}" cmd_string2;
            read -p "$(echo -e ${yellow}Edit command 3/5: ${NC})" -e -i "${cmd_string3}" cmd_string3;
            read -p "$(echo -e ${yellow}Edit command 4/5: ${NC})" -e -i "${cmd_string4}" cmd_string4;
            read -p "$(echo -e ${yellow}Edit command 5/5: ${NC})" -e -i "${cmd_string5}" cmd_string5;
        fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string1"
            cmd "$cmd_string2"
            cmd "$cmd_string3"
            cmd "$cmd_string4"
            cmd "$cmd_string5"
        fi
    #fi
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

    
    nvidia:
    #if [ "$IN_TESTING" = true ]; then
        echo -e
        echo -e "${PURPLE}==========================================================================${NC}"
        echo -e "${PURPLE}\tInstall NVIDIA in-testing drivers${NC}"
        echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
        echo -e "${purple}This will install the latest drivers that are still in testing${NC}"
        echo -e "${purple}for nvidia graphics cards. This will purge any current nvidia${NC}"
        echo -e "${purple}files and install ${NC}"
        echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
        cmd_string1="printf '%s\n' y | sudo apt-get remove --purge nvidia-* && sudo apt autoremove"
        cmd_string2="sudo add-apt-repository -y ppa:graphics-drivers/ppa"
        cmd_string3="printf '%s\n' y | sudo apt install nvidia-driver-440"
        printf "${BLUE}Install nvidia-440 drivers ${GREEN}(y/n/e)? ${NC}"; read answer; echo -e
        if [ "$answer" != "${answer#[Ee]}" ] ;then
            printf "${grey}  Command 1: ${cmd_string1}${NC}\n"
            printf "${grey}  Command 2: ${cmd_string2}${NC}\n"
            printf "${grey}  Command 3: ${cmd_string3}${NC}\n"
            echo
            read -p "$(echo -e ${yellow}Edit command 1/3: ${NC})" -e -i "${cmd_string1}" cmd_string1;
            read -p "$(echo -e ${yellow}Edit command 2/3: ${NC})" -e -i "${cmd_string2}" cmd_string2;
            read -p "$(echo -e ${yellow}Edit command 3/3: ${NC})" -e -i "${cmd_string3}" cmd_string3;
        fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string1"
            cmd "$cmd_string2"
            cmd "$cmd_string3"
        fi
    #fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    

    packages:
    PACKAGE_LIST=(  "arandr"
                    "audacious"
                    "audacity"
                    "baobab"
                    "blender"
                    "brasero"
                    "cecilia"
                    #"chromium-browser"
                    "cifs-utils"
                    "devede"
                    "dia"
                    "dosbox"
                    "easytag"
                    "exfat-utils"
                    "ext4magic"
                    "fluidsynth"
                    "fontforge"
                    "freecad"
                    "g++-8"
                    "ghex"
                    "gimp"
                    "gimp-gmic"
                    "gimp-plugin-registry"
                    "git"
                    "git-lfs"
                    "glade"
                    "glmark2"
                    "gmic"
                    "gnome-disk-utility"
                    "gpick"
                    "hardinfo"
                    "inkscape"
                    "inxi"
                    "iptraf"
                    "kdevelop"
                    "kicad"
                    "kicad-footprints"
                    "kicad-packages3d"
                    "kicad-symbols"
                    "kicad-templates"
                    "kompare"
                    "krita"
                    "libssl-dev"
                    "libuv1-dev"
                    "libnode64"
                    "libnode-dev"
                    "libdvd-pkg"
                    "libdvdnav4"
                    "libdvdread7"
                    "libimage-exiftool-perl"
                    "libnoise-dev"
                    "libsdl2-dev"
                    "libsdl2-image-dev"
                    "libsdl2-mixer-dev"
                    "libsdl2-net-dev"
                    "lmms"
                    "mesa-utils"
                    "neofetch"
                    "net-tools"
                    "network-manager-openconnect"
                    "network-manager-openvpn"
                    "network-manager-ssh"
                    "nfs-common"
                    "nfs-kernel-server"
                    "nmap"
                    "numlockx"
                    "octave"
                    "openconnect"
                    "openjdk-8-jre"
                    "openshot"
                    "openssh-server"
                    "openvpn"
                    "pithos"
                    "playerctl"
                    "playonlinux"
                    "python"
                    "python3-pip"
                    "qt5-default"
                    "qtcreator"
                    "qtdeclarative5-dev"
                    "rawtherapee"
                    "remmina"
                    "rename"
                    "samba"
                    "scummvm"
                    "smb4k"
                    "solaar"
                    "texlive-fonts-extra"
                    "texlive-fonts-recommended"
                    "texlive-font-utils"
                    "texlive-xetex"
                    "texstudio"
                    "tilix"
                    "thunderbird"
                    "ubuntu-restricted-extras"
                    "valgrind"
                    "veusz"
                    "vim"
                    "vlc"
                    "vlc-plugin-access-extra"
                    "vlc-plugin-fluidsynth"
                    "vlc-plugin-samba"
                    "vlc-plugin-skins2"
                    "vlc-plugin-visualization"
                    "warzone2100"
                    "whois"
                    "wine"
                    "wine32"
                    "wine64"
                    #"libwine"
                    #"libwine:i386"
                    "fonts-wine"
                    "winetricks"
                    "winff"
                    "wireshark"
                    "xrdp"
                    "xterm"
                    "youtube-dl"
                    "zenity"
                    "zenity-common")
    echo -e
    echo -e "${PURPLE}====================================================================================================${NC}"
    echo -e "${PURPLE}\tInstall Standard Packages${NC}"
    echo -e "${PURPLE}----------------------------------------------------------------------------------------------------${NC}"
    
    count=0
    printf "  ";
    cmd_string4="sudo DEBIAN_FRONTEND=noninteractive apt install"
    for package in ${PACKAGE_LIST[@]}; do
        cmd_string4+=" ${package}"
        while [ "${#package}" -lt 30 ]; do
            package="$package "
        done
         package="${grey}${package}${NC}"
         printf "$package"
         count=$((count+1))
         if [ $count -gt 4 ]; then
             printf "\n  ";
             count=0
         fi
    done
    echo -e
    echo -e
    echo -e "${yellow}* Answer yes again to apt if it successfully prepares to install packeges.${NC}"
    echo -e "${yellow}* Take caution, if apt has errors then abort the script with ctrl+c and resolve errors manually.${NC}"
    echo -e
    echo -e -n "${BLUE}Proceed ${GREEN}(y/n/e)? ${NC}"
    read answer
    echo -e
    
    # Packages that complain if not installed separately (still listed in full package list)
    cmd_string1="sudo dpkg --configure -a"
    cmd_string2="sudo dpkg --add-architecture i386"
    cmd_string3="sudo apt -y install wine wine32 wine64 fonts-wine winetricks"
    cmd_string5="sudo DEBIAN_FRONTEND=noninteractive apt -f install"
    cmd_string6="sudo dpkg-reconfigure libdvd-pkg"
    if [ "$answer" != "${answer#[Ee]}" ] ;then
        printf "${grey}  Command 1: ${cmd_string1}${NC}\n"
        printf "${grey}  Command 2: ${cmd_string2}${NC}\n"
        printf "${grey}  Command 3: ${cmd_string3}${NC}\n"
        printf "${grey}  Command 4: ${cmd_string4}${NC}\n"
        printf "${grey}  Command 5: ${cmd_string5}${NC}\n"
        printf "${grey}  Command 6: ${cmd_string6}${NC}\n"
        echo
        read -p "$(echo -e ${yellow}Edit command 1/6: ${NC})" -e -i "${cmd_string1}" cmd_string1;
        read -p "$(echo -e ${yellow}Edit command 2/6: ${NC})" -e -i "${cmd_string2}" cmd_string2;
        read -p "$(echo -e ${yellow}Edit command 3/6: ${NC})" -e -i "${cmd_string3}" cmd_string3;
        read -p "$(echo -e ${yellow}Edit command 4/6: ${NC})" -e -i "${cmd_string4}" cmd_string4;
        read -p "$(echo -e ${yellow}Edit command 5/6: ${NC})" -e -i "${cmd_string5}" cmd_string5;
        read -p "$(echo -e ${yellow}Edit command 6/6: ${NC})" -e -i "${cmd_string6}" cmd_string6;
    fi
    if [ "$answer" != "${answer#[YyEe]}" ] ;then
        cmd "$cmd_string1"
        cmd "$cmd_string2"
        cmd "$cmd_string3"
        cmd "printf '%s\n' y | $cmd_string4"
        cmd "$cmd_string5"
        cmd "$cmd_string6"
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
   
   
    ppa_package:
    echo -e
    echo -e "${PURPLE}==========================================================================${NC}"
    echo -e "${PURPLE}\tInstall PPA Packages${NC}"
    echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    #echo -e "${PURPLE}NOTES${NC}"
    #echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    #printf "${grey}  x-tile${NC}\n\n"
    printf "${grey}  chromium-browser${NC}\n"
    echo -e -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
#         echo -e
#         printf "${BLUE}Installing x-tile ${GREEN}(y/n/e)? ${NC}"; read answer; echo -e
#         cmd_string1="sudo apt-add-repository -y ppa:giuspen/ppa"
#         cmd_string2="sudo apt -y install x-tile"
#         if [ "$answer" != "${answer#[Ee]}" ] ;then
#             printf "${grey}  Command 1: ${cmd_string1}${NC}\n"
#             printf "${grey}  Command 2: ${cmd_string2}${NC}\n"
#             echo -e        
#             read -p "$(echo -e ${yellow}Edit command 1/2: ${NC})" -e -i "${cmd_string1}" cmd_string1;
#             read -p "$(echo -e ${yellow}Edit command 2/2: ${NC})" -e -i "${cmd_string2}" cmd_string2;
#         fi
#         if [ "$answer" != "${answer#[YyEe]}" ] ;then
#             cmd "$cmd_string1"
#             cmd "$cmd_string2"
#         fi
        
        echo -e
        printf "${BLUE}Installing chromium-browser ${GREEN}(y/n/e)? ${NC}"; read answer; echo -e
        #if [ "$answer" != "${answer#[Bb]}" ] ;then
        #    cmd_string1="sudo add-apt-repository -y ppa:chromium-team/beta"
        #else
        #    cmd_string1="sudo add-apt-repository -y ppa:chromium-team/stable"
        #fi
        cmd_string1="sudo touch /etc/apt/preferences.d/saiarcot895-chromium-beta.pref"
        cmd_string2="echo -e 'Package: *' | sudo tee -a /etc/apt/preferences.d/saiarcot895-chromium-beta.pref"
        cmd_string3="echo -e 'Pin: release o=LP-PPA-saiarcot895-chromium-beta' | sudo tee -a /etc/apt/preferences.d/saiarcot895-chromium-beta.pref"
        cmd_string4="echo -e 'Pin-Priority: 800' | sudo tee -a /etc/apt/preferences.d/saiarcot895-chromium-beta.pref"
        cmd_string5="printf '%s\n' \n | sudo add-apt-repository ppa:saiarcot895/chromium-beta"
        cmd_string6="sudo apt -y install chromium-browser"
        if [ "$answer" != "${answer#[Ee]}" ] ;then
            printf "${grey}  Command 1: ${cmd_string1}${NC}\n"
            printf "${grey}  Command 2: ${cmd_string2}${NC}\n"
            printf "${grey}  Command 3: ${cmd_string3}${NC}\n"
            printf "${grey}  Command 4: ${cmd_string4}${NC}\n"
            printf "${grey}  Command 5: ${cmd_string5}${NC}\n"
            printf "${grey}  Command 6: ${cmd_string6}${NC}\n"
            echo -e        
            read -p "$(echo -e ${yellow}Edit command 1/6: ${NC})" -e -i "${cmd_string1}" cmd_string1;
            read -p "$(echo -e ${yellow}Edit command 2/6: ${NC})" -e -i "${cmd_string2}" cmd_string2;
            read -p "$(echo -e ${yellow}Edit command 3/6: ${NC})" -e -i "${cmd_string3}" cmd_string3;
            read -p "$(echo -e ${yellow}Edit command 4/6: ${NC})" -e -i "${cmd_string4}" cmd_string4;
            read -p "$(echo -e ${yellow}Edit command 5/6: ${NC})" -e -i "${cmd_string5}" cmd_string5;
            read -p "$(echo -e ${yellow}Edit command 6/6: ${NC})" -e -i "${cmd_string6}" cmd_string6;
        fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            cmd "$cmd_string1"
            cmd "$cmd_string2"
            cmd "$cmd_string3"
            cmd "$cmd_string4"
            cmd "$cmd_string5"
            cmd "$cmd_string6"
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


    # TODO: Snaps causing issues, get rid of them. See nosnap section above.
    snap:
#     echo -e
#     echo -e "${PURPLE}==========================================================================${NC}"
#     echo -e "${PURPLE}\tInstall Snap packages${NC}"
#     echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    #echo -e "${PURPLE}NOTES${NC}"
    #echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
#     printf "${grey}\tckan${NC}\n"
#     printf "${grey}\tshotcut${NC}\n"
#     printf "${grey}\tsublime-text${NC}\n"
#     echo -e
#     echo -e -n "${BLUE}Proceed ${GREEN}(y/n)? ${NC}"; read answer; echo -e
#     if [ "$answer" != "${answer#[Yy]}" ] ;then
#         echo -e
#         printf "${BLUE}Installing ckan ${GREEN}(y/n/e)? ${NC}"; read answer; echo -e
#         cmd_string="sudo snap install ckan"
#         if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command: ${NC})" -e -i "${cmd_string}" cmd_string; fi
#         if [ "$answer" != "${answer#[YyEe]}" ] ;then
#             cmd "$cmd_string"
#         fi
        
#         echo -e
#         printf "${BLUE}Installing shotcut ${GREEN}(y/n/e)? ${NC}"; read answer; echo -e
#         cmd_string="sudo snap install --classic shotcut"
#         if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command: ${NC})" -e -i "${cmd_string}" cmd_string; fi
#         if [ "$answer" != "${answer#[YyEe]}" ] ;then
#             cmd "$cmd_string"
#         fi
        
#         echo -e
#         printf "${BLUE}Installing sublime-text ${GREEN}(y/n/e)? ${NC}"; read answer; echo -e
#         cmd_string="sudo snap install --classic sublime-text"
#         if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command: ${NC})" -e -i "${cmd_string}" cmd_string; fi
#         if [ "$answer" != "${answer#[YyEe]}" ] ;then
#             cmd "$cmd_string"
#         fi
#     fi
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

    echo -e -n "${BLUE}Proceed ${GREEN}(y/n/a)? ${NC}"
    read answer
    echo -e
    if [ "$answer" != "${answer#[YyAa]}" ] ;then
        if [ "$answer" != "${answer#[Aa]}" ] ;then answer2="y"; else answer2=""; fi
    
        echo -e
        printf "${BLUE}VirtualBox v6.1.10 (deb)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/virtualbox-6.1_6.1.10-138449_Ubuntu_eoan_amd64.deb"
            cmd "printf '%s\n' y | sudo VBoxManage extpack install --replace ./Apps/Oracle_VM_VirtualBox_Extension_Pack-6.1.10.vbox-extpack"
            cmd "sudo VBoxManage extpack cleanup"
        fi
        
        echo -e
        printf "${BLUE}BricsCAD v20.2.08 (deb)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/BricsCAD-V20.2.08-1-en_US-amd64.deb"
        fi
        
        echo -e
        printf "${BLUE}Camotics v1.2.0 (deb)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/camotics_1.2.0_amd64.deb"
        fi
        
        echo -e
        printf "${BLUE}Chrome v83.0.4103 (deb)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/google-chrome-stable_current_amd64.deb"
        fi
        
        echo -e
        printf "${BLUE}No Machine v6.11.2 (deb)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/nomachine_6.11.2_1_amd64.deb"
        fi
        
        echo -e
        printf "${BLUE}Steam v20 (deb)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo dpkg -iG ./Apps/steam_latest.deb"
        fi
        
        echo -e
        printf "${BLUE}Mutisystem (sh)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo apt install -y python python-is-python2 libsdl-ttf2.0-0 qemu qemu-kvm wmctrl xdotool fatresize gvfs-bin aptitude gtkdialog virtualbox-6.1"
            cmd "sudo apt install -f"
            cmd "sudo chmod +x ./Apps/install-depot-multisystem.sh"
            cmd "sudo ./Apps/install-depot-multisystem.sh"
        fi
        
        echo -e
        printf "${BLUE}Eclipse v2020-06 (bin)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo chmod +x ./Apps/eclipse-installer/eclipse-inst"
            cmd "./Apps/eclipse-installer/eclipse-inst"
        fi
        
        echo -e
        printf "${BLUE}Printer (HL-3040CN)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo mkdir -p /var/spool/lpd/hl3040cn"
            cmd "cd ./Apps/brother/"
            cmd "printf '%s\n' hl3040cn y y a n \n | sudo ./linux-brprinter-installer-2.2.2-1"
            cmd "cd '${working_dir}'"
        fi
        
        echo -e
        printf "${BLUE}Plex Media Player v2.58.0 (AppImage)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            install_dir="/home/$USER/Programs/PlexMP"
            echo -e
            printf "${BLUE}Where do you want to install to:${NC}\n"
            printf "${YELLOW}  0) ~/Programs/PlexMP/ (default)${NC}\n"
            printf "${YELLOW}  1) Other (user write permission assumed)${NC}\n"
            
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${GREEN}Option? ${NC} "; read answer2; else echo; fi
            if [ "$answer2" != "${answer2#[Yy1]}" ] ;then
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
    printf "${grey}  Force numlock on${NC}\n"
    printf "${grey}  Configure wine${NC}\n"
    printf "${grey}  Configure XRDP (not implemented, using nomachine)${NC}\n"
    printf "${grey}  Configure VirtualBox${NC}\n"
    printf "${grey}  Configure Wireshark${NC}\n"
    printf "${grey}  Set Samba password${NC}\n"
    printf "${grey}  Check for missing libGL.so links${NC}\n"
    printf "${grey}  Create and mount common NFS shares${NC}\n"
    echo -e -n "${BLUE}Proceed ${GREEN}(y/n/a)? ${NC}"; read answer; echo -e
    if [ "$answer" != "${answer#[YyAa]}" ] ;then
        if [ "$answer" != "${answer#[Aa]}" ] ;then answer2="y"; else answer2=""; fi
    
        echo -e
        echo -e "${BLUE}Force numlock on at startup${NC}"
        cmd_string1="sudo touch /etc/rc.local"
        cmd_string2="sudo sed -i 's|^exit 0.*$|# Numlock enable\n[ -x /usr/bin/numlockx ] \&\& numlockx on\n\nexit 0|' /etc/rc.local"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n/e)? ${NC} "; read answer2; else echo; fi
        if [ "$answer" != "${answer#[Ee]}" ] ;then
            printf "${grey}  Command 1: ${cmd_string1}${NC}\n"
            printf "${grey}  Command 2: ${cmd_string2}${NC}\n"
            echo
            read -p "$(echo -e ${yellow}Edit command 1/2: ${NC})" -e -i "${cmd_string1}" cmd_string1;
            read -p "$(echo -e ${yellow}Edit command 2/2: ${NC})" -e -i "${cmd_string2}" cmd_string2;
        fi
        if [ "$answer2" != "${answer2#[YyEe]}" ] ;then
            cmd "$cmd_string1"
        fi

        cmd_string1="winecfg"
        cmd_string2="winetricks corefonts"
        echo -e "${BLUE}Configure Wine${NC}"
        echo -e "${grey}  - Executes: ${cmd_String1} to create preliminary config, user must exit${NC}"
        echo -e "${grey}  - Executes: ${cmd_String2}${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n/e)? ${NC} "; read answer2; else echo; fi
        if [ "$answer" != "${answer#[Ee]}" ]; then
            printf "${grey}  Command 1: ${cmd_string1}${NC}\n"
            printf "${grey}  Command 2: ${cmd_string2}${NC}\n"
            echo
            read -p "$(echo -e ${yellow}Edit command 1/2: ${NC})" -e -i "${cmd_string1}" cmd_string1;
            read -p "$(echo -e ${yellow}Edit command 2/2: ${NC})" -e -i "${cmd_string2}" cmd_string2;
        fi
        if [ "$answer2" != "${answer2#[YyEe]}" ] ;then
            cmd "$cmd_string1"
        fi
        
        # Not really necessary with nomachine and a little buggy anyways but here for possible future
        #echo -e "${BLUE}Configure XRDP${NC}"
        #echo -e -n "${GREEN} (y/n)? ${NC}"
        #read answer
        #cmd_string1="???"
        #cmd_string1="???"
        #if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command 1: ${NC})" -e -i "${cmd_string1}" cmd_string1; fi
        #if [ "$answer2" != "${answer2#[YyEe]}" ] ;then
        #    cmd "$cmd_string1"
        #fi
        
        echo -e "${BLUE}Add groups for virtualbox usb/tty access${NC}"
        echo -e "${grey}\t- vboxusers${NC}"
        echo -e "${grey}\t- dialout${NC}"
        cmd_string1="sudo usermod -a -G vboxusers,dialout $USER"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n/e)? ${NC} "; read answer2; else echo; fi
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command 1: ${NC})" -e -i "${cmd_string1}" cmd_string1; fi
        if [ "$answer2" != "${answer2#[YyEe]}" ] ;then
            cmd "$cmd_string1"
        fi
        
        echo -e "${BLUE}Add user to wireshark group${NC}"
        cmd_string1="sudo usermod -a -G wireshark $USER"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n/e)? ${NC} "; read answer2; else echo; fi
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command 1: ${NC})" -e -i "${cmd_string1}" cmd_string1; fi
        if [ "$answer2" != "${answer2#[YyEe]}" ] ;then
            cmd "$cmd_string1"
        fi
        
        echo -e
        echo -e "${BLUE}Set samba password${NC}"
        cmd_string="sudo smbpasswd -a $USER"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n/e)? ${NC} "; read answer2; else echo; fi
        if [ "$answer" != "${answer#[Ee]}" ] ;then read -p "$(echo -e ${yellow}Edit command: ${NC})" -e -i "${cmd_string}" cmd_string; fi
        if [ "$answer2" != "${answer2#[YyEe]}" ] ;then
            echo -e
            cmd "$cmd_string"
        fi
        
        echo -e
        echo -e -n "${BLUE}Check for libGL.so links${NC}"
        cmd_string1="sudo ln -s /usr/lib/i386-linux-gnu/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so"
        cmd_string2="sudo ln -s /usr/lib/x86_64-linux-gnu/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n/e)? ${NC} "; read answer2; else echo; fi
        if [ "$answer" != "${answer#[Ee]}" ] ;then
            printf "${grey}  Command 1: ${cmd_string1}${NC}\n"
            printf "${grey}  Command 2: ${cmd_string2}${NC}\n"
            echo
            read -p "$(echo -e ${yellow}Edit command 1/2: ${NC})" -e -i "${cmd_string1}" cmd_string1;
            read -p "$(echo -e ${yellow}Edit command 2/2: ${NC})" -e -i "${cmd_string2}" cmd_string2;
        fi
        if [ "$answer2" != "${answer2#[YyEe]}" ] ;then
            if [ ! -f "/usr/lib/i386-linux-gnu/libGL.so" ]; then cmd "$cmd_string1"; fi
            if [ ! -f "/usr/lib/x86_64-linux-gnu/libGL.so" ]; then cmd "$cmd_string2"; fi
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
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            printf "${BLUE}Creating NFS shares: ${NC}\n"
            
            iprange="192.168.0.0/16"
            echo -e
            echo -e -n "${YELLOW}Use the default ip range of '$iprange'${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
            if [ "$answer2" != "${answer2#[Nn]}" ] ;then
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
        echo -e -n "${BLUE}shares from another pc (you will need the IP and username)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            echo -e
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
            printf "${BLUE}Make permanant${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                echo -e
                printf "${YELLOW}Erase existing mounts (this will look for existing mounts added with this script)${NC}";
                if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
                if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                    echo -e
                    #cmd "sed -i 's/#FISTD_S.*#FISTD_E\n//gms' /etc/fstab"
                    cmd "sudo perl -i -p0e 's/#FISTD_S.*#FISTD_E\n//gms' /etc/fstab"
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
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf "${GREEN}Continue (y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            echo -e
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
            printf "${BLUE}Make permanant${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                echo -e
                printf "${YELLOW}Erase existing mounts (this will look for existing mounts added with this script)${NC}";
                if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
                if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                    echo -e
                    #cmd "sed -i 's/#FIDS_S.*#FIDS_E\n//gms' /etc/fstab"
                    cmd "sudo perl -i -p0e 's/#FIDS_S.*#FIDS_E\n//gms' /etc/fstab"
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
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    # ==================================================================
    #   Restore Backup
    # ==================================================================
    restore:
    eval "./restore.sh $FLAGS --tmp='$TMP_DIR'"
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    cleanup:
    echo -e
    echo -e "${PURPLE}==========================================================================${NC}"
    echo -e "${PURPLE}\tCleanup${NC}"
    echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    #echo -e "${PURPLE}NOTES${NC}"
    #echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
    echo -e "${grey}  apt autoremove${NC}"
    echo -e "${grey}  remove '${TMP_DIR}'${NC}"
    
    cmd_string1="sudo apt autoremove"
    cmd_string2="rm -rf ${TMP_DIR}"
    echo -e
    printf "${BLUE}${cmd_string1}${GREEN} (y/n/e)? ${NC}"; read answer;
    if [ "$answer" != "${answer#[Ee]}" ] ;then
        read -p "$(echo -e ${yellow}Edit command 1/2: ${NC})" -e -i "${cmd_string1}" cmd_string1;
        read -p "$(echo -e ${yellow}Edit command 2/2: ${NC})" -e -i "${cmd_string2}" cmd_string2;
    fi
    if [ "$answer" != "${answer#[YyEe]}" ] ;then
        echo -e
        cmd "$cmd_string1"
        cmd "$cmd_string2"
    fi
    
    echo -e 
    echo -e "${PURPLE}==========================================================================${YELLOW}"
    echo -e "TODO:"
    echo -e "  - Install Chrome-Plasma Integration"
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


















