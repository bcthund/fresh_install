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
GOTOSTEP=false
GOTOCONTINUE=false
GOTO=""
RESTART=false
#RESTARTMODE=""
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
        echo -e "Usage: $0 <options>"
        echo -e
        echo -e "Options:"
        echo -e "  -h, --help            show this help message and exit"
        echo -e "  -v, --verbose         print commands being run before running them"
        echo -e "  -d, --debug           print commands to be run but do not execute them"
        echo -e "  --step=STEP           jump to an install step then exit when complete"
        #echo -e "  --continue=STEP       jump to an install step and continue to remaining steps"
        echo -e "  --restart=MODE        this is used to restart the script after downloading updated scripts"
        echo -e "                        and will skip the step asking to download updated scripts. Under normal"
        echo -e "                        circumstances this should not be used."
        echo -e
        echo -e "Available STEP Options:"
        echo -e "                        start     same as starting without a STEP option"
        echo -e "                        update    update fresh install scripts"
        echo -e "                        gzdoom    download gzdoom install files"
        echo -e "                        knossos   download knosso install files"
        echo -e "                        qucs      download qucs install files"
        echo -e "                        valkyrie  download valkyrie install files"
        echo -e "                        apps      download Apps.zip and extract"
        echo -e
        echo -e "Available MODE Options:"
        echo -e "                        y  answers yes to downloading installs (all steps will be confirmed)"
        echo -e "                        n  answers no to downloading installs (script will simply exit)"
        echo -e "                        a  answers all to downloading installs (all steps will automatically execute)"
        echo -e "${NC}"
        exit
        shift # Remove from processing
        ;;
        --step=*)
        GOTOSTEP=true
        GOTO="${arg#*=}"
        mode="y"
        shift # Remove from processing
        ;;
        --restart=*)
        RESTART=true
        mode="${arg#*=}"
        shift # Remove --restart from processing
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

dl(){ cmd "gdown https://drive.google.com/uc?id=$1"; }

jumpto(){
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
start=${1:-"start"}
jumpto $start
start:

if [ "$RESTART" = true ]; then
    echo -e "${RED}NOTE: Script restarted using downloaded version. ($0 $FLAGS --restart=$mode)${NC}"
    if [ "$mode" != "${mode#[Aa]}" ] ;then answer2="y"; else answer2=""; fi
    jumpto restart
fi

if [ "$GOTOSTEP" = true ] || [ "$GOTOCONTINUE" = true ]; then
    jumpto $GOTO
fi

echo -e
echo -e "${grey}This script will downlaod the fresh_install files as well as${NC}"
echo -e "${grey}give you the option to downlaod additional source installers${NC}"
echo -e "${grey}that I have written including:${NC}"
echo -e "${grey}\tFresh Install:${NC}"
echo -e "${grey}\t  - backup.sh${NC}"
echo -e "${grey}\t  - restore.sh${NC}"
echo -e "${grey}\t  - Apps:${NC}"
echo -e "${grey}\t    - Bricscad v20.2.08${NC}"
echo -e "${grey}\t    - Camotics v1.2.0${NC}"
echo -e "${grey}\t    - Chrome${NC}"
echo -e "${grey}\t    - Brother printer installer v2.2.2.1${NC}"
echo -e "${grey}\t    - Multisystem${NC}"
echo -e "${grey}\t    - NoMachine v6.11.2${NC}"
echo -e "${grey}\t    - Steam${NC}"
echo -e "${grey}\t    - Eclipse v2020-06${NC}"
echo -e "${grey}\t    - Plasmoids${NC}"
echo -e "${grey}\tSource Installs:${NC}"
echo -e "${grey}\t  - knossos${NC}"
echo -e "${grey}\t  - qucs${NC}"
echo -e "${grey}\t  - valkyrie${NC}"
echo -e "${grey}\t  - gzdoom${NC}"
echo -e "${grey}\t    - Addons:${NC}"
echo -e "${grey}\t      - High res textures${NC}"
echo -e "${grey}\t      - Remastered music${NC}"
echo -e "${grey}\t      - Brutal Doom${NC}"
echo -e "${grey}\t      - gzdoom.ini${NC}"
#echo -e "${grey}\t- flatcam${NC}"
#echo -e "${grey}\t\t- ${NC}"
#echo -e "${grey}${NC}"
echo -e
echo -e -n "${BLUE}Do you want to download installs ${GREEN}(y/n/a)? ${NC}"
read mode
#cmd "mkdir -p ./tmp/"
#cmd "cd tmp"
if [ "$mode" != "${mode#[Yy]}" ] || [ "$mode" != "${mode#[Aa]}" ] ;then
    if [ "$mode" != "${mode#[Aa]}" ] ;then answer2="y"; else answer2=""; fi

    update:
    printf "${BLUE}fresh install scripts (will update all scripts)${NC}"
    if [ "$mode" != "${mode#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo -e; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/fresh_install.git"
        cmd "rsync -a ./fresh_install/*.sh ./"
        cmd "rm -rf ./fresh_install"
        if [ "$GOTOSTEP" = false ]; then cmd "./download.sh $FLAGS --restart=$mode"; exit; fi
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi

    restart:
    gzdoom:
    printf "${BLUE}gzdoom${NC}"
    if [ "$mode" != "${mode#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo -e; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/gzdoom_installer.git"
        cmd "rm -rf ./gzdoom_installer/.git"
        cmd "rm ./gzdoom_installer/*.md"
        printf "${BLUE}Addons (Will also install pip3 and gdown)${NC}"
        if [ "$mode" != "${mode#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo -e; fi
        if [ "$answer2" != "${answer2#[Yy]}" ] ;then
            if ! command -v pip3 &> /dev/null; then cmd "sudo apt -qy install python3-pip"; fi
            if ! command -v gdown &> /dev/null; then cmd "pip3 install gdown"; fi
            #cmd "sudo apt -qy install python3-pip"
            #cmd "pip3 install gdown"
            dl "1xYo4_OEfLFkCZ7vyHQTBPJ2yC10h0g5g"
            cmd "unzip -o Addons.zip -d ./gzdoom_installer/" 
            cmd "rm Addons.zip"
        fi
        #cmd "mv ./gzdoom_installer/* ./"
        cmd "rsync -a ./gzdoom_installer/ ./"
        cmd "rm -rf ./gzdoom_installer"
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    knossos:
    printf "${BLUE}knossos${NC}"
    if [ "$mode" != "${mode#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo -e; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/knossos_installer.git"
        cmd "rm -rf ./knossos_installer/.git"
        cmd "rm ./knossos_installer/*.md"
        #cmd "mv ./knossos_installer/* ./"
        cmd "rsync -a ./knossos_installer/ ./"
        cmd "rm -rf ./knossos_installer"
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    qucs:
    printf "${BLUE}qucs${NC}"
    if [ "$mode" != "${mode#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo -e; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/qucs_installer.git"
        cmd "rm -rf ./qucs_installer/.git"
        cmd "rm ./qucs_installer/*.md"
        #cmd "mv ./qucs_installer/* ./"
        cmd "rsync -a ./qucs_installer/ ./"
        cmd "rm -rf ./qucs_installer"
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    valkyrie:
    printf "${BLUE}valkyrie${NC}"
    if [ "$mode" != "${mode#[Yy]}" ] ;then printf " ${GREEN}(y/n)? ${NC} "; read answer2; else echo -e; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        cmd "git clone https://github.com/bcthund/valkyrie_installer.git"
        cmd "rm -rf ./valkyrie_installer/.git"
        cmd "rm ./valkyrie_installer/*.md"
        #cmd "mv ./valkyrie_installer/* ./"
        cmd "rsync -a ./valkyrie_installer/ ./"
        cmd "rm -rf ./valkyrie_installer"
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    apps:
    echo -e "${BLUE}Apps (Will also install pip3 and gdown)${NC}"
    echo -e "${grey}\t- Bricscad v20.2.08${NC}"
    echo -e "${grey}\t- Camotics v1.2.0${NC}"
    echo -e "${grey}\t- Chrome${NC}"
    echo -e "${grey}\t- Brother printer installer v2.2.2.1${NC}"
    echo -e "${grey}\t- Multisystem${NC}"
    echo -e "${grey}\t- NoMachine v6.11.2${NC}"
    echo -e "${grey}\t- Steam${NC}"
    echo -e "${grey}\t- Eclipse v2020-06${NC}"
    echo -e "${grey}\t- Plasmoids${NC}"
    if [ "$mode" != "${mode#[Yy]}" ] ;then printf "${GREEN}Continue (y/n)? ${NC} "; read answer2; else echo -e; fi
    if [ "$answer2" != "${answer2#[Yy]}" ] ;then
        if ! command -v pip3 &> /dev/null; then cmd "sudo apt -qy install python3-pip"; fi
        if ! command -v gdown &> /dev/null; then cmd "pip3 install gdown"; fi
        #cmd "sudo apt -qy install python3-pip"
        #cmd "pip3 install gdown"
        dl "1wcCso1e16rusFrnEZq035Xu-wKf99ZyH"
        cmd "unzip -o Apps.zip"
        cmd "rm Apps.zip"
    fi
    if [ "$GOTOSTEP" = true ]; then echo -e "${BLUE}Finished${NC}\n"; exit; fi
    
    echo -e
    echo -e "${BLUE}All Done!${NC}"
    echo -e "${YELLOW}Run 'fresh_install.sh' to Backup or Restore as well as install programs.${NC}"
    echo -e "${YELLOW}Alternatively run 'backup.sh' to perform a system backup right now.${NC}"
    echo -e "${YELLOW}Alternatively run 'restore.sh' to perform only a restore of a prvious backup.${NC}"

#cmd "cd ${working_dir}"
    
#     printf "${BLUE}${NC}"
#     echo -e -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$mode" != "${mode#[Yy]}" ] ;then
#         cmd ""
#     fi
if [ "$RESTART" = true ]; then exit; fi
fi
