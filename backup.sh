#!/bin/sh
echo
echo "${PURPLE}==========================================================================${NC}"
echo "${PURPLE}\tPerforming Backup${NC}"
echo "${PURPLE}--------------------------------------------------------------------------${NC}"

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

# Keyring
    echo
    echo "${BLUE}Keyring${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.local/share/kwalletd/ ./Migration_$USER/root/"

# NoMachine (NX)
    echo
    echo "${BLUE}NoMachine (NX)${NC}"
    cmd "sudo rsync -aR --info=progress2 /usr/NX/etc/server.cfg ./Migration_$USER/root/"
    
# VPN
    echo
    echo "${BLUE}VPNs${NC}"
    cmd "sudo rsync -aR --info=progress2 /etc/NetworkManager/system-connections/ ./Migration_$USER/root/"
    #cmd "sudo rsync -aR --info=progress2 /etc/NetworkManager/system-connections/Mikrotik_OVPN_Home2 ./Migration_$USER/root/"
    #cmd "sudo rsync -aR --info=progress2 /etc/NetworkManager/system-connections/Mikrotik_OVPN_Karen ./Migration_$USER/root/"
    #cmd "sudo rsync -aR --info=progress2 /etc/NetworkManager/system-connections/MSELEC ./Migration_$USER/root/"
    #cmd "sudo rsync -aR --info=progress2 /etc/NetworkManager/system-connections/.cert ./Migration_$USER/root/"

# Warzone 2100
    echo
    echo "${BLUE}Warzone 2100${NC}"
    cmd "sudo rsync -aR --info=progress2 /usr/share/games/warzone2100/sequences.wz ./Migration_$USER/root/"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.warzone2100-3.2 ./Migration_$USER/root/"

# Knossos
    echo
    echo "${BLUE}Knossos${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/knossos ./Migration_$USER/root/"

# RawTherapee
    echo
    echo "${BLUE}RawTherapee${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/RawTherapee ./Migration_$USER/root/"

# BricsCAD
    echo
    echo "${BLUE}BricsCAD${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/BricsCAD ./Migration_$USER/root/"
    cmd "sudo rsync -aR --info=progress2 /var/bricsys/ ./Migration_$USER/root/"
    #cmd "sudo rsync -aR --info=progress2 /var/bricsys/BricsCAD_ShapeV18.lic ./Migration_$USER/root/"
    #cmd "sudo rsync -aR --info=progress2 /var/bricsys/BricsCADV17.lic ./Migration_$USER/root/"
    #cmd "sudo rsync -aR --info=progress2 /var/bricsys/BricsCADV18.lic ./Migration_$USER/root/"
    #cmd "sudo rsync -aR --info=progress2 /var/bricsys/BricsCADV20.lic ./Migration_$USER/root/"
    #cmd "sudo rsync -aR --info=progress2 /var/bricsys/CommunicatorV18.lic ./Migration_$USER/root/"
    cmd "sudo rsync -aR --info=progress2 /opt/bricsys/bricscad/v20/RenderMaterialStatic ./Migration_$USER/root/"
    cmd "sudo rsync -aR --info=progress2 /opt/bricsys/communicator ./Migration_$USER/root/"

# DosBox
    echo
    echo "${BLUE}DosBox${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.dosbox ./Migration_$USER/root/"

# Frictional Games
    echo
    echo "${BLUE}Frictional Games${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.frictionalgames ./Migration_$USER/root/"

# ThunderBird
    echo
    echo "${BLUE}ThunderBird${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.thunderbird/ ./Migration_$USER/root/"
    #cmd "sudo rsync -aR --info=progress2 /home/$USER/.thunderbird/profiles.ini ./Migration_$USER/root/"
    #cmd "sudo rsync -aR --info=progress2 /home/$USER/.thunderbird/eu3c43qa.default ./Migration_$USER/root/"

# KiCAD
    echo
    echo "${BLUE}KiCAD${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kicad ./Migration_$USER/root/"

# gzdoom
    echo
    echo "${BLUE}gzdoom${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/gzdoom ./Migration_$USER/root/"

# Audacious
    echo
    echo "${BLUE}Audacious${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/audacious ./Migration_$USER/root/"

# VLC
    echo
    echo "${BLUE}VLC${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/vlc ./Migration_$USER/root/"

# Eclipse
    echo
    echo "${BLUE}Eclipse${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/Programs/cpp-2020-06/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs ./Migration_$USER/root/"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/Projects/Eclipse/.metadata ./Migration_$USER/root/"

# KATE
    echo
    echo "${BLUE}KAte${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/katerc ./Migration_$USER/root/"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/katesyntaxhighlightingrc ./Migration_$USER/root/"

# Power Management Profile (KDE) (BACKUP)
    echo
    echo "${BLUE}Power Management${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/powermanagementprofilesrc ./Migration_$USER/root/"

# Global Shortcuts (KDE) (BACKUP)
    echo
    echo "${BLUE}Global Shortcuts${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kglobalshortcutsrc ./Migration_$USER/root/"

# Plasma Settings (Panel, Notifications, Theme, Desktop Effects) (KDE) (BACKUP)
    echo
    echo "${BLUE}Plasma Settings${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasma-org.kde.plasma.desktop-appletsrc ./Migration_$USER/root/"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasmanotifyrc ./Migration_$USER/root/"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/plasmarc ./Migration_$USER/root/"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.config/kwinrc ./Migration_$USER/root/"

# Login scripts (.bashr/.profile) (BACKUP)
    echo
    echo "${BLUE}Login Scripts${NC}"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.bashrc ./Migration_$USER/root/"
    cmd "sudo rsync -aR --info=progress2 /home/$USER/.profile ./Migration_$USER/root/"
    
# symlinks (predetermined list)
    echo
    echo "${BLUE}Symlinks${NC}"
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











