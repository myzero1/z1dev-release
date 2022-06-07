# Z1dev

This is a docker-compose env on window,maybe can work on macos.It include a demo project env,in workspace/projects/default.

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


```

## usage

```
cd path/to/z1dev-release
vagrant up
vagrant ssh
su root             input pw vagrant
cd /workspace
bash check-docker-compose.sh
cd /workspace/projects/default
bash reinit-envs.sh
bash reinit.sh

```

## Common commands

```
vagrant up
vagrant ssh
vagrant halt
vagrant destroy
vagrant snapshot save z1dev
vagrant snapshot restore z1dev

docker-compose ps
docker-compose down
docker-compose up [-d]
docker-compose stop
docker-compose start
docker-compose restart
docker-compose up mysql
docker-compose up --build mysql

docker exec -it dev__mysql /bin/bash
docker stop dev__mysql
docker start dev__mysql
docker ps 
docker ps -aq
docker rm $(docker ps -aq)
docker images
docker rmi $(docker images -aq)

```