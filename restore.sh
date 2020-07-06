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

if [ "$1" != "${1#[debug]}" ] ;then
    cmd(){ echo ">> ${WHITE}$1${NC}"; }
    #echo "${RED}DEBUG: Commands will be echoed to console${NC}"
else
    cmd(){ echo ">> ${WHITE}$1${NC}"; eval $1; }
    #echo "${RED}LIVE: Actions will be performed! Use caution.${NC}"
fi

echo
echo "${PURPLE}==========================================================================${NC}"
echo "${PURPLE}\tRestore Backup${NC}"
echo "${PURPLE}--------------------------------------------------------------------------${NC}"
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

    # Keyring
        echo
        printf "${BLUE}Keyring${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.local/share/kwalletd /home/$USER/.local/share/"
        fi

    # NoMachine (NX)
        echo
        printf "${BLUE}NoMachine (NX)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "mkdir -p /usr/NX/etc/"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/usr/NX/etc/server.cfg /usr/NX/etc/"
        fi
        
    # VPN
        echo
        printf "${BLUE}VPN${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/etc/NetworkManager/system-connections /etc/NetworkManager/"
        fi

    # Warzone 2100
        echo
        printf "${BLUE}Warzone2100${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/usr/share/games/warzone2100 /usr/share/games/"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.warzone2100-3.2 /home/$USER/"
        fi

    # Knossos
        echo
        printf "${BLUE}Knossos${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/knossos /home/$USER/.config/"
        fi

    # RawTherapee
        echo
        printf "${BLUE}RawTherapee${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/RawTherapee /home/$USER/.config/"
        fi

    # BricsCAD
        echo
        printf "${BLUE}BricsCAD${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/BricsCAD /home/$USER/"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/var/bricsys /var/"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/opt/bricsys /opt/"
        fi

    # DosBox
        echo
        printf "${BLUE}DosBox${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.dosbox /home/$USER/"
        fi

    # Frictional Games
        echo
        printf "${BLUE}Frictional Games${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.frictionalgames /home/$USER/"
        fi

    # ThunderBird
        echo
        printf "${BLUE}ThunderBird${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.thunderbird /home/$USER/"
        fi

    # KiCAD
        echo
        printf "${BLUE}KiCAD${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/kicad /home/$USER/.config/"
        fi

    # gzdoom
        echo
        printf "${BLUE}gzdoom${NC}\n"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 ./Migration_$USER/root/home/$USER/.config/gzdoom /home/$USER/.config/"
        fi
        
    # Audacious
        echo
        printf "${BLUE}Audacious${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/audacious /home/$USER/.config/"
        fi

    # VLC
        echo
        printf "${BLUE}VLC${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/vlc /home/$USER/.config/"
        fi

    # Eclipse
        echo
        printf "${BLUE}Eclipse${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "mkdir -p /home/$USER/Programs/cpp-2020-06/eclipse/configuration/"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings /home/$USER/Programs/cpp-2020-06/eclipse/configuration/"
            
            cmd "mkdir -p /home/$USER/Projects/Eclipse/"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/Projects/Eclipse/.metadata /home/$USER/Projects/Eclipse/"
        fi

    # KATE
        echo
        printf "${BLUE}Kate${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/katerc /home/$USER/.config/"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/katesyntaxhighlightingrc /home/$USER/.config/"
        fi

    # Power Management Profile (KDE) (BACKUP)
        echo
        printf "${BLUE}Power Management (KDE)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.config/powermanagementprofilesrc /home/$USER/.config/powermanagementprofilesrc.bak"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/powermanagementprofilesrc /home/$USER/.config/"
        fi

    # Global Shortcuts (KDE) (BACKUP)
        echo
        printf "${BLUE}Global Shortcuts (KDE)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.config/kglobalshortcutsrc /home/$USER/.config/kglobalshortcutsrc.bak"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/kglobalshortcutsrc /home/$USER/.config/"
        fi

    # Plasma Settings (Panel, Notifications, Theme, Desktop Effects) (KDE) (BACKUP)
        echo
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
        echo
        printf "${BLUE}Login Scripts (.bashrc/.profile)${NC}"
        if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.bashrc /home/$USER/.bashrc.bak"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.bashrc /home/$USER/"
            
            #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.profile /home/$USER/.profile.bak"
            cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.profile /home/$USER/"
        fi
    fi












