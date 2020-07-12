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
IN_TESTING=false
COMPRESS=true
NOCOMPRESS=false
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
        shift # Remove from processing
        ;;
        -v|--verbose)
        VERBOSE=true
        FLAGS="$FLAGS-v "
        shift # Remove from processing
        ;;
        -y|--yes)
        ANSWERALL=true
        answer="a";
        answer2="y";
        FLAGS="$FLAGS-y "
        shift # Remove from processing
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
        --in-testing)
        IN_TESTING=true
        FLAGS="$FLAGS--in-testing "
        shift # Remove from processing
        ;;
        -h|--help)
        echo -e "${WHITE}"
        echo -e "Usage: $0.sh <options>"
        echo -e
        echo -e "Note: It is recommended to perform the backup locally and not directly"
        echo -e "      to external media such as USB. If the device has ACL enabled then"
        echo -e "      file permissions and ownership may not be preserved. The compressed"
        echo -e "      backup is safe to transfer."
        echo -e
        echo -e "Options:"
        echo -e "  -h, --help            show this help message and exit"
        echo -e "  -v, --verbose         print commands being run before running them"
        echo -e "  -d, --debug           print commands to be run but do not execute them"
        echo -e "  -y, --yes             answer yes to all, except compress"
        echo -e "  -z, --zip             compress the backup and remove backup folder (this is default behavior now)"
        echo -e "  -x                    do not compress backup folder, folder remains in tmp directory"
        echo -e "  --in-testing          Enable use of in-testing features"
        echo -e "  --dir=DIRECTORY       specify the backup directory to override './Migration_$USER'"
        echo -e "  --archive=FILE        specify the backup archive to override './Migration_$USER.tar.gz'"
        echo -e "  --step=STEP           jump to an install step then exit when complete"
        echo -e "  --continue=STEP       jump to an install step and continue to remaining steps"
        echo -e
        echo -e "Available STEP Options:"
        echo -e "                        layout"
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
        *)
        OTHER_ARGUMENTS="$OTHER_ARGUMENTS$1 "
        echo -e "${RED}Unknown argument: $1${NC}"
        exit
        shift # Remove generic argument from processing
        ;;
    esac
done

TMP_DIR=$(mktemp -d -t $BACKUP_DIR-XXXXXX)

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
echo -e "${PURPLE}\tPerforming Backup${NC}"
echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
echo -e "${purple}  Note: It is recommended to perform the backup locally and not directly${NC}"
echo -e "${purple}        to external media such as USB. If the device has ACL enabled then${NC}"
echo -e "${purple}        file permissions and ownership may not be preserved. The compressed${NC}"
echo -e "${purple}        backup is safe to transfer.${NC}"
echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
echo -e "${grey}  Drive Layout Reference"
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
echo -e "${YELLOW}        Temp directory: '${TMP_DIR}'${NC}"
echo -e "${YELLOW}         Using archive: '${ARCHIVE_FILE}'${NC}"
echo -e -n "${BLUE}Proceed? (y/n/a)? ${NC}"
if [ "$ANSWERALL" = false ]; then read answer; fi
echo -e
if [ "$answer" != "${answer#[AaYy]}" ] ;then
    # Yes to All?
    if [ "$answer" != "${answer#[Aa]}" ] ;then answer2="y"; else answer2=""; fi

    # Check Directory
         if [ -d "${BACKUP_DIR}" ] ;then
             timestamp=$(date +%s)
             echo -e "${red}Error! Directory '${BACKUP_DIR}' exists.${NC}"
             echo -e -n "${BLUE}Moving '${BACKUP_DIR}' to './Migration_${USER}_${timestamp}'...${NC}" 
             cmd "mv ./Migration_${USER} ./Migration_${USER}_${timestamp}"
             echo -e "${BLUE}DONE${NC}"
         fi
        
    # Create Directory
        echo -e -n "${BLUE}Creating directory '${BACKUP_DIR}'${NC}\n"
        cmd "mkdir -pv ${TMP_DIR}/root/"
        cmd "mkdir -pv ${TMP_DIR}/symlinks/"

    layout:
    # Drive Layout Reference
        echo -e
        echo -e "${BLUE}Drive Layout Reference (Saved to ${BACKUP_DIR}/drive_layout.txt)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "lsblk -e7 >> ${TMP_DIR}/drive_layout.txt"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    desktop:
    # Desktop
        echo -e
        echo -e "${BLUE}Desktop${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/Desktop/ ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
        
    menuentries:
    # User app menu entries
        echo -e
        echo -e "${BLUE}Menu Entries${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.local/share/applications/ ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
        
    icons:
    # User Icons
        echo -e
        echo -e "${BLUE}User Icons${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.local/share/icons/ ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
        
    keyring:
    # Keyring
        echo -e
        echo -e "${BLUE}Keyring${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.local/share/kwalletd/ ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    nomachine:
    # NoMachine (NX)
        echo -e
        echo -e "${BLUE}NoMachine (NX)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /usr/NX/etc/server.cfg ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
        
    network:
    # Network Connections and VPNs
        echo -e
        echo -e "${BLUE}Network Connections and VPNs${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /etc/NetworkManager/system-connections/ ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    warzone2100:
    # Warzone 2100
        echo -e
        echo -e "${BLUE}Warzone 2100${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /usr/share/games/warzone2100/sequences.wz ${TMP_DIR}/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.warzone2100-3.2 ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    knossos:
    # Knossos
        echo -e
        echo -e "${BLUE}Knossos${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/knossos ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
        
    rawtherapee:
    # RawTherapee
        echo -e
        echo -e "${BLUE}RawTherapee${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/RawTherapee ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
        
    bricscad:
    # BricsCAD
        echo -e
        echo -e "${BLUE}BricsCAD${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/BricsCAD ${TMP_DIR}/root/"
            cmd "sudo rsync -aR --info=progress2 /var/bricsys/ ${TMP_DIR}/root/"
            cmd "sudo rsync -aR --info=progress2 /opt/bricsys/bricscad/v20/RenderMaterialStatic ${TMP_DIR}/root/"
            cmd "sudo rsync -aR --info=progress2 /opt/bricsys/communicator ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    dosbox:
    # DosBox
        echo -e
        echo -e "${BLUE}DosBox${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.dosbox ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    friction:
    # Frictional Games
        echo -e
        echo -e "${BLUE}Frictional Games${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.frictionalgames ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    thunderbird:
    # ThunderBird
        echo -e
        echo -e "${BLUE}ThunderBird${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.thunderbird/ ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    kicad:
    # KiCAD
        echo -e
        echo -e "${BLUE}KiCAD${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kicad ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    gzdoom:
    # gzdoom
        echo -e
        echo -e "${BLUE}gzdoom${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/gzdoom ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    audacious:
    # Audacious
        echo -e
        echo -e "${BLUE}Audacious${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/audacious ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    vlc:
    # VLC
        echo -e
        echo -e "${BLUE}VLC${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/vlc ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    eclipse:
    # Eclipse
        echo -e
        echo -e "${BLUE}Eclipse${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs ${TMP_DIR}/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/Projects/Eclipse/.metadata ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    kate:
    # KATE
        echo -e
        echo -e "${BLUE}KAte${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/katerc ${TMP_DIR}/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/katesyntaxhighlightingrc ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    power:
    # Power Management Profile (KDE) (BACKUP)
        echo -e
        echo -e "${BLUE}Power Management${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/powermanagementprofilesrc ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    shortcuts:
    # Global Shortcuts (KDE) (BACKUP)
        echo -e
        echo -e "${BLUE}Global Shortcuts${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kglobalshortcutsrc ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    plasma:
    # Plasma Settings (Panel, Notifications, Theme, Desktop Effects) (KDE) (BACKUP)
        echo -e
        echo -e "${BLUE}Plasma Settings${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/gtk-3.0/settings.ini ${TMP_DIR}/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc ${TMP_DIR}/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasmanotifyrc ${TMP_DIR}/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasmarc ${TMP_DIR}/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kwinrc ${TMP_DIR}/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kdeglobals ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    login:
    # Login scripts (.bashr/.profile) (BACKUP)
        echo -e
        echo -e "${BLUE}Login Scripts${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.bashrc ${TMP_DIR}/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.profile ${TMP_DIR}/root/"
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
        
    symlinks:
    # symlinks (predetermined list)
        echo -e
        echo -e "${BLUE}Symlinks${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cp_if_link(){ [ ! -L "$1" ] || cmd "rsync -aR --info=progress2 $1 ${TMP_DIR}/symlinks/"; }
            cp_if_link /home/$USER/Documents
            cp_if_link /home/$USER/Downloads
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
        fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    compress:
    # Compress directory
        if [ "$NOCOMPRESS" = false ]; then
            echo -e
            echo -e "${PURPLE}==========================================================================${NC}"
            echo -e "${PURPLE}\tCompress Backup${NC}"
            echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
            echo -e "${purple}Helps maintain permissions, will remove backup folder after complete.${NC}"
            echo -e 
            echo -e "${purple}This will also install pigz for parallel processor usage, and pv to monitor${NC}"
            echo -e "${purple}the speed.${NC}"
            echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
            echo -e
            echo -e -n "${BLUE}Compress Backup${NC}"
            
            # TODO: Rename tmp directory on compress
            #tar -zxf my-dir.tar.gz --transform s/my-dir/your-dir/
            
            if [ "$COMPRESS" = false  ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo -e; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] || [ "$COMPRESS" = true ] ;then
                if ! command -v pigz &> /dev/null; then cmd "sudo apt install pigz"; fi
                if ! command -v pv &> /dev/null; then cmd "sudo apt install pv"; fi
                #cmd "sudo apt install pigz pv"
                #cmd "sudo tar -czvpf Migration_$USER.tar.gz ${TMP_DIR}"
                #cmd "sudo tar --use-compress-program='pigz --best --recursive | pv' -cpf ${ARCHIVE_FILE} ${TMP_DIR}/"
                
                cmd "sudo tar --use-compress-program='pigz --best --recursive | pv' --transform 's/$(basename $TMP_DIR)/$(basename $BACKUP_DIR)/' -cpf '${ARCHIVE_FILE}' -C '${TMP_DIR}' ./"
                cmd "sudo rm -rf ${TMP_DIR}"
            fi
        fi
    
    # NOTE: This last condition is slightly different to prevent final 'fi' from complaining after doing a jumpto()
    if [ "$GOTOSTEP" = true ] || [ "$GOTOCONTINUE" = true ]; then exit; fi
fi











