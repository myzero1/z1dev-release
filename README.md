# Z1dev

myzero1's dev

## install vagrant
```
download virtualbox
https://www.virtualbox.org/wiki/Downloads
https://download.virtualbox.org/virtualbox/6.1.32/VirtualBox-6.1.32-149290-Win.exe 速度相当快
can download from 360 soft

download vagrant
https://www.vagrantup.com/downloads.html
https://releases.hashicorp.com/vagrant/2.2.19/vagrant_2.2.19_x86_64.msi

https://github.com/hashicorp/vagrant-installers/releases
https://github.com/hashicorp/vagrant-installers/releases/download/v2.2.19.dev%2Bmain/vagrant_2.2.19_x86_64.msi


download from aliyun pan https://www.aliyundrive.com/
「z1dev」https://www.aliyundrive.com/s/pkGLADCLNvp

设置默认虚拟电脑位置：virtualbox 》 管理 》 常规 》 默认虚拟电脑位置

安装  vagrant plugin install vagrant-winnfsd 以超级管理员运行


写一个bat脚本来安装。




```


## install docker and docker-compose
```
bash check-docker-compose.sh

```


## user projects/default
```
cd projects/default
bash reinit-envs.sh 设置相应的参数
bash reinit.sh  需要调整,会再这里配置mysql的root用户密码为root并且可以远程访问
docker-composer up
docker-composer up -d



```

## init project

```
cd projects/default
docker-compose up -d

```