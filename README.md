# fresh_install
## Description
This is a script I created for a system restore procedure during a fresh install.

## Usage
```chmod +x fresh_install.sh```  
<br>
<u>**Live run:**</u>  
This will prompt you with a series of questions and perform the actions, making changes to your filesystem.  
```./fresh_install.sh```  
<br>
<u>**Debug:**</u>  
This will prompt you with a series of questions but will not actually perform them. It will echo the command that would be run so you can do a dry run first.  
```./fresh_install.sh debug```

## Drive Structure
The drive mapping is important for backup and restore procedures, espectially the symlinks. It does not prevent the script from working in general but the symlinks should not be used if the drive structure is different. This is for reference on how the script was written, see the `Symlinks` section below for details on how the drives are used with the symlinks.<br>

| Device | Mount | Size |
| :-- | :--- | :-- |
| sda1   | efi        | 200 MB    |
| sda2   | /          | 97.66 GB  |
| sda3   | /home      | 848.2 GB  |
| sda4   | swap       | 7.81 GB   |
| sdb1   | ~/Games    | 238.47 GB |
| sdd1   | ~/OneDrive | 931.51 GB |

## Symlinks
Links to folders that I keep on separate hard drives so they aren't tied to the true drive for the home directory. These folders have configuration files, templates, or plugins that I wanted to never go away if something happened to the drive that `/home` is mounted with. 

Some of these are outdated and could be transferred to the migration script instead but I haven't made that change yet.<br>

The OneDrive mount has the most free space so that is tied to folders that typically take more space and have data that is most likely to get saved such as Documents, Pictures, Music, Videos, etc.

| Src | Dst |
| :-- | :--- |
| ~/OneDrive/Documents | ~/Documents |
| ~/OneDrive/Music | ~/Music |
| ~/OneDrive/Pictures | ~/Pictures |
| ~/OneDrive/Templates | ~/Templates |
| ~/OneDrive/Videos | ~/Videos |
| ~/OneDrive/.bricscad | ~/.bricscad |
| ~/OneDrive/.eve | ~/.eve |
| ~/OneDrive/.FreeCAD | ~/.FreeCAD |
| ~/OneDrive/.minecraft | ~/.minecraft |
| ~/OneDrive/.PlayOnLinux | ~/.PlayOnLinux |
| ~/OneDrive/Bricsys | ~/Bricsys |
| ~/OneDrive/octave | ~/octave |
| ~/OneDrive/PlayOnLinux's virtual drives | ~/PlayOnLinux's virtual drives |
| ~/OneDrive/Programs | ~/Programs |
| ~/OneDrive/Projects | ~/Projects |
| ~/Games/.steam | ~/.steam |
| ~/Games/Steam | ~/.local/share/Steam |


## Packages
These are all of my preferred applications to have installed.
<pre>
  arandr
  audacious
  audacity
  baobab
  blender
  brasero
  cecilia
  chromium-browser
  cifs-utils
  devede
  dia
  dosbox
  easytag
  exfat-utils
  ext4magic
  fluidsynth
  fontforge
  freecad
  g++-8
  ghex
  gimp
  gimp-gmic
  gimp-plugin-registry
  git
  git-lfs
  glade
  glmark2
  gmic
  gpick
  hardinfo
  inkscape
  inxi
  iptraf
  kdevelop
  kicad
  kicad-footprints
  kicad-packages3d
  kicad-symbols
  kicad-templates
  kompare
  krita
  libdvd-pkg
  libdvdnav4
  libdvdread7
  libnoise-dev
  libsdl2-dev
  libsdl2-image-dev
  libsdl2-mixer-dev
  libsdl2-net-dev
  lmms
  mesa-utils
  neofetch
  net-tools
  network-manager-openconnect
  network-manager-openvpn
  network-manager-ssh
  nfs-common
  nfs-kernel-server
  nmap
  octave
  openconnect
  openjdk-8-jre
  openshot
  openssh-server
  openvpn
  pithos
  playonlinux
  python3-pip
  qt5-default
  qtcreator
  qtdeclarative5-dev
  rawtherapee
  remmina
  rename
  samba
  scummvm
  smb4k
  solaar
  texlive-fonts-extra
  texlive-fonts-recommended
  texlive-xetex
  texstudio
  tilix
  thunderbird
  ubuntu-restricted-extras
  valgrind
  veusz
  vim
  virtualbox
  vlc
  vlc-plugin-access-extra
  vlc-plugin-fluidsynth
  vlc-plugin-samba
  vlc-plugin-skins2
  vlc-plugin-visualization
  warzone2100
  whois
  winff
  wireshark
  xrdp
  xterm
</pre>

## PPA
Packages that need PPAs added before they can be installed, which is actually the very first step in the script.
<pre>
  x-tile
</pre>

## PIP
Python pip3 packages which can't be installed until python3-pip has been installed
<pre>
  bCNC
</pre>

## Snap
Some packages that can only be installed with snap, which I don't care for (see [gzdoom_installer](https://github.com/bcthund/gzdoom_installer)) but easier than installing by source if they work.
<pre>
  ckan
  shotcut
  sublime-text
</pre>

## Plasmoid
Plasmoids are KDE widgets, so if I find ones I like I can download the install file and make sure it gets reinstalled. This is especially important when restoring the plasma panels if they have an y of these widgets on them.
<pre>
  places-widget-1.3.plasmoid
</pre>

## Download
Some programs are best installed from their deb package
<pre>
  BricsCAD
  Camotics
  Google Chrome
  NoMachine
  Steam
  Multisystem
  Eclipse
</pre>

## Source
When all else fails, I have developed a method of stepping through the process of compiling from source including the option to pull the latest source. If the latest source doesn't work then you can use the included snapshot used when the scripts were written.
See also: [gzdoom_installer](https://github.com/bcthund/gzdoom_installer), [knossos_installer](https://github.com/bcthund/knossos_installer), [qucs_installer](https://github.com/bcthund/qucs_installer)
<pre>
  gzdoom
  knossos
  qucs
  flatcam (in porogress)
  valkyrie (in progress)
</pre>

## Additional Configuration
Other things that don't include migration or installation.
<pre>
  Add user to vboxusers group for virtualbox
  Create Samba password for access to Samba shares on this pc
  Create standard NFS shares and mount standard shares
</pre>

## Custom Migration
The custom migration actually includes a backup portion of the script that can be run before reinstalling the OS to backup configuration files and resources. All of the items on this list are put into a Migration_$USER folder and used to then restore all them as the last step of the script.
<pre>
  VPN configurations and certificates
  Warzone2100sequences and save games
  Knossos configuration (installed games are kept on ~/Games drive)
  RawTherapee configuration
  BricsCAD licenses, communicator, render materials
  DosBox configuration
  Frictional games installation
  Thunderbird profile and configuration including installed addons
  KiCAD configuration
  Audacious configuration
  VLC configuration
  Eclipse configuration (workspace) and preferences (including workspace directory setting)
  Kate configuration
  Power management profile (KDE)
  Global shortcuts (KDE)
  Plasma settings including panel layout, notifications, theme, desktop effects
  Login scripts (.bashrc and .profile, because sometimes they are broken after fresh install)
</pre>

## Manual Items 
There are a few items that can't be done by script or I haven't looked into doing them by script. So there is a message at the end of the `fresh_install.sh` script specifying these items as a reminder to myself of what still needs to be done.
<pre>
  Migrate keyrings
  Install plasma-chrome integration
  Virtualbox extensions
  NVidia drivers
  Generate xorg.conf with nvidia-settings
</pre>























