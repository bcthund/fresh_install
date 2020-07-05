#!/bin/sh
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
    echo "${RED}DEBUG: Commands will be echoed to console${NC}"
else
    cmd(){ eval $1; }
    echo "${RED}LIVE: Actions will be performed! Use caution.${NC}"
fi

dl(){ cmd "gdown https://drive.google.com/uc?id=$1"; }

echo
echo "${grey}This script will downlaod the fresh_install files as well as${NC}"
echo "${grey}give you the option to downlaod additional source installers${NC}"
echo "${grey}that I have written including:${NC}"
echo "${grey}\tFresh Install:${NC}"
echo "${grey}\t  - backup.sh${NC}"
echo "${grey}\t  - restore.sh${NC}"
echo "${grey}\t  - Apps:${NC}"
echo "${grey}\t    - Bricscad v20.2.08${NC}"
echo "${grey}\t    - Camotics v1.2.0${NC}"
echo "${grey}\t    - Chrome${NC}"
echo "${grey}\t    - Brother printer installer v2.2.2.1${NC}"
echo "${grey}\t    - Multisystem${NC}"
echo "${grey}\t    - NoMachine v6.11.2${NC}"
echo "${grey}\t    - Steam${NC}"
echo "${grey}\t    - Eclipse v2020-06${NC}"
echo "${grey}\t    - Plasmoids${NC}"
echo "${grey}\tSource Installs:${NC}"
echo "${grey}\t  - knossos${NC}"
echo "${grey}\t  - qucs${NC}"
echo "${grey}\t  - valkyrie${NC}"
echo "${grey}\t  - gzdoom${NC}"
echo "${grey}\t    - Addons:${NC}"
echo "${grey}\t      - High res textures${NC}"
echo "${grey}\t      - Remastered music${NC}"
echo "${grey}\t      - Brutal Doom${NC}"
echo "${grey}\t      - gzdoom.ini${NC}"
#echo "${grey}\t- flatcam${NC}"
#echo "${grey}\t\t- ${NC}"
#echo "${grey}${NC}"
echo
echo -n "${BLUE}Do you want to download installs ${GREEN}(y/n)? ${NC}"
read mode
#cmd "mkdir -p ./tmp/"
#cmd "cd tmp"
if [ "$mode" != "${mode#[Yy]}" ] ;then
    printf "${BLUE}fresh install scripts (will update all scripts)${NC}"
    echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/fresh_install.git"
        cmd "mv ./fresh_install/*.sh ./"
        cmd "rm -rf ./fresh_install"
    fi

    printf "${BLUE}gzdoom${NC}"
    echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/gzdoom_installer.git"
        cmd "rm -rf ./gzdoom_installer/.git"
        printf "${BLUE}Addons (Will also install pip3 and gdown)${NC}"
        echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
            cmd "sudo apt -y install python3-pip"
            cmd "pip3 install gdown"
            dl "1xYo4_OEfLFkCZ7vyHQTBPJ2yC10h0g5g"
            cmd "unzip Addons.zip -o -d ./gzdoom_installer/" 
        fi
        cmd "mv ./gzdoom_installer/* ./"
        cmd "rm -rf ./gzdoom_installer"
    fi
    
    printf "${BLUE}knossos${NC}"
    echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/knossos_installer.git"
        cmd "rm -rf ./knossos_installer/.git"
        cmd "mv ./knossos_installer/* ./"
        cmd "rm -rf ./knossos_installer"
    fi
    
    printf "${BLUE}qucs${NC}"
    echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/qucs_installer.git"
        cmd "rm -rf ./qucs_installer/.git"
        cmd "mv ./qucs_installer/* ./"
        cmd "rm -rf ./qucs_installer"
    fi
    
    printf "${BLUE}valkyrie${NC}"
    echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/valkyrie_installer.git"
        cmd "rm -rf ./valkyrie_installer/.git"
        cmd "mv ./valkyrie_installer/* ./"
        cmd "rm -rf ./valkyrie_installer"
    fi
    
    printf "${BLUE}Apps (Will also install pip3 and gdown)${NC}"
    echo "${grey}\t- Bricscad v20.2.08${NC}"
    echo "${grey}\t- Camotics v1.2.0${NC}"
    echo "${grey}\t- Chrome${NC}"
    echo "${grey}\t- Brother printer installer v2.2.2.1${NC}"
    echo "${grey}\t- Multisystem${NC}"
    echo "${grey}\t- NoMachine v6.11.2${NC}"
    echo "${grey}\t- Steam${NC}"
    echo "${grey}\t- Eclipse v2020-06${NC}"
    echo "${grey}\t- Plasmoids${NC}"
    echo -n "${GREEN}Continue (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
        cmd "sudo apt -y install python3-pip"
        cmd "pip3 install gdown"
        dl "1wcCso1e16rusFrnEZq035Xu-wKf99ZyH"
        cmd "unzip -o Apps.zip"
    fi

#cmd "cd ${working_dir}"
    
#     printf "${BLUE}${NC}"
#     echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
#         cmd ""
#     fi
fi
