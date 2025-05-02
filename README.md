Arch installation scripts

1) connect using iwctl
2) make partitions
    - 512M (EFI type)
    - All the remaining space

3) Install the system
```
curl -L -o arch.zip https://github.com/RomanenkovDV/arch/archive/refs/heads/master.zip
unzip arch.zip
./arch-master/install.sh > log
```

4) Add user
```
arch-chroot /mnt
useradd -m -G wheel -s /bin/bash username
passwd username
```

5) Set dotfiles
```
git clone https://github.com/RomanenkovDV/dotfiles.git .dotfiles
cd .dotfiles
stow --override *
```
