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
echo -e "${PURPLE}\tRestore Backup${NC}"
echo -e "${PURPLE}--------------------------------------------------------------------------${NC}"
echo -e "${grey}\tkeyring${NC}"
echo -e "${grey}\tnomachine${NC}"
echo -e "${grey}\tvpn settings${NC}"
echo -e "${grey}\twarzone2100${NC}"
echo -e "${grey}\tknossos${NC}"
echo -e "${grey}\trawtherapee${NC}"
echo -e "${grey}\tbricscad${NC}"
echo -e "${grey}\tdosbox${NC}"
echo -e "${grey}\tfrictional games${NC}"
echo -e "${grey}\tthunderbird${NC}"
echo -e "${grey}\tkicad${NC}"
echo -e "${grey}\tgzdoom${NC}"
echo -e "${grey}\taudacious${NC}"
echo -e "${grey}\tvlc${NC}"
echo -e "${grey}\teclipse${NC}"
echo -e "${grey}\tkate${NC}"
echo -e "${grey}\tpower management${NC}"
echo -e "${grey}\tglobal shortcuts${NC}"
echo -e "${grey}\tplasma settings${NC}"
echo -e "${grey}\tlogin scripts${NC}"
echo -e -n "${BLUE}Proceed? (y/n/a)? ${NC}"
read answer
echo -e
if [ "$answer" != "${answer#[AaYy]}" ] ;then
    # Yes to All?
    if [ "$answer" != "${answer#[Aa]}" ] ;then answer2="y"; else answer2=""; fi

    # User app menu entries
        echo -e
        printf "${BLUE}Menu Entries${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.local/share/applications/ /home/$USER/.local/share/applications/"
        fi
    
    # Keyring
        echo -e
        printf "${BLUE}Keyring${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.local/share/kwalletd /home/$USER/.local/share/"
        fi

    # NoMachine (NX)
        echo -e
        printf "${BLUE}NoMachine (NX)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "mkdir -p /usr/NX/etc/"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/usr/NX/etc/server.cfg /usr/NX/etc/"
        fi
        
    # VPN
        echo -e
        printf "${BLUE}VPN${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/etc/NetworkManager/system-connections /etc/NetworkManager/"
        fi

    # Warzone 2100
        echo -e
        printf "${BLUE}Warzone2100${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/usr/share/games/warzone2100 /usr/share/games/"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.warzone2100-3.2 /home/$USER/"
        fi

    # Knossos
        echo -e
        printf "${BLUE}Knossos${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/knossos /home/$USER/.config/"
        fi

    # RawTherapee
        echo -e
        printf "${BLUE}RawTherapee${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/RawTherapee /home/$USER/.config/"
        fi

    # BricsCAD
        echo -e
        printf "${BLUE}BricsCAD${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/BricsCAD /home/$USER/"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/var/bricsys /var/"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/opt/bricsys /opt/"
        fi

    # DosBox
        echo -e
        printf "${BLUE}DosBox${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.dosbox /home/$USER/"
        fi

    # Frictional Games
        echo -e
        printf "${BLUE}Frictional Games${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.frictionalgames /home/$USER/"
        fi

    # ThunderBird
        echo -e
        printf "${BLUE}ThunderBird${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.thunderbird /home/$USER/"
        fi

    # KiCAD
        echo -e
        printf "${BLUE}KiCAD${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/kicad /home/$USER/.config/"
        fi

    # gzdoom
        echo -e
        printf "${BLUE}gzdoom${NC}\n"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ./Migration_$USER/root/home/$USER/.config/gzdoom /home/$USER/.config/"
        fi
        
    # Audacious
        echo -e
        printf "${BLUE}Audacious${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/audacious /home/$USER/.config/"
        fi

    # VLC
        echo -e
        printf "${BLUE}VLC${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/vlc /home/$USER/.config/"
        fi

    # Eclipse
        echo -e
        printf "${BLUE}Eclipse${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "mkdir -p /home/$USER/Programs/cpp-2020-06/eclipse/configuration/"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings /home/$USER/Programs/cpp-2020-06/eclipse/configuration/"
            
            cmd "mkdir -p /home/$USER/Projects/Eclipse/"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/Projects/Eclipse/.metadata /home/$USER/Projects/Eclipse/"
        fi

    # KATE
        echo -e
        printf "${BLUE}Kate${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/katerc /home/$USER/.config/"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/katesyntaxhighlightingrc /home/$USER/.config/"
        fi

    # Power Management Profile (KDE) (BACKUP)
        echo -e
        printf "${BLUE}Power Management (KDE)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.config/powermanagementprofilesrc /home/$USER/.config/powermanagementprofilesrc.bak"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/powermanagementprofilesrc /home/$USER/.config/"
        fi

    # Global Shortcuts (KDE) (BACKUP)
        echo -e
        printf "${BLUE}Global Shortcuts (KDE)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.config/kglobalshortcutsrc /home/$USER/.config/kglobalshortcutsrc.bak"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/kglobalshortcutsrc /home/$USER/.config/"
        fi

    # Plasma Settings (Panel, Notifications, Theme, Desktop Effects) (KDE) (BACKUP)
        echo -e
        printf "${BLUE}Plasma Settings (KDE)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc.bak"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc /home/$USER/.config/"
            
            #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.config/plasmanotifyrc /home/$USER/.config/plasmanotifyrc.bak"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/plasmanotifyrc /home/$USER/.config/"
            
            #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.config/plasmarc /home/$USER/.config/plasmarc.bak"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/plasmarc /home/$USER/.config/"
            
            #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.config/kwinrc /home/$USER/.config/kwinrc.bak"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/kwinrc /home/$USER/.config/"
        fi

    # Login scripts (.bashr/.profile) (BACKUP)
        echo -e
        printf "${BLUE}Login Scripts (.bashrc/.profile)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.bashrc /home/$USER/.bashrc.bak"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.bashrc /home/$USER/"
            
            #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.profile /home/$USER/.profile.bak"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.profile /home/$USER/"
        fi
    fi












