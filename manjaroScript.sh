#!/bin/bash

pamac build --no-confirm google-chrome

pamac install --no-confirm flatpak libpamac-flatpak-plugin 
pamac install --no-confirm gnome-software

pacman -S jre17-openjdk
pacman -S neofetch
pacman -S qemu
pacman -S virt-manager
pacman -S bridge-utils
pacman -S npm
npm install -g npm@9.7.1
npm i tsc
 
# sudo modprobe -r kvm_intel
# sudo modprobe kvm_intel nested=1

pacman -S qemu virt-manager libvirt virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat ebtables libguestfs

# sudo systemctl enable --now libvirtd
# sudo systemctl status libvirtd
# sudo usermod -a -G libvirt $USER
# sudo systemctl restart libvirtd

pacman -Syu
pacman -S docker 

systemctl start docker.service
systemctl enable docker.service

# docker version

usermod -aG docker $USER

# docker info

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

## Instalacao de flatpaks ##
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

for flatpak_name in ${FLATPAKS_FOR_INSTALL[@]}; do  
  sudo flatpak install --from $flatpak_name -y  
done
