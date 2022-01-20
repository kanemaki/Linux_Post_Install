#!/bin/bash

# ----------------------------- variables ----------------------------- #
PPA_FLATPAK="ppa:alexlarsson/flatpak"
PPA_SHUTTER="ppa:linuxuprising/shutter"
PPA_PEEK="ppa:peek-developers/stable"

FLATPAK_VLC="https://dl.flathub.org/repo/appstream/org.videolan.VLC.flatpakref"
FLATPAK_ANDROID_STUDIO="https://dl.flathub.org/repo/appstream/com.google.AndroidStudio.flatpakref"
FLATPAK_ARDUINO="https://dl.flathub.org/repo/appstream/cc.arduino.arduinoide.flatpakref"
FLATPAK_DBEAVER="https://dl.flathub.org/repo/appstream/io.dbeaver.DBeaverCommunity.flatpakref"
FLATPAK_ECLIPSE="https://dl.flathub.org/repo/appstream/org.eclipse.Java.flatpakref"
FLATPAK_INTELLIJ="https://dl.flathub.org/repo/appstream/com.jetbrains.IntelliJ-IDEA-Community.flatpakref"
FLATPAK_NETBEANS="https://dl.flathub.org/repo/appstream/org.apache.netbeans.flatpakref"
FLATPAK_POSTMAN="https://dl.flathub.org/repo/appstream/com.getpostman.Postman.flatpakref"
FLATPAK_SUBLIME_TEXT="https://dl.flathub.org/repo/appstream/com.sublimetext.three.flatpakref"
FLATPAK_UNITY_HUB="https://dl.flathub.org/repo/appstream/com.unity.UnityHub.flatpakref"
FLATPAK_VISUAL_STUIO_CODE="https://dl.flathub.org/repo/appstream/com.visualstudio.code.flatpakref"

FLATPAK_ARES="https://dl.flathub.org/repo/appstream/dev.ares.ares.flatpakref"
FLATPAK_DUCKSTATION="https://dl.flathub.org/repo/appstream/org.duckstation.DuckStation.flatpakref"
FLATPAK_FIGHTCADE="https://dl.flathub.org/repo/appstream/com.fightcade.Fightcade.flatpakref"
FLATPAK_PCSX2="https://dl.flathub.org/repo/appstream/net.pcsx2.PCSX2.flatpakref"
FLATPAK_RPCS3="https://dl.flathub.org/repo/appstream/net.rpcs3.RPCS3.flatpakref"
FLATPAK_STEAM="https://dl.flathub.org/repo/appstream/com.valvesoftware.Steam.flatpakref"
FLATPAK_YUZU="https://dl.flathub.org/repo/appstream/org.yuzu_emu.yuzu.flatpakref"

FLATPAK_DISCORD="https://dl.flathub.org/repo/appstream/com.discordapp.Discord.flatpakref"
FLATPAK_MICROSOFT_TEAMS="https://dl.flathub.org/repo/appstream/com.microsoft.Teams.flatpakref"
FLATPAK_REMMINA="https://dl.flathub.org/repo/appstream/org.remmina.Remmina.flatpakref"
FLATPAK_SKYPE="https://dl.flathub.org/repo/appstream/com.skype.Client.flatpakref"
FLATPAK_SLACK="https://dl.flathub.org/repo/appstream/com.slack.Slack.flatpakref"
FLATPAK_TOR_BROWSER="https://dl.flathub.org/repo/appstream/com.github.micahflee.torbrowser-launcher.flatpakref"
FLATPAK_ZOOM="https://dl.flathub.org/repo/appstream/us.zoom.Zoom.flatpakref"

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

DIRECTORY_DOWNLOADS="$HOME/Downloads/program"

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
mkdir "$DIRECTORY_DOWNLOADS"

wget -c "$URL_GOOGLE_CHROME"         -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_VLC"               -P "$DIRECTORY_DOWNLOADS"  
wget -c "$FLATPAK_ANDROID_STUDIO"    -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_ARDUINO"           -P "$DIRECTORY_DOWNLOADS" 
wget -c "$FLATPAK_DBEAVER"           -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_ECLIPSE"           -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_INTELLIJ"          -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_NETBEANS"          -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_POSTMAN"           -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_SUBLIME_TEXT"      -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_UNITY_HUB"         -P "$DIRECTORY_DOWNLOADS" 
wget -c "$FLATPAK_VISUAL_STUIO_CODE" -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_ARES"              -P "$DIRECTORY_DOWNLOADS"  
wget -c "$FLATPAK_DUCKSTATION"       -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_FIGHTCADE"         -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_PCSX2"             -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_RPCS3"             -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_STEAM"             -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_YUZU"              -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_DISCORD"           -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_MICROSOFT_TEAMS"   -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_REMMINA"           -P "$DIRECTORY_DOWNLOADS" 
wget -c "$FLATPAK_SKYPE"             -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_SLACK"             -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_TOR_BROWSER"       -P "$DIRECTORY_DOWNLOADS"
wget -c "$FLATPAK_ZOOM"              -P "$DIRECTORY_DOWNLOADS"

## installing .flatpakref packages downloaded in the previous session ##
sudo flatpak install $DIRECTORY_DOWNLOADS/*.flatpakref
sudo gdebi $DIRECTORY_DOWNLOADS/*.deb -y

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
## finalizing, updating and cleaning ##
sudo apt update && sudo apt full-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y
# -------------------------------------------------------------------------- #

