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
echo -n "${BLUE}Do you want to download installs ${GREEN}(y/n/a)? ${NC}"
read mode
#cmd "mkdir -p ./tmp/"
#cmd "cd tmp"
if [ "$mode" != "${mode#[Yy]}" ] || [ "$mode" != "${mode#[Aa]}" ] ;then
    if [ "$mode" != "${mode#[Aa]}" ] ;then answer2="y"; else answer2=""; fi

    printf "${BLUE}fresh install scripts (will update all scripts)${NC}"
    if [ "$mode" != "${mode#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/fresh_install.git"
        cmd "rsync -a ./fresh_install/*.sh ./"
        cmd "rm -rf ./fresh_install"
    fi

    printf "${BLUE}gzdoom${NC}"
    if [ "$mode" != "${mode#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/gzdoom_installer.git"
        cmd "rm -rf ./gzdoom_installer/.git"
        cmd "rm ./gzdoom_installer/*.md"
        printf "${BLUE}Addons (Will also install pip3 and gdown)${NC}"
        if [ "$mode" != "${mode#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            cmd "sudo apt -qy install python3-pip"
            cmd "pip3 install gdown"
            dl "1xYo4_OEfLFkCZ7vyHQTBPJ2yC10h0g5g"
            cmd "unzip -o Addons.zip -d ./gzdoom_installer/" 
            cmd "rm Addons.zip"
        fi
        #cmd "mv ./gzdoom_installer/* ./"
        cmd "rsync -a ./gzdoom_installer/ ./"
        cmd "rm -rf ./gzdoom_installer"
    fi
    
    printf "${BLUE}knossos${NC}"
    if [ "$mode" != "${mode#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/knossos_installer.git"
        cmd "rm -rf ./knossos_installer/.git"
        cmd "rm ./knossos_installer/*.md"
        #cmd "mv ./knossos_installer/* ./"
        cmd "rsync -a ./knossos_installer/ ./"
        cmd "rm -rf ./knossos_installer"
    fi
    
    printf "${BLUE}qucs${NC}"
    if [ "$mode" != "${mode#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/qucs_installer.git"
        cmd "rm -rf ./qucs_installer/.git"
        cmd "rm ./qucs_installer/*.md"
        #cmd "mv ./qucs_installer/* ./"
        cmd "rsync -a ./qucs_installer/ ./"
        cmd "rm -rf ./qucs_installer"
    fi
    
    printf "${BLUE}valkyrie${NC}"
    if [ "$mode" != "${mode#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/valkyrie_installer.git"
        cmd "rm -rf ./valkyrie_installer/.git"
        cmd "rm ./valkyrie_installer/*.md"
        #cmd "mv ./valkyrie_installer/* ./"
        cmd "rsync -a ./valkyrie_installer/ ./"
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
    if [ "$mode" != "${mode#[Yy]}" ] ;then printf "${GREEN}Continue (y/n)? ${NC} "; read answer2; else echo; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "sudo apt -qy install python3-pip"
        cmd "pip3 install gdown"
        dl "1wcCso1e16rusFrnEZq035Xu-wKf99ZyH"
        cmd "unzip -o Apps.zip"
        cmd "rm Apps.zip"
    fi
    
    echo
    echo "${BLUE}All Done!${NC}"
    echo "${YELLOW}Run 'fresh_install.sh' to Backup or Restore as well as install programs.${NC}"
    echo "${YELLOW}Alternatively run 'backup.sh' to perform a system backup right now.${NC}"
    echo "${YELLOW}Alternatively run 'restore.sh' to perform only a restore of a prvious backup.${NC}"

#cmd "cd ${working_dir}"
    
#     printf "${BLUE}${NC}"
#     echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$mode" != "${mode#[Yy]}" ] ;then
#         cmd ""
#     fi
fi
