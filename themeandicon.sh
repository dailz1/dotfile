#!/bin/bash

# 检查 git 是否安装
if ! command -v git &> /dev/null
then
    echo "git 未安装，准备安装 git..."
    
    # 检测操作系统类型
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
    else
        OS=$(uname -s)
    fi

    # 根据不同的操作系统使用对应的包管理器安装 git
    case $OS in
        *"Ubuntu"*|*"Debian"*)
            sudo apt update && sudo apt install -y git
            ;;
        *"CentOS"*|*"Red Hat"*|*"Fedora"*)
            sudo dnf install -y git || sudo yum install -y git
            ;;
        *"Arch"*|*"Manjaro"*)
            sudo pacman -Sy --noconfirm git
            ;;
        *"openSUSE"*)
            sudo zypper install -y git
            ;;
        *)
            echo "未能识别的操作系统: $OS"
            echo "请手动安装 git"
            exit 1
            ;;
    esac

    # 检查 git 是否安装成功
    if ! command -v git &> /dev/null
    then
        echo "git 安装失败，请检查您的网络连接或包管理器设置。"
        exit 1
    fi
fi

# 创建并进入 Downloads 目录
cd ~/Downloads || mkdir -p ~/Downloads && cd ~/Downloads

# 克隆图标仓库
echo "克隆图标仓库..."
git clone https://github.com/yeyushengfan258/Reversal-icon-theme.git

# 进入仓库目录并执行安装脚本
cd Reversal-icon-theme
echo "安装图标..."
./install.sh -a

echo "图标安装完成！"

# 返回 Downloads 目录
cd ..

# 克隆主题仓库
echo "克隆主题仓库..."
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git

# 进入仓库目录并执行安装脚本
cd WhiteSur-gtk-theme
echo "安装主题..."
./install.sh -t all

echo "主题安装完成！"


