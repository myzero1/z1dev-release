#!/bin/bash
# created by qxw

function addIP(){
    echo '------------------------add addIP,start------------------------'
    envIP=$1

    # myPwd=$PWD
    # cd /etc/sysconfig/network-scripts/

    yum install -y net-tools

    # etheName=$(route -n | grep ^0.0.0.0 | route -n | grep ^0.0.0.0 | grep 'UG    0' | awk '{print $8}')
    # etheName=$(route -n | grep ^0.0.0.0 | grep 'UG    0' | awk '{print $8}')
    # etheName=$(route -n | grep ^0.0.0.0 | grep 'UG    ' | awk '{print $8}')
    etheName=$(route -n | grep ^0.0.0.0 | grep 'UG    ' | sed -n '1p' | awk '{print $8}')
    etheFile="/etc/sysconfig/network-scripts/ifcfg-${etheName}"
    etheFileNew="/etc/sysconfig/network-scripts/ifcfg-${etheName}-$envIP"
    \cp -f $etheFile $etheFileNew

    ipStr="IPADDR=\"${envIP}\""
    sed -i "s/IPADDR=.*/$ipStr/g" $etheFileNew
    ifup "ifcfg-${etheName}-$envIP"
    # service network restart
    # cd $myPwd
    echo '------------------------add addIP,end------------------------'
}

function readyEnvfile(){
    echo '------------------------readyEnvfile,start------------------------'
    # SJ_APP_ID=12
    # APP_ID=11
    # APP_NAME=sm_dev
    # HOST_IP=172.16.62.248
    appId=$myEnvId
    sjId=$(expr $appId + 1)

    echo "" > .env
    echo "COMPOSE_PROJECT_NAME=${myEnvName}_" >> .env
    echo "APP_ID=${appId}" >> .env
    echo "APP_NAME=${myEnvName}_" >> .env
    echo "HOST_IP=${myHostIp}" >> .env
    echo "ENV_IP=${myEnvIp}" >> .env
    echo "APP_ENV=${myEnvType}" >> .env

    echo '------------------------readyEnvfile,end------------------------'
}

# readInput "请输入环境ID(两位数字，回车默认为11)" "你入环境的ID错误" "/^[0-9]\{2,2\}$/p"
function readInput(){
    msg=$1
    errMsg=$2
    pattern=$3
    default=$4

    for ((VAR=1;;VAR++))
    do
        # read  -p "请输入环境ID(两位数字，回车默认为11)：" id
        read  -p "${msg}：" envId
        if [ -z "${envId}" ];then
            envId=$default
        fi

        if [ -n "$(echo $envId| sed -n ${pattern})" ];then
            break
        else
            # echo -e "\033[40;32m \xE2\x9C\x94 对 \033[0m" # 绿勾勾
            # echo -e "\033[40;31m \xE2\x9D\x8C 错 \033[0m" # 红叉叉
            echo -e "\033[40;31m \xE2\x9D\x8C ${errMsg}[${envId}] \033[0m" # 红叉叉
        fi
    done
}


function main(){
    readInput "请输入环境名字(1-9个字母，回车默认为dev)" "你入环境的名字错误" "/^[a-zA-Z]\{1,9\}$/p" "dev"
    myEnvName=$envId
    readInput "请输入环境ID(两位数字，回车默认为11)" "你入环境的ID错误" "/^[0-9]\{2,2\}$/p" "11"
    myEnvId=$envId
    readInput "请输入环境宿主机的IP(回车默认为192.168.56.135)" "你入环境的宿主机的IP错误" "/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/p" "192.168.56.135"
    myHostIp=$envId
    readInput "请输入环境的IP(回车默认为192.168.135.11)" "你入环境的IP错误" "/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/p" "192.168.135.11"
    myEnvIp=$envId
    readInput "请输入环境类型(dev/prod,回车默认为 prod)" "你入环境类型错误" "/^dev\|prod$/p" "prod"
    myEnvType=$envId
    echo '######################################'
    echo -e "\033[40;32m \xE2\x9C\x94 你输入的环境名字为：${myEnvName} \033[0m" # 绿勾勾
    echo -e "\033[40;32m \xE2\x9C\x94 你输入的环境ID为：${myEnvId} \033[0m" # 绿勾勾
    echo -e "\033[40;32m \xE2\x9C\x94 环境宿主机的IP为：${myHostIp} \033[0m" # 绿勾勾
    echo -e "\033[40;32m \xE2\x9C\x94 环境的IP为：${myEnvIp} \033[0m" # 绿勾勾
    echo -e "\033[40;32m \xE2\x9C\x94 环境类型：${myEnvType} \033[0m" # 绿勾勾
    echo '######################################'

    readyEnvfile

}

main
