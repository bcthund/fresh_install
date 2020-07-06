#!/bin/sh
    
# Keyring
    printf "${BLUE}Keyring${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.local/share/kwalletd /home/$USER/.local/share/"
    fi

# NoMachine (NX)
    echo "${BLUE}NoMachine (NX)${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "mkdir -p /usr/NX/etc/"
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/usr/NX/etc/server.cfg /usr/NX/etc/"
    fi
    
# VPN
    printf "${BLUE}VPN${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/etc/NetworkManager/system-connections /etc/NetworkManager/"
    fi

# Warzone 2100
    printf "${BLUE}Warzone2100${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/usr/share/games/warzone2100 /usr/share/games/"
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.warzone2100-3.2 /home/$USER/"
    fi

# Knossos
    printf "${BLUE}Knossos${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/knossos /home/$USER/.config/"
    fi

# RawTherapee
    printf "${BLUE}RawTherapee${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/RawTherapee /home/$USER/.config/"
    fi

# BricsCAD
    printf "${BLUE}BricsCAD${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/BricsCAD /home/$USER/"
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/var/bricsys /var/"
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/opt/bricsys /opt/"
    fi

# DosBox
    printf "${BLUE}DosBox${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.dosbox /home/$USER/"
    fi

# Frictional Games
    printf "${BLUE}Frictional Games${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.frictionalgames /home/$USER/"
    fi

# ThunderBird
    printf "${BLUE}ThunderBird${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.thunderbird /home/$USER/"
    fi

# KiCAD
    printf "${BLUE}KiCAD${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/kicad /home/$USER/.config/"
    fi

# gzdoom
    echo
    echo "${BLUE}gzdoom${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -a --info=progress2 ./Migration_$USER/root/home/$USER/.config/gzdoom /home/$USER/.config/"
    fi
    
# Audacious
    printf "${BLUE}Audacious${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/audacious /home/$USER/.config/"
    fi

# VLC
    printf "${BLUE}VLC${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/vlc /home/$USER/.config/"
    fi

# Eclipse
    printf "${BLUE}Eclipse${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "mkdir -p /home/$USER/Programs/cpp-2020-06/eclipse/configuration/"
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings /home/$USER/Programs/cpp-2020-06/eclipse/configuration/"
        
        cmd "mkdir -p /home/$USER/Projects/Eclipse/"
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/Projects/Eclipse/.metadata /home/$USER/Projects/Eclipse/"
    fi

# KATE
    printf "${BLUE}Kate${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/katerc /home/$USER/.config/"
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/katesyntaxhighlightingrc /home/$USER/.config/"
    fi

# Power Management Profile (KDE) (BACKUP)
    printf "${BLUE}Power Management (KDE)${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.config/powermanagementprofilesrc /home/$USER/.config/powermanagementprofilesrc.bak"
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/powermanagementprofilesrc /home/$USER/.config/"
    fi

# Global Shortcuts (KDE) (BACKUP)
    printf "${BLUE}Global Shortcuts (KDE)${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.config/kglobalshortcutsrc /home/$USER/.config/kglobalshortcutsrc.bak"
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/kglobalshortcutsrc /home/$USER/.config/"
    fi

# Plasma Settings (Panel, Notifications, Theme, Desktop Effects) (KDE) (BACKUP)
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
    printf "${BLUE}Login Scripts (.bashrc/.profile)${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.bashrc /home/$USER/.bashrc.bak"
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.bashrc /home/$USER/"
        
        #cmd "sudo rsync -a --info=progress2 --delete /home/$USER/.profile /home/$USER/.profile.bak"
        cmd "sudo rsync -a --info=progress2 --delete ./Migration_$USER/root/home/$USER/.profile /home/$USER/"
    fi












