#!/bin/bash
# created by myzero1@qq.com

function clean(){
    docker-compose down
    rm -rf workspace-pub/app/yii2-advanced
}

function set_cnf(){
    # 初始化nginx的配置
    cd nginx/conf
    for i in `ls ./*.dist`; do j=${i%.*}; \cp -rf $i $j;done;
    cd ../..

    cd nginx/conf/conf.d
    for i in `ls ./*.dist`; do j=${i%.*}; \cp -rf $i $j;sed -i "s/HOST_IP/${DEV_HOST_IP}/" $j;sed -i "s/ENV_IP/${ENV_IP}/" $j;done;
    cd ../../..

    # 初始化php-fpm的配置
    cd php-fpm/conf
    for i in `ls ./*.dist`; do j=${i%.*}; \cp -rf $i $j;done;
    cd ../..

    \cp -rf mysql-transfer/cnf/mysql-transfer-app.yml.dist mysql-transfer/cnf/mysql-transfer-app.yml
}

# checkBuilderOk "workspace-pub/app/yii2-advanced/backend/config/main-local.php"
function checkBuilderOk(){
    exitFlag=$1
    while [ 1 ];do
        if [ -f "$exitFlag" ];then
            docker-compose stop
            return 0
        fi;

        sleep 1
    done
}

function app_cnf(){
    # MYDEV=$(sed -n '/^APP_NAME/p' .env | sed "s/APP_NAME=\(.*\)$/\1/")
    # DEV_HOST_IP=$(sed -n '/^HOST_IP/p' .env | sed "s/HOST_IP=\(.*\)$/\1/")
    # ENV_IP=$(sed -n '/^ENV_IP/p' .env | sed "s/ENV_IP=\(.*\)$/\1/")
    # sm_app_id=$(sed -n '/^APP_ID/p' .env | sed "s/APP_ID=\(.*\)$/\1/")
    # sj_app_id=$(sed -n '/^SJ_APP_ID/p' .env | sed "s/SJ_APP_ID=\(.*\)$/\1/")
    # APP_ENV=$(sed -n '/^APP_ENV/p' .env | sed "s/APP_ENV=\(.*\)$/\1/")

    exitFlag=$1

    WAITING=1
    while [ $WAITING -lt 2 ]
    do
        echo 'building code...'$(date)

        # if [ -f "workspace-pub/app/autonym/common/config/main-local.php" ]
        # then
        #     echo 'building autonym is finished'

        #     sed -i "s/sm_mysql/${MYDEV}_mysql/" workspace-pub/app/autonym/common/config/main-local.php
        #     sed -i "s/sm-api/${DEV_HOST_IP}/" workspace-pub/app/autonym/common/config/main-local.php
        #     sed -i "s/sj-api/${DEV_HOST_IP}/" workspace-pub/app/autonym/common/config/main-local.php
        #     sed -i "s/smzz-api/${DEV_HOST_IP}/" workspace-pub/app/autonym/common/config/main-local.php

        #     sed -i "s/sm_app_id/${sm_app_id}/" workspace-pub/app/autonym/common/config/main-local.php
        #     sed -i "s/sj_app_id/${sj_app_id}/" workspace-pub/app/autonym/common/config/main-local.php

        #     if [ "${APP_ENV}" == "dev" ];then
        #         sed -i "s/return \[/return \['enableSMSVerification' => true,/" workspace-pub/app/autonym/backend/config/params-local.php
        #     fi 
        # fi

        echo '--------in building WAITING----------'$WAITING

        if [ -f "workspace-pub/app/yii2-advanced/common/config/main-local.php" ]
        then
            sed -i "s#mysql:host=localhost#mysql:host=mysql#" workspace-pub/app/yii2-advanced/common/config/main-local.php
            sed -i "s#'password' => ''#'password' => 'root'#" workspace-pub/app/yii2-advanced/common/config/main-local.php
        fi

        if [ -f "$exitFlag" ];then
            # all finished
            echo 'building all is finished'
            let WAITING=100 # build is finished
        fi

        sleep 5s
    done

}

function set_db(){
    # docker-compose start
    docker-compose down
    docker-compose up -d

    echo '-------- set_db sleep 3s ---------'
    sleep 3s

    # 因为windows共享文件夹不能修改里面的文件权限的原因，
    # 会导致mysql 容器设置密码和初始化不能正常完成。
    # 只能创建一个空密码的root本地用户。
    # linux系统中不会用这个问题
    # 所以我们需要运行下面命令,设置root的密码并运行远程连接,已经调整到了docker-compose中
    # docker-compose exec -T mysql mysql -hlocalhost -P3306 -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION";
    # docker-compose exec -T mysql mysql -hlocalhost -P3306 -uroot -e "FLUSH PRIVILEGES";


    # yum -y install zip unzip

    # 1 默认值，最慢，每次事务提交都要写入log并刷新到磁盘上，这是最保险的方式
    # 0 最快，每隔1S将log刷新到磁盘，但是不保证。
    # 2 折中的一种，事务提交会写入log，但是log刷新还是每秒一次，不保证。
    # https://blog.csdn.net/dvd_sun/article/details/87778577
    # unzip -o workspace-pub/app/autonym/sm.zip  -d mysql/data
    # docker-compose exec -T mysql mysql -hlocalhost -P3306 -uroot -e "set GLOBAL innodb_flush_log_at_trx_commit=0";
    # docker-compose exec -T mysql mysql -hlocalhost -P3306 -uroot -e'set names utf8;create database sm;';
    # docker-compose exec -T mysql mysql -hlocalhost -P3306 -uroot --default-character-set=utf8 sm < mysql/data/sm.sql;
    # docker-compose exec -T mysql mysql -hlocalhost -P3306 -uroot --default-character-set=utf8 --force sm < workspace-pub/app/autonym/docs/update-db-structure.sql;
    # docker-compose exec -T mysql mysql -hlocalhost -P3306 -uroot -e "set GLOBAL innodb_flush_log_at_trx_commit=1";

    docker-compose exec -T mysql mysql -hlocalhost -P3306 -uroot -e "set GLOBAL innodb_flush_log_at_trx_commit=0";
    docker-compose exec -T mysql mysql -hlocalhost -P3306 -uroot -e'set names utf8;create database yii2advanced;';
    docker-compose exec -T mysql mysql -hlocalhost -P3306 -uroot -e "set GLOBAL innodb_flush_log_at_trx_commit=1";
    docker-compose exec -T builder php /app/app/yii2-advanced/yii migrate/up
    # root:z1admin
    docker-compose exec -T mysql mysql -hlocalhost -P3306 -uroot -e "use yii2advanced;INSERT INTO yii2advanced.user (id, username, auth_key, password_hash, password_reset_token, email, status, created_at, updated_at, verification_token) VALUES ('1', 'admin', '1', '\$2y\$13\$9hxhuFkevbgldCd52rwWJ.EwGN7YgQ.Zyp24W/weKhrwCiYFtW3DC', '1', 'myzero1@qq.com', '10', '1654066014', '1654066014', '1');";

}

function main(){
    echo '--------1--clean----'
    clean

    echo '--------2--set_cnf----'
    set_cnf

    # 直接使用 docker-compose up 同时初始化多个service会导致mysql和mongo的初始化数据出问题，猜测这个问题和nfs有关。
    echo '--------3--init mysql and sleep 30s----'
    docker-compose up -d mysql
    sleep 30s
    docker-compose down

    echo '--------3.1--init mongodb and sleep 10s----'
    docker-compose up -d mongo
    sleep 10s
    docker-compose down

    echo '--------4--checkBuilderOk and docker-compose up----'
    checkBuilderOk "workspace-pub/app/yii2-advanced/common/config/main-local.php"&
    docker-compose up

    echo '--------5---app_cnf---'
    app_cnf "workspace-pub/app/yii2-advanced/common/config/main-local.php"

    echo '--------6--set_db----'
    set_db

    echo '--------7--recreate services----'
    docker-compose down
    docker-compose up -d

    echo '--------8--end----'
}

main