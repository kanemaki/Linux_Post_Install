#!/bin/bash
#
# ubuntuScript.sh - Instalar e configurar programas no Ubuntu (22.04.04 LTS ou superior)
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
# -------------------------------TESTES E REQUISITOS---------------------- #
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

## Configurando usuario e email para o git##
echo “Digite o seu nome de usuario no git?”
read nome_git;

echo “Digite o seu email de usuario no git?”
read email_git;

## URLS
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

## DIRETÓRIOS E ARQUIVOS
DIRECTORY_DOWNLOADS="$HOME/Downloads/program_scripts"

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
  gnome-tweaks
  fonts-hack-ttf
  qemu 
  qemu-kvm 
  libvirt-clients 
  libvirt-daemon-system 
  bridge-utils 
  virt-manager 
  libguestfs-tools
  npm
  docker.io
  docker-compose
  golang-go
  aspnetcore-runtime-7.0
  dotnet-runtime-7.0
  zlib1g
  timeshift
  deluge
  emacs
  gnucash
  pidgin
  clamtk
  terminator
  ardour
  audacity
  krita
  gnome-screenshot
  taskwarrior
)

# ------------------------------------------------------------------------ #
# ----------------------------- FUNÇÕES ---------------------------------- #
snap_remove(){
  ## Remover snap
  echo -e "${VERMELHO}[INFO] - Removendo SNAP${SEM_COR}"
  snap remove --purge firefox
  snap remove --purge snap-store
  snap remove --purge gnome-3-38-2004
  snap remove --purge gtk-common-themes
  snap remove --purge snapd-desktop-integration
  snap remove --purge bare
  snap remove --purge core20
  snap remove --purge snapd gnome-software-plugin-snap -y
  
  apt purge snapd -y

  rm -rf /var/cache/snapd
  rm -rf ~/snap

  echo -e "#block snaps\Package: snapd\Pin: release a=*\Pin-Priority: -10" >> /etc/apt/preferences.d/nosnap.pref
}

canonical_reports_remove(){
  ## Remover Canonical reports
  echo -e "${VERMELHO}[INFO] - Removendo Canonical reports${SEM_COR}"
  apt remove --purge apport apport-gtk apport-symptoms -y
}

apt_update(){
  echo -e "${VERDE}[INFO] - APT Update${SEM_COR}"
  apt update && apt full-upgrade -y
}

lock_apt_remove(){
  ## Removendo lock do apt
  echo -e "${VERDE}[INFO] - Removendo travas do apt${SEM_COR}"
  rm /var/lib/dpkg/lock-frontend ; rm /var/cache/apt/archives/lock;
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

dotnet_install(){
	echo -e "${VERDE}[INFO] - Instalando .Net SDK e .Net runtime${SEM_COR}"
  ## Install the .Net SDK
  sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-8.0

  ## Install the .Net runtime
  sudo apt-get update && \
    sudo apt-get install -y aspnetcore-runtime-8.0
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

config_libvirt(){
  ## Adicionando usuario corrente no grupo  libvirt
  echo -e "${VERDE}[INFO] - Configuracoes no libvirt${SEM_COR}"
  useradd -g $USER libvirt
  useradd -g $USER libvirt-kvm
  usermod -aG docker $USER

  echo 1 | tee /sys/module/kvm/parameters/ignore_msrs

  systemctl enable --now libvirtd
  systemctl enable --now virtlogd

  modprobe kvm
  groupadd docker

  systemctl enable libvirtd.service
  #sudo systemctl start libvirtd.service   

  systemctl enable --now docker docker.socket containerd

  ## Verificando 
  LC_ALL=C lscpu | grep Virtualization
  egrep -c '(vmx|svm)' /proc/cpuinfo 
}

config_git(){
  git config --global user.email $email_git
  git config --global user.name $nome_git
  ssh-keygen -t ed25519 -C $email_git
}

system_restart(){
  ## Reiniciar o sistema ##
  shutdown -r now
}

echo -e "${VERDE}[INFO] - Script iniciado, instalação em execucao! :)${SEM_COR}"
# --------------------------------------------------------------------- #
# ----------------------------- requerimentos ------------------------- #
testes_internet
snap_remove
canonical_reports_remove
# --------------------------------------------------------------------- #
# ----------------------------- execucao ------------------------------ #
apt_update
lock_apt_remove
program_install
remove_directory
dotnet_install
apt_update
# --------------------------------------------------------------------- #
# ----------------------------- pos instalacao ------------------------ #
less_memory_swap
update_nodejs
config_libvirt
final_install
config_git
echo -e "${VERDE}[INFO] - Script finalizado, instalação concluída! :)${SEM_COR}"
system_restart
