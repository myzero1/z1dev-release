#!/bin/bash
# created by qxw

function checkEnv(){
    echo '------------------------checkEnv,start------------------------'
    yum -y install net-tools

    # http://get.daocloud.io/#install-docker
    if [ ! -f "/usr/bin/docker" ];then
        # # 如果使用vagrant环境可以注释掉这部分
        # ------ vagrant，start ------
        # #使用阿里镜像源
        # cd /etc/yum.repos.d/
        # rm -rf *.*
        # curl -O http://mirrors.aliyun.com/repo/Centos-7.repo
        # curl -O http://mirrors.aliyun.com/repo/epel-7.repo
        # yum clean all
        # yum makecache
        # ------ vagrant，start ------

        # 卸载 docker
        sudo yum remove docker \
            docker-common \
            container-selinux \
            docker-selinux \
            docker-engine

        # 由于之前安装过旧版本docker没有卸载干净，导致安装失败；需要完全卸载旧版本
        # rpm -qa | grep docker
        # rpm -e docker-clicent-xxxxx

        # 安装docker
        # uname -a
        # yum update
        yum -y install yum-utils device-mapper-persistent-data lvm2
        yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
        # yum list docker-ce --showduplicates | sort -r
        # yum -y install docker-ce-18.03.1.ce
        # yum list docker-ce --showduplicates | sort -r
        # yum -y install docker-ce-18.03.0.ce
        yum -y install docker-ce-18.06.3.ce

        # 设置镜像容器的保存地址
        mkdir -p /etc/docker
        touch /etc/docker/daemon.json
cat>/etc/docker/daemon.json<<EOF
{
    "data-root":"/home/docker-data-root",
    "registry-mirrors": ["https://fhy2erxk.mirror.aliyuncs.com"]
}
EOF

        systemctl start docker
        systemctl enable  docker

        # yum install deltarpm -y
        # # yum update -y
        # curl -sSL https://get.daocloud.io/docker | sh

        # 替换镜像
        # curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
        curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s https://fhy2erxk.mirror.aliyuncs.com

        service docker restart
    fi

    if [ ! -f "/usr/local/bin/docker-compose" ];then
        curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    fi
    echo '------------------------checkEnv,end------------------------'

    echo '------------------------enableIptables,start------------------------'
    #for centos7
    #先检查是否安装了iptables
    service iptables status
    #安装iptables
    yum install -y iptables
    #升级iptables
    yum update iptables
    #安装iptables-services
    yum install -y iptables-services

    # 开机启动
    systemctl enable iptables
    # 禁止开机启动
    # systemctl disable iptables

    service iptables restart

    #停止firewalld服务
    systemctl stop firewalld
    #禁用firewalld服务
    systemctl mask firewalld
    echo '------------------------enableIptables,end------------------------'
    # 开放1000:40000端
#    iptables -I INPUT -p tcp --dport 1:65535 -j ACCEPT
#    service iptables save
    echo '------------------------setIptables,end------------------------'

    echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
    service network restart
    service iptables restart
    service docker restart

    echo '------------------------ip_forward,end------------------------'
}

function main(){
    checkEnv
}

main
