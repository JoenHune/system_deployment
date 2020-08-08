#!/bin/sh

expected_username="joen"
expected_password=" "

echo -n "Enter your sudo password:"
read pw

# 如果没有给定的用户，添加这个用户
egrep "^$expected_username" /etc/passwd >& /dev/null
if [ $? -ne 0 ]
then
    # 新建home目录
    echo "Creating folder: /home/"$expected_username
    echo pw | sudo mkdir /home/$expected_username
    
    # 新建用户
    echo "Adding user: "$expected_username
    echo pw | sudo useradd -d /home/$expected_username $expected_username
    echo $expected_password | sudo passwd $expected_username

    # 新用户赋权
    echo pw | sudo chown -R $expected_username /home/$expected_username
    echo pw | sudo chgrp -R $expected_username /home/$expected_username
    echo pw | sudo usermod -a -G sudo $expected_username
fi

# 删除不好用的软件
echo $expected_password ｜ sudo api remove -y \
    vim-tiny

# 安装好用的软件
echo $expected_password ｜ sudo apt install -y \
    git curl wget \
    tar gzip zip \
    cmake cmake-gui \
    build-essential \
    zsh \
    terminator \
    vim

## 安装vscode
echo expected_password ｜ sudo snap install --classic code

## 设置默认的terminal为terminator（只影响快捷键Ctrl+Alt+T启动终端的情况）
gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/terminator
gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"

## 配置terminator
terminator_config_folder="/home/$expected_username/.config/terminator/"
terminator_config_file="/home/$expected_username/.config/terminator/config"
if [ ! -d $terminator_config_folder ]
then
    echo "Creating folder: "$terminator_config_folder
    mkdir -p $terminator_config_folder
fi

# 如果已有原本的配置，则先备份
if [ -f $terminator_config_file ]
then
    echo "Backing up file: "$terminator_config_file
    mv $terminator_config_file $terminator_config_file".backup"
fi
curl -fsSL https://raw.github.com/JoenHune/system_deployment/master/terminator_config > $terminator_config_file

## 切换为zsh并配置oh-my-zsh
su - $expected_username -c "chsh -s /bin/zsh; sh -c \"$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""

## 为科学服务
echo "proxyon () {
    export http_proxy=http://127.0.0.1:7890
    export https_proxy=https://127.0.0.1:7890
    export all_proxy=socks5://127.0.0.1:7981
    echo \"http/https proxy on\"
}

proxyoff () {
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo \"http/https proxy off\"
}" >> /home/$expected_username/.zshrc

exit 0

EOF