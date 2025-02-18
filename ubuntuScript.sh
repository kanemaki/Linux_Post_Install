#!/bin/bash
#
# ubuntuScript.sh - Instalar e configurar programas 
#
# Autor:         Alexandre Florentino
#
# ------------------------------------------------------------------------ #
#
# COMO USAR?
#   $ chmod 755 ubuntuScript.sh
#   $ ./ubuntuScript.sh
# ------------------------------------------------------------------------ #
set -e

# ------------------------------------------------------------------------ #
# -------------------------------TESTES---------------------- #
testes_internet(){
  ## Internet conectando?
  if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
    echo -e "${VERMELHO}[ERROR] - Seu computador não tem conexão com a Internet. Verifique a rede.${SEM_COR}"
    exit 1
  else
    echo -e "${VERDE}[INFO] - Conexão com a Internet funcionando normalmente.${SEM_COR}"
  fi
}

# ------------------------------------------------------------------------ #
# ----------------------------- VARIÁVEIS -------------------------------- #
IDUSUARIO="$(stat -c "%u" $(tty))"
USUARIO="$(grep -w $IDUSUARIO /etc/passwd | cut -d ":" -f "1" | xargs)"
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

## DIRETÓRIOS E ARQUIVOS
DIRECTORY_DOWNLOADS="/home/$USUARIO/Downloads/program_scripts"

## CORES
VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
SEM_COR='\e[0m'

FLATPAKS_FOR_INSTALL=(
	"https://dl.flathub.org/repo/appstream/org.videolan.VLC.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.google.AndroidStudio.flatpakref"
	"https://dl.flathub.org/repo/appstream/cc.arduino.arduinoide.flatpakref"
	"https://dl.flathub.org/repo/appstream/io.dbeaver.DBeaverCommunity.flatpakref"
	"https://dl.flathub.org/repo/appstream/org.eclipse.Java.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.jetbrains.IntelliJ-IDEA-Community.flatpakref"
	"https://dl.flathub.org/repo/appstream/org.apache.netbeans.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.getpostman.Postman.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.sublimetext.three.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.unity.UnityHub.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.visualstudio.code.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.discordapp.Discord.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.microsoft.Teams.flatpakref"
	"https://dl.flathub.org/repo/appstream/org.remmina.Remmina.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.skype.Client.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.slack.Slack.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.github.micahflee.torbrowser-launcher.flatpakref"
	"https://dl.flathub.org/repo/appstream/us.zoom.Zoom.flatpakref"
	"https://dl.flathub.org/repo/appstream/org.filezillaproject.Filezilla.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.usebottles.bottles.flatpakref"
)

PROGRAMS_FOR_INSTALL=(
  htop
  flatpak
  gnome-software
  gnome-software-plugin-flatpak
  git
  default-jre
  ubuntu-restricted-extras
  ubuntu-restricted-addons
  openvpn
  gdebi
  network-manager-openvpn-gnome
  shutter
  peek
  gnome-sushi
  vim
  neofetch
  plank
  fonts-hack-ttf
  npm
  golang-go
  zlib1g
  timeshift
  deluge
  emacs
  pidgin
  clamtk
  terminator
  ardour
  audacity
  krita
  gnome-screenshot
  preload
)

# ------------------------------------------------------------------------ #
# ----------------------------- FUNÇÕES ---------------------------------- #


apt_update(){
  echo -e "${VERDE}[INFO] - APT Update${SEM_COR}"
  apt update && apt full-upgrade -y
}

less_memory_swap(){
  ## Menos uso de memoria swap
  echo -e "${VERDE}[INFO] - Configurando arquivo sysctl.conf para reduzir uso de memoria swap${SEM_COR}"
  echo -e "#less use of swap\nvm.swappiness=10\nvm.vfs_cache_pressure=50" >> /etc/sysctl.conf 
}

final_install(){
  ## Finalizando
  echo -e "${VERDE}[INFO] - Flatpak Update${SEM_COR}"
  flatpak update
  apt autoclean
  apt autoremove -y
}

program_install(){	
  ## Instalacao de programas com apt
  
  echo -e "${VERDE}[INFO] - Instalando pacotes apt do repositório${SEM_COR}"
  for program_name in ${PROGRAMS_FOR_INSTALL[@]}; do
   if ! dpkg -l | grep -q $program_name; then # only install if not already installed
     apt install "$program_name" -y
   else
     echo "[installed] - $program_name"
   fi
  done

  ## Downloading e instalando programas ##
  mkdir -p ~/.icons && mkdir -p ~/.themes
  mkdir $DIRECTORY_DOWNLOADS

  echo -e "${VERDE}[INFO] - Baixando pacotes .deb${SEM_COR}"
  wget -c "$URL_GOOGLE_CHROME"         -P "$DIRECTORY_DOWNLOADS"
  
  echo -e "${VERDE}[INFO] - Instalando pacotes .deb baixados${SEM_COR}"
  gdebi $DIRECTORY_DOWNLOADS/*.deb -n

  ## Instalacao de flatpaks ##
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  echo -e "${VERDE}[INFO] - Instalando pacotes flatpak${SEM_COR}"
  for flatpak_name in ${FLATPAKS_FOR_INSTALL[@]}; do  
   flatpak install --from $flatpak_name -y  
  done
}

remove_directory(){
  ## Removendo diretorios ##
  echo -e "${VERDE}[INFO] - Removendo diretorios${SEM_COR}"
  rm -rf $DIRECTORY_DOWNLOADS 
}

update_nodejs(){
  ## Update NodeJS
  echo -e "${VERDE}[INFO] - Update NODEJS${SEM_COR}"
  npm cache clean -f
  npm install -g n
  sudo n stable
}

system_restart(){
  ## Reiniciar o sistema ##
  shutdown -r now
}

echo -e "${VERDE}[INFO] - Script iniciado, instalação em execucao! :)${SEM_COR}"
# --------------------------------------------------------------------- #
# ----------------------------- requerimentos ------------------------- #
testes_internet
# --------------------------------------------------------------------- #
# ----------------------------- execucao ------------------------------ #
apt_update
program_install
remove_directory
apt_update
# --------------------------------------------------------------------- #
# ----------------------------- pos instalacao ------------------------ #
less_memory_swap
update_nodejs
final_install
echo -e "${VERDE}[INFO] - Script finalizado, instalação concluída! :)${SEM_COR}"
system_restart
