#!/bin/bash
# https://github.com/myzero1/yii2-app-advanced-aliyun-shell
# https://gitee.com/myzero1/yii2-app-advanced-aliyun-shell

set -e # 一但有任何一个语句返回非真的值，则退出bash,需要取消用set +e
set -u # 当使用未初始化的变量时，让bash自动退出

function updateRequire(){
    echo -e "\033[40;32m >>>>>>--------------------------updateRequire------------------------- \033[0m" # 绿色
    projectName=$1
    mirror=$2
    cd $projectName
    composer config --unset repos.0 -vvv
    composer config repo.packagist composer $mirror -vvv
    #composer config --unset repos.packagist  -vvv
    composer --no-update --dev remove symfony/browser-kit codeception/verify codeception/module-filesystem codeception/module-yii2 codeception/module-asserts codeception/codeception yiisoft/yii2-faker -vvv
    composer --no-update require yidas/yii2-bower-asset -vvv
    composer update -vvv
    # sed -i "s/'\@bower/'\@bower' => '\@vendor\/yidas\/yii2-bower-asset\/bower',\n\t\t\/\/'@bower/g" common\\config\\main.php
    # sed -i "s/'\@bower' => '\@vendor\/bower-asset/'\@bower' => '\@vendor\/yidas\/yii2-bower-asset\/bower',\n\t\t\/\/'@bower' => '@bak-vendor\/bower-asset/g" common\\config\\main.php
    yidas=`cat common/config/main-local.php | grep 'yidas' | grep -v 'grep' |  wc -l`
    if [ $yidas -eq 0 ] ; then
        # sed -i "2a\    'aliases' => [" common\\config\\main-local.php
        # sed -i "3a\        '@bower' => '@vendor/yidas/yii2-bower-asset/bower'," common\\config\\main-local.php
        # sed -i "4a\    ]," common\\config\\main-local.php

        sed -i "s/];/    'aliases' => [\n        '@bower' => '@vendor\/yidas\/yii2-bower-asset\/bower',\n    ],\n];/" common/config/main-local.php
    fi
}

function initProject(){
    echo -e "\033[40;32m >>>>>>--------------------------initProject------------------------- \033[0m" # 绿色
    projectName=$1
    cd $projectName
    php init --env=Development --overwrite=n
    cd ../
}

function createProject(){
    echo -e "\033[40;32m >>>>>>--------------------------createProject------------------------- \033[0m" # 绿色
    projectName=$1

    # composerHomeInfo=`composer config -l -g | grep home`
    # composerHome=$(echo $composerHomeInfo | sed -n 's/\[//p' | sed -n 's/\]//p' | sed -n 's/home//p' | sed 's/ //')
    # echo '{}' > ${composerHome}'\\composer.json'

    set +e
    # timeout 30 composer create-project yiisoft/yii2-app-advanced $projectName -vvv #这命令最多执行30s
    timeout 30 composer create-project --no-install yiisoft/yii2-app-advanced $projectName -vvv #这命令最多执行30s
    set -e
}

function updateGlobalMirrors(){
    echo -e "\033[40;32m >>>>>>--------------------------updateGlobalMirrors------------------------- \033[0m" # 绿色
    mirror=$1
    # composer init -n
    composer clearcache -vvv
    composer config -g repo.packagist composer $mirror -vvv
}

# readInput "请输入环境ID(两位数字，回车默认为11)" "你入环境的ID错误" "/^[0-9]\{2,2\}$/p" "11"
function readInput(){
    msg=$1
    errMsg=$2
    pattern=$3
    default=$4

    for ((VAR=1;;VAR++))
    do
        # read  -p "请输入环境ID(两位数字，回车默认为11)：" id
        read  -p "${msg}：" input
        if [ -z "${input}" ];then
            input=$default
        fi

        if [ -n "$(echo $input| sed -n ${pattern})" ];then
            break
        else
            # echo -e "\033[40;32m \xE2\x9C\x94 对 \033[0m" # 绿勾勾
            # echo -e "\033[40;31m \xE2\x9D\x8C 错 \033[0m" # 红叉叉
            echo -e "\033[40;31m \xE2\x9D\x8C ${errMsg}[${input}] \033[0m" # 红叉叉
        fi
    done
}


function main(){
    # readInput "请输入工作区(有效的linux相对目录，回车默认为.)" "你输入的工作区错误" "/^\/(\w+\/?)+$/p" "./"
    readInput "请输入工作区(有效的linux相对目录，回车默认为./)" "你输入的工作区错误" "/^.*$/p" "./"
    myWorkspace=$input
    readInput "请输入项目(目录)名字(最少3个[字母数组横线]，回车默认为yii2-advanced)" "你输入的项目(目录)名字错误" "/^[a-zA-Z0-9\-]\{3,\}$/p" "yii2-advanced"
    myProjectName=$input
    readInput "请输入操作类型(install/update,默认install)" "你输入的操作类型错误" "/^install\|update$/p" "install"
    myOperation=$input
    readInput "请输入镜像地址(默认https://mirrors.aliyun.com/composer/,更多镜像https://packagist.org/mirrors)" "你输入的镜像地址错误" "/^https\?:\/\/.\+$/p" "https://mirrors.aliyun.com/composer/"
    myMirrors=$input

    echo '######################################'
    echo -e "\033[40;32m \xE2\x9C\x94 你输入的工作为：${myWorkspace} \033[0m" # 绿勾勾
    echo -e "\033[40;32m \xE2\x9C\x94 你输入的项目(目录)名字为：${myProjectName} \033[0m" # 绿勾勾
    echo -e "\033[40;32m \xE2\x9C\x94 你输入的操作类型为：${myOperation} \033[0m" # 绿勾勾
    echo -e "\033[40;32m \xE2\x9C\x94 你输入的镜像地址为：${myMirrors} \033[0m" # 绿勾勾
    echo '######################################'

    echo -e "\033[40;32m >>>>>>--------------------------start------------------------- \033[0m" # 绿色

    start_time=`date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"`

    echo -e "\033[40;32m >>>>>>--------------------------go workspace------------------------- \033[0m" # 绿色
    cd $myWorkspace

    updateGlobalMirrors $myMirrors

    if [ $myOperation = "install" ];then
        if [ -d "$myProjectName" ]; then
            echo -e "\033[40;31m \xE2\x9D\x8C 项目目录已经存在，创建新项目失败 \033[0m" # 红叉叉
            exit 1;
        fi

        createProject $myProjectName
        initProject $myProjectName
    fi

    updateRequire $myProjectName $myMirrors

    finish_time=`date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"`
    duration=$(($(($(date +%s -d "$finish_time")-$(date +%s -d "$start_time")))))

    echo -e "\033[40;32m \xE2\x9C\x94 ---finish---start_time:${start_time}---finish_time:${finish_time}---duration:${duration}s------ \033[0m" # 绿色
}

main
