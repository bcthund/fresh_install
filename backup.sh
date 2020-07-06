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
        *)
        OTHER_ARGUMENTS="$OTHER_ARGUMENTS$1 "
        shift # Remove generic argument from processing
        ;;
    esac
done

cmd(){
    if [ "$VERBOSE" = true ] || [ "$DEBUG" = true ]; then echo ">> ${WHITE}$1${NC}"; fi;
    if [ "$DEBUG" = false ]; then eval $1; fi;
}

cmd "echo backup.sh $FLAGS"
exit 0

echo
echo "${PURPLE}==========================================================================${NC}"
echo "${PURPLE}\tPerforming Backup${NC}"
echo "${PURPLE}--------------------------------------------------------------------------${NC}"
echo "${grey}\tuser application menu entries${NC}"
echo "${grey}\tkeyring${NC}"
echo "${grey}\tnomachine${NC}"
echo "${grey}\tvpn settings${NC}"
echo "${grey}\twarzone2100${NC}"
echo "${grey}\tknossos${NC}"
echo "${grey}\trawtherapee${NC}"
echo "${grey}\tbricscad${NC}"
echo "${grey}\tdosbox${NC}"
echo "${grey}\tfrictional games${NC}"
echo "${grey}\tthunderbird${NC}"
echo "${grey}\tkicad${NC}"
echo "${grey}\tgzdoom${NC}"
echo "${grey}\taudacious${NC}"
echo "${grey}\tvlc${NC}"
echo "${grey}\teclipse${NC}"
echo "${grey}\tkate${NC}"
echo "${grey}\tpower management${NC}"
echo "${grey}\tglobal shortcuts${NC}"
echo "${grey}\tplasma settings${NC}"
echo "${grey}\tlogin scripts${NC}"
echo -n "${BLUE}Proceed? (y/n/a)? ${NC}"
read answer
echo
if [ "$answer" != "${answer#[AaYy]}" ] ;then
    # Yes to All?
    if [ "$answer" != "${answer#[Aa]}" ] ;then answer2="y"; else answer2=""; fi

        # Check Directory
            if [ -d "./Migration_$USER" ] ;then
                timestamp=$(date +%s)
                echo "${red}Error! Directory './Migration_$USER' exists.${NC}"
                echo -n "${BLUE}Moving './Migration_$USER' to './Migration_${USER}_${timestamp}'...${NC}" 
                cmd "mv ./Migration_${USER} ./Migration_${USER}_${timestamp}"
                echo "${BLUE}DONE${NC}"
            fi
            
        # Create Directory
            echo -n "${BLUE}Creating directory './Migration_$USER'${NC}\n"
            cmd "mkdir -pv ./Migration_$USER/root/"
            cmd "mkdir -pv ./Migration_$USER/symlinks/"

        # User app menu entries
            echo
            echo "${BLUE}Menu Entries${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.local/share/applications/ ./Migration_$USER/root/"
            fi
            
        # Keyring
            echo
            echo "${BLUE}Keyring${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.local/share/kwalletd/ ./Migration_$USER/root/"
            fi

        # NoMachine (NX)
            echo
            echo "${BLUE}NoMachine (NX)${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /usr/NX/etc/server.cfg ./Migration_$USER/root/"
            fi
            
        # VPN
            echo
            echo "${BLUE}VPNs${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /etc/NetworkManager/system-connections/ ./Migration_$USER/root/"
            fi

        # Warzone 2100
            echo
            echo "${BLUE}Warzone 2100${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /usr/share/games/warzone2100/sequences.wz ./Migration_$USER/root/"
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.warzone2100-3.2 ./Migration_$USER/root/"
            fi

        # Knossos
            echo
            echo "${BLUE}Knossos${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/knossos ./Migration_$USER/root/"
            fi

        # RawTherapee
            echo
            echo "${BLUE}RawTherapee${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/RawTherapee ./Migration_$USER/root/"
            fi

        # BricsCAD
            echo
            echo "${BLUE}BricsCAD${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/BricsCAD ./Migration_$USER/root/"
                cmd "sudo rsync -aR --info=progress2 /var/bricsys/ ./Migration_$USER/root/"
                cmd "sudo rsync -aR --info=progress2 /opt/bricsys/bricscad/v20/RenderMaterialStatic ./Migration_$USER/root/"
                cmd "sudo rsync -aR --info=progress2 /opt/bricsys/communicator ./Migration_$USER/root/"
            fi

        # DosBox
            echo
            echo "${BLUE}DosBox${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.dosbox ./Migration_$USER/root/"
            fi

        # Frictional Games
            echo
            echo "${BLUE}Frictional Games${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.frictionalgames ./Migration_$USER/root/"
            fi

        # ThunderBird
            echo
            echo "${BLUE}ThunderBird${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.thunderbird/ ./Migration_$USER/root/"
            fi

        # KiCAD
            echo
            echo "${BLUE}KiCAD${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kicad ./Migration_$USER/root/"
            fi

        # gzdoom
            echo
            echo "${BLUE}gzdoom${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/gzdoom ./Migration_$USER/root/"
            fi

        # Audacious
            echo
            echo "${BLUE}Audacious${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/audacious ./Migration_$USER/root/"
            fi

        # VLC
            echo
            echo "${BLUE}VLC${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/vlc ./Migration_$USER/root/"
            fi

        # Eclipse
            echo
            echo "${BLUE}Eclipse${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs ./Migration_$USER/root/"
                cmd "sudo rsync -aR --info=progress2 /home/$USER/Projects/Eclipse/.metadata ./Migration_$USER/root/"
            fi

        # KATE
            echo
            echo "${BLUE}KAte${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/katerc ./Migration_$USER/root/"
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/katesyntaxhighlightingrc ./Migration_$USER/root/"
            fi

        # Power Management Profile (KDE) (BACKUP)
            echo
            echo "${BLUE}Power Management${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/powermanagementprofilesrc ./Migration_$USER/root/"
            fi

        # Global Shortcuts (KDE) (BACKUP)
            echo
            echo "${BLUE}Global Shortcuts${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kglobalshortcutsrc ./Migration_$USER/root/"
            fi

        # Plasma Settings (Panel, Notifications, Theme, Desktop Effects) (KDE) (BACKUP)
            echo
            echo "${BLUE}Plasma Settings${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc ./Migration_$USER/root/"
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasmanotifyrc ./Migration_$USER/root/"
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasmarc ./Migration_$USER/root/"
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kwinrc ./Migration_$USER/root/"
            fi

        # Login scripts (.bashr/.profile) (BACKUP)
            echo
            echo "${BLUE}Login Scripts${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.bashrc ./Migration_$USER/root/"
                cmd "sudo rsync -aR --info=progress2 /home/$USER/.profile ./Migration_$USER/root/"
            fi
            
        # symlinks (predetermined list)
            echo
            echo "${BLUE}Symlinks${NC}"
            if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; fi
            if [ "$answer2" != "${answer2#[Yy]}" ] ;then
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
            fi
    fi
fi











