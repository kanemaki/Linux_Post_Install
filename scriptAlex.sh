#!/bin/bash

# --------------------------------------------------------------------------- #
# ----------------------------- remover snap -------------------------------- #

sudo snap remove --purge firefox
sudo snap remove --purge snap-store
sudo snap remove --purge gnome-3-38-2004
sudo snap remove --purge gtk-common-themes
sudo snap remove --purge snapd-desktop-integration
sudo snap remove --purge bare
sudo snap remove --purge core20
sudo snap remove --purge snapd gnome-software-plugin-snap -y

sudo apt purge snapd -y

sudo rm -rf /var/cache/snapd
sudo rm -rf ~/snap

sudo echo -e "#block snaps\Package: snapd\Pin: release a=*\Pin-Priority: -10" >> /etc/apt/preferences.d/nosnap.pref

# ------------------------------------------------------------------------ #
# ------------ remover Canonical reports  -------------------------------- #

sudo apt remove --purge apport apport-gtk apport-symptoms -y

# ------------------------------------------------------------------------ #
# ----------------------------- variaveis -------------------------------- #

DIRECTORY_DOWNLOADS="$HOME/Downloads/program_scripts"
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

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
	"https://dl.flathub.org/repo/appstream/dev.ares.ares.flatpakref"
	"https://dl.flathub.org/repo/appstream/org.duckstation.DuckStation.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.fightcade.Fightcade.flatpakref"
	"https://dl.flathub.org/repo/appstream/net.pcsx2.PCSX2.flatpakref"
	"https://dl.flathub.org/repo/appstream/net.rpcs3.RPCS3.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.valvesoftware.Steam.flatpakref"
	"https://dl.flathub.org/repo/appstream/org.yuzu_emu.yuzu.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.discordapp.Discord.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.microsoft.Teams.flatpakref"
	"https://dl.flathub.org/repo/appstream/org.remmina.Remmina.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.skype.Client.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.slack.Slack.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.github.micahflee.torbrowser-launcher.flatpakref"
	"https://dl.flathub.org/repo/appstream/us.zoom.Zoom.flatpakref"
	"https://dl.flathub.org/repo/appstream/org.filezillaproject.Filezilla.flatpakref"
	"https://dl.flathub.org/repo/appstream/org.ppsspp.PPSSPP.flatpakref"
	"https://dl.flathub.org/repo/appstream/com.usebottles.bottles.flatpakref"
 	"https://flathub.org/pt-BR/apps/io.github.mimbrero.WhatsAppDesktop"
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
  virt-manager
  bridge-utils
)

# -------------------------------------------=----------------------------- #
# ----------------------------- requerimentos ----------------------------- #

## removendo lock do apt ##
sudo rm /var/lib/dpkg/lock-frontend ; sudo rm /var/cache/apt/archives/lock;

## Atualizando repositorio ##
sudo apt update -y

# --------------------------------------------------------------------- #
# ----------------------------- execucao ------------------------------ #

# instalacao de programas com apt
for program_name in ${PROGRAMS_FOR_INSTALL[@]}; do
  if ! dpkg -l | grep -q $program_name; then # only install if not already installed
    apt install "$program_name" -y
  else
    echo "[installed] - $program_name"
  fi
done

## downloading e instalando programas ##
mkdir -p ~/.icons && mkdir -p ~/.themes
mkdir $DIRECTORY_DOWNLOADS

wget -c "$URL_GOOGLE_CHROME"         -P "$DIRECTORY_DOWNLOADS"
sudo gdebi $DIRECTORY_DOWNLOADS/*.deb -n

## Instalacao de flatpaks ##
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

for flatpak_name in ${FLATPAKS_FOR_INSTALL[@]}; do  
  sudo flatpak install --from $flatpak_name -y  
done

# ------------------------------------------------------------------------------- #
# ---------------------- menos uso de memoria swap ------------------------------ #

sudo echo -e "#less use of swap\nvm.swappiness=10\nvm.vfs_cache_pressure=50" >> /etc/sysctl.conf 

# ------------------------------------------------------------------------ #
# ----------------------------- pos instalacao --------------------------- #

## removendo diretorios ##
rm -rf $DIRECTORY_DOWNLOADS 

## adicionando usuario corrente no grupo  libvirt
sudo useradd -g $USER libvirt
sudo useradd -g $USER libvirt-kvm

sudo systemctl enable libvirtd.service
#sudo systemctl start libvirtd.service   

## Verificando
LC_ALL=C lscpu | grep Virtualization
egrep -c '(vmx|svm)' /proc/cpuinfo 

## finalizando ##
sudo apt update && sudo apt full-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y

## reiniciar o sistema ##
sudo shutdown -r now
