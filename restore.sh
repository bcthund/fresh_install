#!/bin/bash
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

# trap ctrl-c and call ctrl_c()
ctrl_c() { echo -e; echo -e; exit 0; }
trap ctrl_c INT

# Setup command
DEBUG=false
VERBOSE=false
ANSWERALL=false
EXTRACT=true
IN_TESTING=false
BACKUP_DIR="Migration_$USER"
TMP_DIR=${BACKUP_DIR}
ARCHIVE_FILE="${BACKUP_DIR}.tar.gz"
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
        -y|--yes)
        ANSWERALL=true
        answer="a";
        answer2="y";
        FLAGS="$FLAGS-y "
        shift # Remove from processing
        ;;
        --in-testing)
        IN_TESTING=true
        FLAGS="$FLAGS--in-testing "
        shift # Remove from processing
        ;;
        -h|--help)
        echo -e "${WHITE}"
        echo -e "Usage: $0.sh <options>"
        echo -e
        echo -e "Options:"
        echo -e "  -h, --help            show this help message and exit"
        echo -e "  -v, --verbose         print commands being run before running them"
        echo -e "  -d, --debug           print commands to be run but do not execute them"
        echo -e "  -y, --yes             answer yes to all"
        echo -e "  --in-testing          Enable use of in-testing features"
        echo -e "  --tmp=DIRECTORY       do not extract archive, use this tmp directory"
        echo -e "  --dir=DIRECTORY       specify the backup directory to override './Migration_$USER'"
        echo -e "  --archive=FILE        specify the backup archive to override './Migration_$USER.tar.gz'"
        echo -e "                           Note: Archive is used in fresh_install.sh, not here."
        echo -e "                                 This is here just in case it is needed in the future."
        echo -e "  --step=STEP           jump to an install step then exit when complete"
        echo -e "  --continue=STEP       jump to an install step and continue to remaining steps"
        echo -e
        echo -e "Available STEP Options:"
        echo -e "                        desktop"
        echo -e "                        menuentries"
        echo -e "                        icons"
        echo -e "                        keyring"
        echo -e "                        nomachine"
        echo -e "                        network"
        echo -e "                        warzone2100"
        echo -e "                        knossos"
        echo -e "                        rawtherapee"
        echo -e "                        bricscad"
        echo -e "                        dosbox"
        echo -e "                        friction"
        echo -e "                        thunderbird"
        echo -e "                        kicad"
        echo -e "                        gzdoom"
        echo -e "                        audacious"
        echo -e "                        vlc"
        echo -e "                        eclipse"
        echo -e "                        kate"
        echo -e "                        power"
        echo -e "                        shortcuts"
        echo -e "                        plasma"
        echo -e "                        login"
        echo -e "                        cleanup"
        #echo -e "                        symlinks"
        #echo -e "                        compress"
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
        answer="y"
        GOTO="${arg#*=}"
        shift # Remove from processing
        ;;
        --continue=*)
        GOTOCONTINUE=true
        answer="y"
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
echo -e "${PURPLE}==========================================================================${NC}"
echo -e "${PURPLE}\tRestore Backup${NC}"
echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
echo -e "${grey}  Desktop${NC}"
echo -e "${grey}  User Application Menu Entries${NC}"
echo -e "${grey}  User Icons${NC}"
echo -e "${grey}  Keyring${NC}"
echo -e "${grey}  NoMachine${NC}"
echo -e "${grey}  Network and VPN settings${NC}"
echo -e "${grey}  Warzone2100${NC}"
echo -e "${grey}  Knossos${NC}"
echo -e "${grey}  RawTherapee${NC}"
echo -e "${grey}  BricsCAD${NC}"
echo -e "${grey}  DosBox${NC}"
echo -e "${grey}  Frictional Games${NC}"
echo -e "${grey}  Thunderbird${NC}"
echo -e "${grey}  kicad${NC}"
echo -e "${grey}  gzdoom${NC}"
echo -e "${grey}  Audacious${NC}"
echo -e "${grey}  VLC${NC}"
echo -e "${grey}  Eclipse${NC}"
echo -e "${grey}  Kate${NC}"
echo -e "${grey}  Power management${NC}"
echo -e "${grey}  Global shortcuts${NC}"
echo -e "${grey}  Plasma settings${NC}"
echo -e "${grey}  Login scripts${NC}"
echo -e
echo -e "${YELLOW}Using backup directory: '${BACKUP_DIR}'${NC}"
if [ "$EXTRACT" = false ]; then echo -e "${YELLOW}        Temp directory: '${TMP_DIR}'${NC}"; fi
echo -e "${YELLOW}Using archive: '${ARCHIVE_FILE}'${NC}"
echo -e -n "${BLUE}Proceed? (y/n/a)? ${NC}"
if [ "$ANSWERALL" = false ]; then read answer; fi
echo -e
if [ "$answer" != "${answer#[AaYy]}" ] ;then
    # Yes to All?
    if [ "$answer" != "${answer#[Aa]}" ] ;then answer2="y"; else answer2=""; fi

    extract:
        if [ "$EXTRACT" = true ]; then
            echo -e
            printf "${BLUE}Extract Archive${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                TMP_DIR=$(mktemp -d -t $BACKUP_DIR-XXXXXX)
#                 ctrl_c() { echo -e; cmd "rm -rf ${TMP_DIR}"; echo -e; exit 0; }
                ctrl_c() { echo -e; eval "rm -rf ${TMP_DIR}"; echo -e; exit 0; }
                echo -e "${YELLOW}Temp directory: '${TMP_DIR}'${NC}"
                cmd_string1="pv ${ARCHIVE_FILE} | sudo tar --same-owner -I pigz -x -C '${TMP_DIR}'"
                cmd "$cmd_string1"
            fi
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    
    desktop:
    # Desktop
        echo -e
        printf "${BLUE}Desktop${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/Desktop/ /home/$USER/Desktop/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    menuentries:
    # User app menu entries
        echo -e
        printf "${BLUE}Menu Entries${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.local/share/applications/ /home/$USER/.local/share/applications/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    icons:
    # User Icons
        echo -e
        printf "${BLUE}User Icons${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.local/share/icons/ /home/$USER/.local/share/icons/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    keyring:
    # Keyring
        echo -e
        printf "${BLUE}Keyring${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.local/share/kwalletd /home/$USER/.local/share/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    nomachine:
    # NoMachine (NX)
        echo -e
        printf "${BLUE}NoMachine (NX)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "mkdir -p /usr/NX/etc/"
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/usr/NX/etc/server.cfg /usr/NX/etc/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
        
    network:
    # VPN
        echo -e
        printf "${BLUE}VPN${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/etc/NetworkManager/system-connections /etc/NetworkManager/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    warzone2100:
    # Warzone 2100
        echo -e
        printf "${BLUE}Warzone2100${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/usr/share/games/warzone2100 /usr/share/games/"
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.warzone2100-3.2 /home/$USER/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    knossos:
    # Knossos
        echo -e
        printf "${BLUE}Knossos${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/knossos /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    rawtherapee:
    # RawTherapee
        echo -e
        printf "${BLUE}RawTherapee${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/RawTherapee /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    bricscad:
    # BricsCAD
        echo -e
        printf "${BLUE}BricsCAD${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/BricsCAD /home/$USER/"
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/var/bricsys /var/"
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/opt/bricsys /opt/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    dosbox:
    # DosBox
        echo -e
        printf "${BLUE}DosBox${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.dosbox /home/$USER/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    friction:
    # Frictional Games
        echo -e
        printf "${BLUE}Frictional Games${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.frictionalgames /home/$USER/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    thunderbird:
    # ThunderBird
        echo -e
        printf "${BLUE}ThunderBird${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.thunderbird /home/$USER/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    kicad:
    # KiCAD
        echo -e
        printf "${BLUE}KiCAD${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/kicad /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    gzdoom:
    # gzdoom
        echo -e
        printf "${BLUE}gzdoom${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/gzdoom /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
        
    audacious:
    # Audacious
        echo -e
        printf "${BLUE}Audacious${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/audacious /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    vlc:
    # VLC
        echo -e
        printf "${BLUE}VLC${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/vlc /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    eclipse:
    # Eclipse
        echo -e
        printf "${BLUE}Eclipse${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "mkdir -p /home/$USER/Programs/cpp-2020-06/eclipse/configuration/"
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings /home/$USER/Programs/cpp-2020-06/eclipse/configuration/"
            
            cmd "mkdir -p /home/$USER/Projects/Eclipse/"
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/Projects/Eclipse/.metadata /home/$USER/Projects/Eclipse/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    kate:
    # KATE
        echo -e
        printf "${BLUE}Kate${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/katerc /home/$USER/.config/"
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/katesyntaxhighlightingrc /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    power:
    # Power Management Profile (KDE) (BACKUP)
        echo -e
        printf "${BLUE}Power Management (KDE)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/powermanagementprofilesrc /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    shortcuts:
    # Global Shortcuts (KDE) (BACKUP)
        echo -e
        printf "${BLUE}Global Shortcuts (KDE)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/kglobalshortcutsrc /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    plasma:
    # Plasma Settings (Panel, Notifications, Theme, Desktop Effects) (KDE) (BACKUP)
        echo -e
        printf "${BLUE}Plasma Settings (KDE)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/gtk-3.0/settings.ini /home/$USER/.config/gtk-3.0/"
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc /home/$USER/.config/"
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/plasmanotifyrc /home/$USER/.config/"
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/plasmarc /home/$USER/.config/"
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/kwinrc /home/$USER/.config/"
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.config/kdeglobals /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    login:
    # Login scripts (.bashr/.profile) (BACKUP)
        echo -e
        printf "${BLUE}Login Scripts (.bashrc/.profile)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.bashrc /home/$USER/"
            cmd "sudo rsync -a --info=progress2 ${TMP_DIR}/root/home/$USER/.profile /home/$USER/"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    cleanup:
    if [ "$EXTRACT" = true ]; then
        echo -e
        printf "${BLUE}Remove tmp directory${NC}"
        cmd_string1="rm -rf ${TMP_DIR}"
        printf "${GREEN} (y/n/e)? ${NC}"; read answer;
        echo -e
        if [ "$answer" != "${answer#[Ee]}" ] ;then
            read -p "$(echo -e ${yellow}Edit command 1: ${NC})" -e -i "${cmd_string1}" cmd_string1;
        fi
        if [ "$answer" != "${answer#[YyEe]}" ] ;then
            echo -e
            cmd "$cmd_string1"
        fi
    fi

    
    
    
    
    
    
    
    
    
    

