# 个人化的Ubuntu新系统定制

通过以下指令实现自动配置

```
sudo rm -rf /bin/sh
sudo ln -s /bin/bash /bin/sh

sudo apt install -y curl
sh -c "$(curl -fsSL https://raw.github.com/JoenHune/system_deployment/master/new_system_ubuntu16.04_x86_64.sh)"
```
