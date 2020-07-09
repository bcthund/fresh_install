#!/bin/bash
grey='\e[37;0m'
GREY='\e[37;1m'
red='\e[31;0m'
RED='\e[31;1m'
green='\e[32;0m'
GREEN='\e[32;1m'
yellow='\e[33;0m'
YELLOW='\e[33;1m'
purple='\e[35;0m'
PURPLE='\e[35;1m'
white='\e[37;0m'
WHITE='\e[37;1m'
blue='\e[34;0m'
BLUE='\e[34;1m'
cyan='\e[36;0m'
CYAN='\e[36;1m'
NC='\e[39;0m'

# Setup command
DEBUG=false
VERBOSE=false
ANSWERALL=false
BACKUP_DIR="./Migration_$USER"
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
        -h|--help)
        echo -e "${WHITE}"
        echo -e "Usage: $0.sh <options>"
        echo -e
        echo -e "Options:"
        echo -e "  -h, --help            show this help message and exit"
        echo -e "  -v, --verbose         print commands being run before running them"
        echo -e "  -d, --debug           print commands to be run but do not execute them"
        echo -e "  -y, --yes             answer yes to all"
        echo -e "  --dir=DIRECTORY       specify the backup directory to override './Migration_$USER'"
        echo -e "  --archive=FILE        specify the backup archive to override './Migration_$USER.tar.gz'"
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
        echo -e "                        symlinks"
        echo -e "                        compress"
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
echo -e -n "${BLUE}Proceed? (y/n/a)? ${NC}"
if [ "$ANSWERALL" = false ]; then read answer; fi
echo -e
if [ "$answer" != "${answer#[AaYy]}" ] ;then
    # Yes to All?
    if [ "$answer" != "${answer#[Aa]}" ] ;then answer2="y"; else answer2=""; fi

    desktop:
    # Desktop
        echo -e
        echo -e "${BLUE}Desktop${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/Desktop/ /home/$USER/Desktop/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    menuentries:
    # User app menu entries
        echo -e
        printf "${BLUE}Menu Entries${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.local/share/applications/ /home/$USER/.local/share/applications/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    icons:
    # User Icons
        echo -e
        echo -e "${BLUE}User Icons${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.local/share/icons/ /home/$USER/.local/share/icons/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    keyring:
    # Keyring
        echo -e
        printf "${BLUE}Keyring${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.local/share/kwalletd /home/$USER/.local/share/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    nomachine:
    # NoMachine (NX)
        echo -e
        printf "${BLUE}NoMachine (NX)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "mkdir -p /usr/NX/etc/"
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/usr/NX/etc/server.cfg /usr/NX/etc/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
        
    network:
    # VPN
        echo -e
        printf "${BLUE}VPN${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/etc/NetworkManager/system-connections /etc/NetworkManager/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    warzone2100:
    # Warzone 2100
        echo -e
        printf "${BLUE}Warzone2100${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/usr/share/games/warzone2100 /usr/share/games/"
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.warzone2100-3.2 /home/$USER/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    knossos:
    # Knossos
        echo -e
        printf "${BLUE}Knossos${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.config/knossos /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    rawtherapee:
    # RawTherapee
        echo -e
        printf "${BLUE}RawTherapee${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.config/RawTherapee /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    bricscad:
    # BricsCAD
        echo -e
        printf "${BLUE}BricsCAD${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/BricsCAD /home/$USER/"
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/var/bricsys /var/"
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/opt/bricsys /opt/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    dosbox:
    # DosBox
        echo -e
        printf "${BLUE}DosBox${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.dosbox /home/$USER/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    friction:
    # Frictional Games
        echo -e
        printf "${BLUE}Frictional Games${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.frictionalgames /home/$USER/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    thunderbird:
    # ThunderBird
        echo -e
        printf "${BLUE}ThunderBird${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.thunderbird /home/$USER/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    kicad:
    # KiCAD
        echo -e
        printf "${BLUE}KiCAD${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.config/kicad /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    gzdoom:
    # gzdoom
        echo -e
        printf "${BLUE}gzdoom${NC}\n"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ${BACKUP_DIR}/root/home/$USER/.config/gzdoom /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
        
    audacious:
    # Audacious
        echo -e
        printf "${BLUE}Audacious${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.config/audacious /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    vlc:
    # VLC
        echo -e
        printf "${BLUE}VLC${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.config/vlc /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    eclipse:
    # Eclipse
        echo -e
        printf "${BLUE}Eclipse${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "mkdir -p /home/$USER/Programs/cpp-2020-06/eclipse/configuration/"
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings /home/$USER/Programs/cpp-2020-06/eclipse/configuration/"
            
            cmd "mkdir -p /home/$USER/Projects/Eclipse/"
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/Projects/Eclipse/.metadata /home/$USER/Projects/Eclipse/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    kate:
    # KATE
        echo -e
        printf "${BLUE}Kate${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.config/katerc /home/$USER/.config/"
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.config/katesyntaxhighlightingrc /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    power:
    # Power Management Profile (KDE) (BACKUP)
        echo -e
        printf "${BLUE}Power Management (KDE)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.config/powermanagementprofilesrc /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    shortcuts:
    # Global Shortcuts (KDE) (BACKUP)
        echo -e
        printf "${BLUE}Global Shortcuts (KDE)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.config/kglobalshortcutsrc /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    plasma:
    # Plasma Settings (Panel, Notifications, Theme, Desktop Effects) (KDE) (BACKUP)
        echo -e
        printf "${BLUE}Plasma Settings (KDE)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc /home/$USER/.config/"
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.config/plasmanotifyrc /home/$USER/.config/"
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.config/plasmarc /home/$USER/.config/"
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.config/kwinrc /home/$USER/.config/"
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.config/kdeglobals /home/$USER/.config/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    login:
    # Login scripts (.bashr/.profile) (BACKUP)
        echo -e
        printf "${BLUE}Login Scripts (.bashrc/.profile)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.bashrc /home/$USER/"
            cmd "sudo rsync -a --info=progress2 --delete ${BACKUP_DIR}/root/home/$USER/.profile /home/$USER/"
        fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi












