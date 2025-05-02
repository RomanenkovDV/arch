Arch installation scripts

1) connect with iwctl
2) make partitions using fdisk
    - 512 (EFI type)
    - Rest 

```
curl -L -o arch.zip https://github.com/RomanenkovDV/arch/archive/refs/heads/master.zip
unzip arch.zip
./arch-master/install.sh > log

arch-chroot /mnt
useradd -m -G wheel -s /bin/bash username
passwd username
```
