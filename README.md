# fresh_install
## Description
This is a script I created for a system restore procedure during a fresh install. It was initally created for an upgrade from Ubuntu 18.04 to Kubuntu 20.04 and then modified to backup and restore from and to Kubuntu 20.04. It works in conjuction with several other scripts for installing from source and installing downloaded applications. The script can be easily modified to add and remove applications and packages as needed. You can download the applications the script was designed to work with below as well as the additional script for source installations.

  * [gzdoom_installer](https://github.com/bcthund/gzdoom_installer "Install from Source")
    - [Addons](https://drive.google.com/file/d/1xYo4_OEfLFkCZ7vyHQTBPJ2yC10h0g5g/view?usp=sharing "Download from Google Drive")
  * [knossos_installer](https://github.com/bcthund/knossos_installer "Install from Source")
  * [qucs_installer](https://github.com/bcthund/qucs_installer "Install from Source")
  * flatcam (in progress)
  * [valkyrie](https://github.com/bcthund/valkyrie_installer "Install from Source")
  * [Apps](https://drive.google.com/file/d/1wcCso1e16rusFrnEZq035Xu-wKf99ZyH/view?usp=sharing "Download from Google Drive")

## Usage
### fresh_install.sh
<pre>
Usage: fresh_install.sh &lt;options&gt;

This script is intended to be run on an existing installation to backup some important user
data or software settings. The script is then intended to be run on a fresh installation
(hence the name of the script) to reinstall typical applications and restore the backups.

Options:
  -h, --help            show this help message and exit
  -v, --verbose         print commands being run before running them
  -d, --debug           print commands to be run but do not execute them
  -z, --zip             Backup: compress the backup and remove backup folder
                        Restore: the backup is compressed (hint)
  -x                    Backup: do not compress backup folder
                        Restore: the backup is not compressed (hint)
  --in-testing          Enable use of in-testing features (nothing currently in testing)
  --tmp=DIRECTORY       do not extract archive, use this tmp directory
  --dir=DIRECTORY       specify the backup directory to override './Migration_$USER'
  --archive=FILE        specify the backup archive to override './Migration_$USER.tar.gz'
  --step=STEP           jump to an install step then exit when complete
  --continue=STEP       jump to an install step and continue to remaining steps

Available STEP Options:
                        start          same as starting without a STEP option
                        uncompress     extract the contents of a backup
                        backup         perform a system backup
                        download       download/update install scripts, apps, source installs. Always exits
                        symlinks       install symlinks from a system backup
                        nosnap         remove snap packages from system (in testing)
                        upgrade        perform a system upgrade, and purge apport if desired
                        nvidia         install latest nvidia driver (440) (in testing)
                        packages       install apt packages including some dependencies for other steps
                        ppa_package    install packages requiring additional PPAs
                        pip            install pip3 packages
                        snap           install snap packages
                        plasmoid       install plasma plasmoids
                        downloads      install downloaded applications
                        source         install applications from source
                        config         perform some additional configuration, not including NFS shares
                        nfs            setup some standard NFS shares and/or attach media server shares
                        restore        perform a system restore from a previous backup
                        cleanup        runs apt autoremove for lingering packages
</pre>

### downlaod.sh
<pre>
Usage: download.sh &lt;options&gt;

Options:
  -h, --help            show this help message and exit
  -v, --verbose         print commands being run before running them
  -y, --yes             answer yes to all
  -d, --debug           print commands to be run but do not execute them
  --in-testing          Enable use of in-testing features
  --step=STEP           jump to an install step then exit when complete
  --continue=STEP       jump to an install step and continue to remaining steps
  --restart=MODE        this is used to restart the script after downloading updated scripts
                        and will skip the step asking to download updated scripts. Under normal
                        circumstances this should not be used.

Available STEP Options:
                        start     same as starting without a STEP option
                        update    update fresh install scripts
                        gzdoom    download gzdoom install files
                        knossos   download knosso install files
                        qucs      download qucs install files
                        valkyrie  download valkyrie install files
                        apps      download Apps.zip and extract

Available MODE Options:
                        y  answers yes to downloading installs (all steps will be confirmed)
                        n  answers no to downloading installs (script will simply exit)
                        a  answers all to downloading installs (all steps will automatically execute)
</pre>

### backup.sh
<pre>
Usage: backup.sh &lt;options&gt;

Options:
  -h, --help            show this help message and exit
  -v, --verbose         print commands being run before running them
  -d, --debug           print commands to be run but do not execute them
  -y, --yes             answer yes to all, except compress
  -z, --zip             compress the backup and remove backup folder (this is default behavior now)
  -x                    do not compress backup folder, folder remains in tmp directory
  --in-testing          Enable use of in-testing features
  --dir=DIRECTORY       specify the backup directory to override './Migration_$USER'
  --archive=FILE        specify the backup archive to override './Migration_$USER.tar.gz'
  --step=STEP           jump to an install step then exit when complete
  --continue=STEP       jump to an install step and continue to remaining steps

Available STEP Options:
                        layout
                        desktop
                        menuentries
                        icons
                        keyring
                        nomachine
                        network
                        warzone2100
                        knossos
                        rawtherapee
                        bricscad
                        dosbox
                        friction
                        thunderbird
                        kicad
                        gzdoom
                        audacious
                        vlc
                        eclipse
                        kate
                        power
                        shortcuts
                        plasma
                        login
                        symlinks
                        compress
</pre>

### restore.sh
<pre>
Usage: restore.sh &lt;options&gt;

Options:
  -h, --help            show this help message and exit
  -v, --verbose         print commands being run before running them
  -d, --debug           print commands to be run but do not execute them
  -y, --yes             answer yes to all
  --in-testing          Enable use of in-testing features
  --tmp=DIRECTORY       do not extract archive, use this tmp directory
  --dir=DIRECTORY       specify the backup directory to override 'Migration_$USER'
  --archive=FILE        specify the backup archive to override 'Migration_$USER.tar.gz'
                           Note: Archive is used in fresh_install.sh, not here.
                                 This is here just in case it is needed in the future.
  --step=STEP           jump to an install step then exit when complete
  --continue=STEP       jump to an install step and continue to remaining steps

Available STEP Options:
                        extract
                        desktop
                        menuentries
                        icons
                        keyring
                        nomachine
                        network
                        warzone2100
                        knossos
                        rawtherapee
                        bricscad
                        dosbox
                        friction
                        thunderbird
                        kicad
                        gzdoom
                        audacious
                        vlc
                        eclipse
                        kate
                        power
                        shortcuts
                        plasma
                        login
                        cleanup
</pre>

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
<pre>
  gzdoom
  knossos
  qucs
  flatcam (in porogress)
  valkyrie (in progress)
</pre>
See also:
  * [gzdoom_installer](https://github.com/bcthund/gzdoom_installer "Install from Source")
  * [knossos_installer](https://github.com/bcthund/knossos_installer "Install from Source")
  * [qucs_installer](https://github.com/bcthund/qucs_installer "Install from Source")
  * [valkyrie](https://github.com/bcthund/valkyrie_installer "Install from Source")
  * flatcam (in porogress)

## Additional Configuration
Other things that don't include migration or installation.

  * Add user to vboxusers group for virtualbox
  * Create Samba password for access to Samba shares on this pc
  * Check for libGL.so links (I had them dissapear at one point, so lets check)
  * Create standard NFS shares and mount standard shares

## Custom Migration
The custom migration actually includes a backup portion of the script that can be run before reinstalling the OS to backup configuration files and resources. All of the items on this list are put into a Migration_$USER folder and used to then restore all them as the last step of the script.
  * VPN configurations and certificates
  * Warzone2100sequences and save games
  * Knossos configuration (installed games are kept on ~/Games drive)
  * RawTherapee configuration
  * BricsCAD licenses, communicator, render materials
  * DosBox configuration
  * Frictional games installation
  * Thunderbird profile and configuration including installed addons
  * KiCAD configuration
  * Audacious configuration
  * VLC configuration
  * Eclipse configuration (workspace) and preferences (including workspace directory setting)
  * Kate configuration
  * Power management profile (KDE)
  * Global shortcuts (KDE)
  * Plasma settings including panel layout, notifications, theme, desktop effects
  * Login scripts (.bashrc and .profile, because sometimes they are broken after fresh install)

## Manual Items 
There are a few items that can't be done by script or I haven't looked into doing them by script. So there is a message at the end of the `fresh_install.sh` script specifying these items as a reminder to myself of what still needs to be done.
  * Migrate keyrings
  * Install plasma-chrome integration
  * Virtualbox extensions
  * NVidia drivers
  * Generate xorg.conf with nvidia-settings






















