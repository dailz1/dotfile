#!/bin/bash

# 设置代理
echo "设置代理..."
export all_proxy="http://192.168.1.6:7897"
# 为 git 设置代理
git config --global http.proxy "http://192.168.1.6:7897"
git config --global https.proxy "http://192.168.1.6:7897"

# 检查是否已安装 zsh
echo "检查是否已安装 zsh..."
if command -v zsh &> /dev/null; then
    echo "zsh 已安装，跳过安装步骤。"
else
    # 检测操作系统类型
    echo "检测操作系统类型..."
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
    else
        OS=$(uname -s)
    fi

    # 根据不同的操作系统使用对应的包管理器安装 zsh
    echo "安装 zsh..."
    case $OS in
        *"Ubuntu"*|*"Debian"*)
            sudo apt update && sudo apt install -y zsh
            ;;
        *"CentOS"*|*"Red Hat"*|*"Fedora"*)
            sudo dnf install -y zsh || sudo yum install -y zsh
            ;;
        *"Arch"*|*"Manjaro"*)
            sudo pacman -Sy --noconfirm zsh
            ;;
        *"openSUSE"*)
            sudo zypper install -y zsh
            ;;
        *)
            echo "未能识别的操作系统: $OS"
            echo "请手动安装 zsh"
            exit 1
            ;;
    esac

    # 检查 zsh 是否安装成功
    if ! command -v zsh &> /dev/null
    then
        echo "zsh 安装失败，请检查您的网络连接或包管理器设置。"
        exit 1
    fi
fi

# 设置 zsh 为默认 shell
echo "设置 zsh 为默认 shell..."
chsh -s $(which zsh)

# 检查 git 是否安装
if ! command -v git &> /dev/null
then
    echo "git 未安装。请先安装 git。"
    exit 1
fi

# 克隆 dotfile 仓库到用户主目录
echo "从 GitHub 仓库克隆 dotfile 到主目录..."
git clone https://github.com/dailz1/dotfile.git ~

echo "脚本执行完毕！请重新登录以应用 zsh 作为默认 shell。"