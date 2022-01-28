#!/bin/bash

# ----------------------------- variables ----------------------------- #
PPA_FLATPAK="ppa:alexlarsson/flatpak"
PPA_SHUTTER="ppa:linuxuprising/shutter"
PPA_PEEK="ppa:peek-developers/stable"

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
)

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

DIRECTORY_DOWNLOADS="$HOME/Downloads/program_scripts"

PROGRAMS_FOR_INSTALL=(
  htop
  flatpak
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
  gnome-tweak-tool
  fonts-hack-ttf
)
# ------------------------------------------------------------------------ #

# ----------------------------- requirements ----------------------------- #
## removing locks from apt ##
sudo rm /var/lib/dpkg/lock-frontend ; sudo rm /var/cache/apt/archives/lock;

## Updating the repository ##
sudo apt update -y

## Adding third-party repositories ##
sudo add-apt-repository "$PPA_SHUTTER" -y
sudo add-apt-repository "$PPA_FLATPAK" -y
sudo add-apt-repository "$PPA_PEEK" -y
# ---------------------------------------------------------------------- #

# ----------------------------- execution ------------------------------ #
## updating the repository after adding new repositories ##
sudo apt update -y

# install programs with apt
for program_name in ${PROGRAMS_FOR_INSTALL[@]}; do
  if ! dpkg -l | grep -q $program_name; then # only install if not already installed
    apt install "$program_name" -y
  else
    echo "[installed] - $program_name"
  fi
done

## downloading and installing external programs ##
mkdir -p ~/.icons && mkdir -p ~/.themes
mkdir $DIRECTORY_DOWNLOADS

wget -c "$URL_GOOGLE_CHROME"         -P "$DIRECTORY_DOWNLOADS"
sudo gdebi $DIRECTORY_DOWNLOADS/*.deb -n

## installing .flatpakref packages downloaded in the previous session ##
for flatpak_name in ${FLATPAKS_FOR_INSTALL[@]}; do  
  sudo flatpak install --from $flatpak_name -y  
done

## removing Snap##
sudo apt remove --purge snapd gnome-software-plugin-snap -y
sudo rm -rf /var/cache/snapd
sudo rm -rf ~/snap

## removing Canonical reports ##
sudo apt remove --purge apport apport-gtk apport-symptoms -y

## less use of swap ##
sudo echo -e "#less use of swap\nvm.swappiness=10\nvm.vfs_cache_pressure=50" >> /etc/sysctl.conf 

# -------------------------------------------------------------------------- #

# -----------------------------post installation --------------------------- #
## removing directory ##
rm -rf $DIRECTORY_DOWNLOADS 

## finalizing, updating and cleaning ##
sudo apt update && sudo apt full-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y
# -------------------------------------------------------------------------- #

