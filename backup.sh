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
        echo -e "${WHITE}"
        echo -e "Usage: $0.sh <options>"
        echo -e
        echo -e "Options:"
        echo -e "  -h, --help            show this help message and exit"
        echo -e "  -v, --verbose         print commands being run before running them"
        echo -e "  -d, --debug           print commands to be run but do not execute them"
        echo -e "${NC}"
        exit
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

echo -e
echo -e "${PURPLE}==========================================================================${NC}"
echo -e "${PURPLE}\tPerforming Backup${NC}"
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
echo -e -n "${BLUE}Proceed? (y/n/a)? ${NC}"
read answer
echo -e
if [ "$answer" != "${answer#[AaYy]}" ] ;then
    # Yes to All?
    if [ "$answer" != "${answer#[Aa]}" ] ;then answer2="y"; else answer2=""; fi

    # Check Directory
        if [ -d "./Migration_$USER" ] ;then
            timestamp=$(date +%s)
            echo -e "${red}Error! Directory './Migration_$USER' exists.${NC}"
            echo -e -n "${BLUE}Moving './Migration_$USER' to './Migration_${USER}_${timestamp}'...${NC}" 
            cmd "mv ./Migration_${USER} ./Migration_${USER}_${timestamp}"
            echo -e "${BLUE}DONE${NC}"
        fi
        
    # Create Directory
        echo -e -n "${BLUE}Creating directory './Migration_$USER'${NC}\n"
        cmd "mkdir -pv ./Migration_$USER/root/"
        cmd "mkdir -pv ./Migration_$USER/symlinks/"

    # Drive Layout Reference
        echo -e
        echo -e "${BLUE}Drive Layout Reference (Saved to ./Migration_$USER/drive_layout.txt)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "lsblk -e7 >> ./Migration_$USER/drive_layout.txt"
        fi
        
    # Desktop
        echo -e
        echo -e "${BLUE}Desktop${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/Desktop/ ./Migration_$USER/root/"
        fi
        
    # User app menu entries
        echo -e
        echo -e "${BLUE}Menu Entries${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.local/share/applications/ ./Migration_$USER/root/"
        fi
        
    # User Icons
        echo -e
        echo -e "${BLUE}User Icons${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.local/share/icons/ ./Migration_$USER/root/"
        fi
        
    # Keyring
        echo -e
        echo -e "${BLUE}Keyring${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.local/share/kwalletd/ ./Migration_$USER/root/"
        fi

    # NoMachine (NX)
        echo -e
        echo -e "${BLUE}NoMachine (NX)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /usr/NX/etc/server.cfg ./Migration_$USER/root/"
        fi
        
    # Network Connections and VPNs
        echo -e
        echo -e "${BLUE}Network Connections and VPNs${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /etc/NetworkManager/system-connections/ ./Migration_$USER/root/"
        fi

    # Warzone 2100
        echo -e
        echo -e "${BLUE}Warzone 2100${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /usr/share/games/warzone2100/sequences.wz ./Migration_$USER/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.warzone2100-3.2 ./Migration_$USER/root/"
        fi

    # Knossos
        echo -e
        echo -e "${BLUE}Knossos${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/knossos ./Migration_$USER/root/"
        fi

    # RawTherapee
        echo -e
        echo -e "${BLUE}RawTherapee${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/RawTherapee ./Migration_$USER/root/"
        fi

    # BricsCAD
        echo -e
        echo -e "${BLUE}BricsCAD${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/BricsCAD ./Migration_$USER/root/"
            cmd "sudo rsync -aR --info=progress2 /var/bricsys/ ./Migration_$USER/root/"
            cmd "sudo rsync -aR --info=progress2 /opt/bricsys/bricscad/v20/RenderMaterialStatic ./Migration_$USER/root/"
            cmd "sudo rsync -aR --info=progress2 /opt/bricsys/communicator ./Migration_$USER/root/"
        fi

    # DosBox
        echo -e
        echo -e "${BLUE}DosBox${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.dosbox ./Migration_$USER/root/"
        fi

    # Frictional Games
        echo -e
        echo -e "${BLUE}Frictional Games${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.frictionalgames ./Migration_$USER/root/"
        fi

    # ThunderBird
        echo -e
        echo -e "${BLUE}ThunderBird${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.thunderbird/ ./Migration_$USER/root/"
        fi

    # KiCAD
        echo -e
        echo -e "${BLUE}KiCAD${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kicad ./Migration_$USER/root/"
        fi

    # gzdoom
        echo -e
        echo -e "${BLUE}gzdoom${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/gzdoom ./Migration_$USER/root/"
        fi

    # Audacious
        echo -e
        echo -e "${BLUE}Audacious${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/audacious ./Migration_$USER/root/"
        fi

    # VLC
        echo -e
        echo -e "${BLUE}VLC${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/vlc ./Migration_$USER/root/"
        fi

    # Eclipse
        echo -e
        echo -e "${BLUE}Eclipse${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs ./Migration_$USER/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/Projects/Eclipse/.metadata ./Migration_$USER/root/"
        fi

    # KATE
        echo -e
        echo -e "${BLUE}KAte${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/katerc ./Migration_$USER/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/katesyntaxhighlightingrc ./Migration_$USER/root/"
        fi

    # Power Management Profile (KDE) (BACKUP)
        echo -e
        echo -e "${BLUE}Power Management${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/powermanagementprofilesrc ./Migration_$USER/root/"
        fi

    # Global Shortcuts (KDE) (BACKUP)
        echo -e
        echo -e "${BLUE}Global Shortcuts${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kglobalshortcutsrc ./Migration_$USER/root/"
        fi

    # Plasma Settings (Panel, Notifications, Theme, Desktop Effects) (KDE) (BACKUP)
        echo -e
        echo -e "${BLUE}Plasma Settings${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc ./Migration_$USER/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasmanotifyrc ./Migration_$USER/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasmarc ./Migration_$USER/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kwinrc ./Migration_$USER/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kdeglobals ./Migration_$USER/root/"
        fi

    # Login scripts (.bashr/.profile) (BACKUP)
        echo -e
        echo -e "${BLUE}Login Scripts${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.bashrc ./Migration_$USER/root/"
            cmd "sudo rsync -aR --info=progress2 /home/$USER/.profile ./Migration_$USER/root/"
        fi
        
    # symlinks (predetermined list)
        echo -e
        echo -e "${BLUE}Symlinks${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cp_if_link(){ [ ! -L "$1" ] || cmd "rsync -aR --info=progress2 $1 ./Migration_$USER/symlinks/"; }
            cp_if_link /home/$USER/Documents
            #cp_if_link /home/$USER/Downloads
            cp_if_link /home/$USER/Music
            cp_if_link /home/$USER/Pictures
            cp_if_link /home/$USER/Downloads
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
fi











