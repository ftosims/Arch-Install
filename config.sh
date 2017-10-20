#!/bin/bash
#编码表
echo zh_CN.UTF-8 > /etc/locale.gen
echo en_US.UTF-8 > /etc/locale.gen
echo zh_CN.GBK   > /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

ln -S /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --localtime
echo Blind_one > /etc/hostname

passwd
#安装grub
pacman -S dosfstools efibootmgr grub os-prober
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S nvidia
#添加软件源
echo"[archlinuxcn]
SigLevel = Optional TrustAll
Server   = https://mirrors.ustc.edu.cn/archlinuxcn/$arch

[blackarch]
SigLevel = Optional TrustAll
Server = https://mirrors.ustc.edu.cn/blackarch/$repo/os/$arch" >> /etc/pacman.conf
#安装必备包
pacman -Syu && pacman -S archlinuxcn-keyring && pacman -S networkmanager dialog xorg-server firefox yaourt wqy-zenhei sudo vim yaourt

systemctl enable NetworkManager

pacman -S xfce4 xfce4-goodies

pacman -S lightdm lightdm-gtk-greeter

read -p "接写来将测试lightdm 若启动成功请注销"
systemctl start lightdm.service

pacman -S alsa-utils

read -p "检查是否有Install字段"
vi /lib/systemd/system/alsa-state.service

read -p "有(y)？无(n)？" ifinstall
if ["$ifinstall" == n]
then echo "[Install]
WantedBy=multi-user.target" >> /etc/pacman.conf
fi

systemctl start alsa-state.service
systemctl enable alsa-state.service

#安装中文字体
pacman -S wqy-microhei ttf-dejavu

echo LANG=zh_CN.UTF-8>/etc/locale.conf
pacman -S fcitx fcitx-im fcitx-cloudpinyin fcitx-configtool fcitx-googlepinyin fcitx-qt5

echo "export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=\"@im=fcitx\"" >> ~/.xprofile

pacman -S gvfs

pacman -S ntp
systemctl start ntpd.service
systemctl enable ntpd.service

reboot 0
