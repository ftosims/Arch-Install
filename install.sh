#!/bin/bash
#联网
#wifi-menu
#分区
read -p "sda1 efi sda2 / sda3 /home sda4 swap"
parted /dev/sda
#格式化分区
sleep 2s
mkfs.vfat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3
mkswap    /dev/sda4
swapon    /dev/sda4
#挂载分区
sleep 2s
mount /dev/sda2 /mnt
mkdir /mnt/home
mkdir -p /mnt/boot/efi
sleep 2s
mount /dev/sda3 /mnt/home
mount /dev/sda1 /mnt/boot/efi
#修改镜像列表
echo "## China
Server = http://mirrors.163.com/archlinux/\$repo/os/\$arch
Server = http://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
#安装基本包
pacstrap -i /mnt base base-devel
#生成磁盘文件
genfstab -U -p /mnt >> /mnt/etc/fstab
read -p "建议把efi那行最后的数字改成0，不让每次都检查磁盘"
vim /mnt/etc/fstab
#切换新的用户
mv ./config.sh /mnt/root/config.sh
chmod +x /mnt/root/config.sh
arch-chroot /mnt /root/config.sh
