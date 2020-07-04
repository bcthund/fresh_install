#!/bin/sh
    
# VPN
    printf "${BLUE}VPN...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/etc/NetworkManager/system-connections/ /etc/NetworkManager/system-connections/"
        #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/etc/NetworkManager/system-connections/Mikrotik_OVPN_Karen /etc/NetworkManager/system-connections/"
        #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/etc/NetworkManager/system-connections/MSELEC /etc/NetworkManager/system-connections/"
        #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/etc/NetworkManager/system-connections/.cert /etc/NetworkManager/system-connections/"
    fi

# Warzone 2100
    printf "${BLUE}Warzone2100...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/usr/share/games/warzone2100/ /usr/share/games/warzone2100/"
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.warzone2100-3.2/ /home/$USER/.warzone2100-3.2/"
    fi

# Knossos
    printf "${BLUE}Knossos...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/knossos/ /home/$USER/.config/knossos/"
    fi

# RawTherapee
    printf "${BLUE}RawTherapee...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/RawTherapee/ /home/$USER/.config/RawTherapee/"
    fi

# BricsCAD
    printf "${BLUE}BricsCAD...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/BricsCAD/ /home/$USER/BricsCAD/"
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/var/bricsys/ /var/bricsys/"
        #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/var/bricsys/BricsCAD_ShapeV18.lic /var/bricsys/"
        #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/var/bricsys/BricsCADV17.lic /var/bricsys/"
        #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/var/bricsys/BricsCADV18.lic /var/bricsys/"
        #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/var/bricsys/BricsCADV20.lic /var/bricsys/"
        #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/var/bricsys/CommunicatorV18.lic /var/bricsys/"
        
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/opt/bricsys/ /opt/bricsys/"
        #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/opt/bricsys/bricscad/v18/RenderMaterialStatic/ /opt/bricsys/bricscad/v20/"
        #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/opt/bricsys/communicator /opt/bricsys/"
    fi

# DosBox
    printf "${BLUE}DosBox...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.dosbox/ /home/$USER/.dosbox/"
    fi

# Frictional Games
    printf "${BLUE}Frictional Games...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.frictionalgames/ /home/$USER/.frictionalgames/"
    fi

# ThunderBird
    printf "${BLUE}ThunderBird...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.thunderbird/ /home/$USER/.thunderbird/"
        #cmd "mkdir -p /home/$USER/.thunderbird"
        #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.thunderbird/profiles.ini /home/$USER/.thunderbird/"
        #cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.thunderbird/eu3c43qa.default /home/$USER/.thunderbird/"
        #cmd "sudo chown -R $USER:$USER /home/$USER/.thunderbird"
    fi

# KiCAD
    printf "${BLUE}KiCAD...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/kicad/ /home/$USER/.config/kicad/"
    fi

# gzdoom (handled in gzdoom.sh now)
    #printf "${BLUE}gzdoom...${NC}"
    #if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    #if [ "$answer2" != "${answer2#[Yy]}" ] ;then
    #    cmd "gzdoom -norun"
    #    cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/snap/gzdoom/current/.config/gzdoom/ /home/$USER/snap/gzdoom/current/.config/"
    #fi

# Audacious
    printf "${BLUE}Audacious...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/audacious/ /home/$USER/.config/audacious/"
    fi

# VLC
    printf "${BLUE}VLC...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/vlc/ /home/$USER/.config/vlc/"
    fi

# Eclipse
    printf "${BLUE}Eclipse...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings/ /home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings/"
        #cmd "mkdir -p /home/$USER/Projects/Eclipse/"
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/Projects/Eclipse/.metadata/ /home/$USER/Projects/Eclipse/.metadata/"
    fi

# KATE
    printf "${BLUE}Kate...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/katerc /home/$USER/.config/katerc"
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/katesyntaxhighlightingrc /home/$USER/.config/katesyntaxhighlightingrc"
    fi

# Power Management Profile (KDE) (BACKUP)
    printf "${BLUE}Power Management (KDE)...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.config/powermanagementprofilesrc /home/$USER/.config/powermanagementprofilesrc.bak"
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/powermanagementprofilesrc /home/$USER/.config/powermanagementprofilesrc"
    fi

# Global Shortcuts (KDE) (BACKUP)
    printf "${BLUE}Global Shortcuts (KDE)...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.config/kglobalshortcutsrc /home/$USER/.config/kglobalshortcutsrc.bak"
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/kglobalshortcutsrc /home/$USER/.config/kglobalshortcutsrc"
    fi

# Plasma Settings (Panel, Notifications, Theme, Desktop Effects) (KDE) (BACKUP)
    printf "${BLUE}Plasma Settings (KDE)...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc.bak"
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc"
        
        cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.config/plasmanotifyrc /home/$USER/.config/plasmanotifyrc.bak"
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/plasmanotifyrc /home/$USER/.config/plasmanotifyrc"
        
        cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.config/plasmarc /home/$USER/.config/plasmarc.bak"
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/plasmarc /home/$USER/.config/plasmarc"
        
        cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.config/kwinrc /home/$USER/.config/kwinrc.bak"
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.config/kwinrc /home/$USER/.config/kwinrc"
    fi

# Login scripts (.bashr/.profile) (BACKUP)
    printf "${BLUE}Login Scripts (.bashrc/.profile)...${NC}"
    if [ "$answer" != "${answer#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.bashrc /home/$USER/.bashrc.bak"
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.bashrc /home/$USER/.bashrc"
        
        cmd "sudo rsync -aR --info=progress2 --delete /home/$USER/.profile /home/$USER/.profile.bak"
        cmd "sudo rsync -aR --info=progress2 --delete ./Migration_$USER/root/home/$USER/.profile /home/$USER/.profile"
    fi












