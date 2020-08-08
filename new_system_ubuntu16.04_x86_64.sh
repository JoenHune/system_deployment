#! /bin/sh

# 删除不好用的软件
# sudo api remove -y \
#     vim-tiny

# 安装好用的软件
# sudo apt install -y \
#     git curl wget \
#     tar gzip zip \
#     cmake cmake-gui \
#     build-essential \
#     zsh \
#     terminator \
#     vim

# 切换为zsh并配置oh-my-zsh
# chsh -s /bin/zsh
# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

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
}" >> /home/joen/test.txt