#!/bin/sh
if [ "$1" != "${1#[debug]}" ] ;then
    cmd(){ echo ">> ${WHITE}$1${NC}"; }
    echo "${RED}DEBUG: Commands will be echoed to console${NC}"
else
    cmd(){ eval $1; }
    echo "${RED}LIVE: Actions will be performed! Use caution.${NC}"
fi

echo
echo "${grey}This script will downlaod the fresh_install files as well as${NC}"
echo "${grey}give you the option to downlaod additional source installers${NC}"
echo "${grey}that I have written including:${NC}"
echo "${grey}\tFresh Install:${NC}"
echo "${grey}\t\t- backup.sh${NC}"
echo "${grey}\t\t- restore.sh${NC}"
echo "${grey}\t\t- Apps:${NC}"
echo "${grey}\t\t\t- Bricscad v20.2.08${NC}"
echo "${grey}\t\t\t- Camotics v1.2.0${NC}"
echo "${grey}\t\t\t- Chrome${NC}"
echo "${grey}\t\t\t- Brother printer installer v2.2.2.1${NC}"
echo "${grey}\t\t\t- Multisystem${NC}"
echo "${grey}\t\t\t- NoMachine v6.11.2${NC}"
echo "${grey}\t\t\t- Steam${NC}"
echo "${grey}\t\t\t- Eclipse v2020-06${NC}"
echo "${grey}\t\t\t- Plasmoids${NC}"
echo "${grey}\tSource Installs:${NC}"
echo "${grey}\t- knossos${NC}"
echo "${grey}\t- qucs${NC}"
echo "${grey}\t- valkyrie${NC}"
echo "${grey}\t- gzdoom${NC}"
echo "${grey}\t\t- Addons:${NC}"
echo "${grey}\t\t\t- High res textures${NC}"
echo "${grey}\t\t\t- Remastered music${NC}"
echo "${grey}\t\t\t- Brutal Doom${NC}"
echo "${grey}\t\t\t- gzdoom.ini${NC}"
#echo "${grey}\t- flatcam${NC}"
#echo "${grey}\t\t- ${NC}"
#echo "${grey}${NC}"
echo
echo -n "${BLUE}Do you want to download installs? ${NC}"
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
            cmd "sudo apt install python3-pip"
            cmd "pip3 install gdown"
            fileid="1wcCso1e16rusFrnEZq035Xu-wKf99ZyH"
            cmd "gdown https://drive.google.com/uc?id=${fileid}"
            cmd "unzip Apps.zip -d ./gzdoom_installer/" 
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
        cmd "sudo apt install python3-pip"
        cmd "pip3 install gdown"
        fileid="1xYo4_OEfLFkCZ7vyHQTBPJ2yC10h0g5g"
        cmd "gdown https://drive.google.com/uc?id=${fileid}"
        cmd "unzip Apps.zip"
    fi

#cmd "cd ${working_dir}"
    
#     printf "${BLUE}${NC}"
#     echo -n "${GREEN} (y/n)? ${NC}"; read answer; if [ "$answer" != "${answer#[Yy]}" ] ;then
#         cmd ""
#     fi
fi
