#!/bin/sh

set -e

mkfs.fat -F32 /dev/nvme0n1p1
mkfs.btrfs -f -L ArchRoot /dev/nvme0n1p2

mount /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@logs
btrfs subvolume create /mnt/@snapshots
umount /mnt

mount -o noatime,compress=zstd,space_cache=v2,subvol=@ /dev/nvme0n1p2 /mnt
mkdir -p /mnt/{boot,home,var/log,.snapshots}

mount /dev/nvme0n1p1 /mnt/boot
mount -o noatime,compress=zstd,space_cache=v2,subvol=@home /dev/nvme0n1p2 /mnt/home
mount -o noatime,compress=zstd,space_cache=v2,subvol=@logs /dev/nvme0n1p2 /mnt/var/log
mount -o noatime,compress=zstd,space_cache=v2,subvol=@snapshots /dev/nvme0n1p2 /mnt/.snapshots

pacstrap /mnt amd-ucode mkinitcpio linux linux-firmware base base-devel btrfs-progs dosfstools \
    mesa vulkan-radeon pipewire pipewire-alsa pipewire-pulse pipewire-jack iwd bluez brightnessctl \
    iptables-nft less man-db lf curl fzf neovim git openssh flatpak stow \
    gvfs gvfs-afc gvfs-dnssd gvfs-google gvfs-mtp gvfs-smb gvfs-wsdd \
    wayland wl-clipboard sway swaybg swayidle swaylock waybar greetd greetd-agreety greetd-gtkgreet \
    engrampa thunar thunar-archive-plugin thunar-volman kitty mako mpv pavucontrol \
    ttf-roboto ttf-roboto-mono-nerd noto-fonts noto-fonts-extra noto-fonts-cjk noto-fonts-emoji \
    firefox telegram-desktop keepassxc moonlight-qt \

genfstab -U /mnt >> /mnt/etc/fstab

systemd-firstboot --root=/mnt --locale=en_US.UTF-8 --timezone=Europe/Moscow --hostname=xx16
echo "ru_RU.UTF-8 UTF-8" >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

systemctl --root=/mnt enable iwd
systemctl --root=/mnt enable systemd-networkd
systemctl --root=/mnt enable systemd-resolved
systemctl --root=/mnt enable greetd

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# loader
arch-chroot /mnt bootctl install
mv $ROOT/boot/loader.conf /mnt/boot/loader/loader.conf
mv $ROOT/boot/arch.conf /mnt/boot/loader/entries/arch.conf

# wifi
mv /var/lib/iwd /mnt/var/lib/iwd
mv $ROOT/20-wifi.network /mnt/etc/systemd/network/

# greetd
rm -rf /mnt/etc/greetd && mv $ROOT/greet /mnt/etc/greetd
