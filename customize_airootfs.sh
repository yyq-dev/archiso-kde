#!/bin/bash

# 设置中文环境
sed -i 's/#zh_CN.UTF-8/zh_CN.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=zh_CN.UTF-8" > /etc/locale.conf

# 创建自动登录用户
useradd -m -G wheel -s /usr/bin/fish arch
echo "arch:arch" | chpasswd

# 配置自动登录
## 1. 配置 SDDM
mkdir -p /etc/sddm.conf.d
echo "[Autologin]
User=arch
Session=plasma" > /etc/sddm.conf.d/autologin.conf

## 2. 配置 tty1 自动登录
mkdir -p /etc/systemd/system/getty@tty1.service.d
echo "[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin arch --noclear %I \$TERM" > /etc/systemd/system/getty@tty1.service.d/override.conf

# 启用必要服务
systemctl enable sddm
systemctl enable NetworkManager
systemctl enable bluetooth

# 配置 sudo 权限
echo "arch ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# 设置时区
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

# 设置 SDDM 主题为 Breeze
mkdir -p /etc/sddm.conf.d
echo "[Theme]
Current=breeze" > /etc/sddm.conf.d/breeze.conf

# 在原有内容后追加以下配置

# 配置输入法
## 安装字体缓存
fc-cache -fv

## 创建输入法配置文件
mkdir -p /etc/xdg/autostart
cat > /etc/xdg/autostart/fcitx5.desktop <<EOF
[Desktop Entry]
Type=Application
Name=FCITX5
Exec=fcitx5 -d
EOF

## 设置全局环境变量
echo "GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus" >> /etc/environment

## 用户级配置
USER_HOME=/home/arch
mkdir -p ${USER_HOME}/.config/fcitx5/conf
cat > ${USER_HOME}/.config/fcitx5/profile <<EOF
[Profile]
IMName=fcitx5
IMDisplayName=FCITX5
DefaultIM=pinyin
EOF

cat > ${USER_HOME}/.config/fcitx5/conf/pinyin.conf <<EOF
[Pinyin]
InitialPromptTimeout=500
PageSize=7
ShowPrediction=True
EOF

cat > ${USER_HOME}/.config/fcitx5/conf/classicui.conf <<EOF
# 字体
Font="苹方-简 12"
# 菜单字体
MenuFont="苹方-简 12"
# 托盘字体
TrayFont="苹方-简 12"
EOF

cat > ${USER_HOME}/.config/kdeglobals <<EOF
[General]
fixed=Hack Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
font=苹方-简,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
menuFont=苹方-简,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
smallestReadableFont=苹方-简,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
toolBarFont=苹方-简,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1

[WM]
activeFont=苹方-简,10,-1,5,700,0,0,0,0,0,0,0,0,0,0,1,Bold
EOF

# 删除多余locale
cat > /etc/locale.nopurge << 'EOF'
####################################################
# This is the configuration file for localepurge(8).
####################################################
# Comment this to enable localepurge.
# NO COMMENT IT IF YOU ARE NOT SURE WHAT ARE YOU DOING
# THIS APP DO NOT ASK FOR CONFIRMATION

#NEEDSCONFIGFIRST

####################################################
# Uncommenting this string enables removal of localized
# man pages based on the configuration information for
# locale files defined below:

MANDELETE

####################################################
# Uncommenting this string causes localepurge to simply delete
# locales which have newly appeared on the system without
# bothering you about it:

#DONTBOTHERNEWLOCALE

#####################################################
# Commenting out this string enables faster but less
# accurate calculation of freed disk space:

#QUICKNDIRTYCALC

####################################################
# Uncommenting this string enables display of freed disk
# space if localepurge has purged any superfluous data:

SHOWFREEDSPACE

#####################################################
# Commenting out this string disables verbose output:

#VERBOSE

#####################################################
# You like Colors?

#NOCOLOR

#####################################################
# You can use the -v -d -nc options in command line.

#####################################################
# Following locales won't be deleted from this system
# for example:
en
en_GB
en_GB.UTF-8
en_US
en_US.UTF-8
zh
zh_CN
zh_CN.UTF-8

EOF
localepurge

# 设置权限
chown -R arch:arch ${USER_HOME}/.config
