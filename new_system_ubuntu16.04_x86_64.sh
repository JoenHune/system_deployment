#!/bin/sh

expected_username="joen"
expected_password=" "

echo -n "Enter your sudo password:"
read pw

# 如果没有给定的用户，添加这个用户
egrep "^$expected_username" /etc/passwd >& /dev/null
if [ $? -ne 0 ]; then
    echo pw | sudo mkdir /home/$expected_username
    echo pw | sudo useradd -d /home/$expected_username $expected_username
    echo pw | sudo chown -R $expected_username /home/$expected_username
    echo pw | sudo chgrp -R $expected_username /home/$expected_username
    echo pw | sudo usermod -a -G sudo $expected_username
fi

# 切换为期望的用户后继续操作
echo expected_password | su - $expected_username << EOF

echo "hi, I am $USER"

# # 删除不好用的软件
# sudo api remove -y \
#     vim-tiny

# # 安装好用的软件
# sudo apt install -y \
#     git curl wget \
#     tar gzip zip \
#     cmake cmake-gui \
#     build-essential \
#     zsh \
#     terminator \
#     vim

# ## 安装vscode
# sudo snap install --classic code

# ## 设置默认的terminal为terminator（只影响快捷键Ctrl+Alt+T启动终端的情况）
# gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/terminator
# gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"

## 配置terminator
if [ ! -d "/home/$expected_username/.config/terminator" ]; then
    mkdir -p /home/$expected_username/.config/terminator
fi

# # 如果已有原本的配置，则先备份
# if [ -f "/home/$expected_username/.config/terminator/config" ]; then
#     mv "/home/$expected_username/.config/terminator/config" "/home/$expected_username/.config/terminator/config.backup"
# fi
curl -fsSL https://raw.github.com/JoenHune/system_deployment/master/terminator_config > ~/.config/terminator/config

# ## 切换为zsh并配置oh-my-zsh
# chsh -s /bin/zsh
# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ## 为科学服务
# echo "proxyon () {
#     export http_proxy=http://127.0.0.1:7890
#     export https_proxy=https://127.0.0.1:7890
#     export all_proxy=socks5://127.0.0.1:7981
#     echo \"http/https proxy on\"
# }

# proxyoff () {
#     unset http_proxy
#     unset https_proxy
#     unset all_proxy
#     echo \"http/https proxy off\"
# }" >> ~/test.txt


exit 0

EOF