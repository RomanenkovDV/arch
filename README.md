Arch installation scripts

1) connect with iwctl
2) make partitions using fdisk
    - 512 (EFI type)
    - Rest 

curl -L -o arch.zip https://github.com/RomanenkovDV/arch/archive/refs/heads/master.zip
unzip arch.zip -d arch
./arch/install.sh
