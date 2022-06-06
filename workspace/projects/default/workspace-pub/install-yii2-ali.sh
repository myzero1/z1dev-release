#!/bin/bash

composer self-update --2

mirrorsUrl='https://mirrors.aliyun.com/composer/'
# mirrorsUrl='https://mirrors.cloud.tencent.com/composer/'

echo '----------------------------------------------clearcache'
# composer clearcache -vvv
echo '-----------------------------------------------g repo.packagist'
composer config -g repo.packagist composer $mirrorsUrl -vvv
#composer config -g --unset repos.packagist  -vvv
echo '----------------------------------------------cd shenji'
cd shenji
echo '----------------------------------------------unset repos.0'
composer config --unset repos.0 -vvv
echo '----------------------------------------------repo.packagist'
composer config repo.packagist composer $mirrorsUrl -vvv
#composer config --unset repos.packagist  -vvv
echo '---------------------------------------------- --dev remove'
composer --no-update --dev remove symfony/browser-kit codeception/verify codeception/module-filesystem codeception/module-yii2 codeception/module-asserts codeception/codeception yiisoft/yii2-faker codeception/base phpunit/phpunit -vvv
echo '----------------------------------------------require'
composer --no-update require yidas/yii2-bower-asset -vvv
echo '----------------------------------------------install'
composer update -vvv
echo '----------------------------------------------init dev overwrite'
php init --env=Development --overwrite=n
echo '----------------------------------------------@bower'
if [[ "${PWD##*/}" == "whsj-rebuild" ]]
then
    echo 'it is whsj-rebuild'
else
    sed -i "s/return \[/return \[\n    'aliases' => \[\n        '@bower' => '\@vendor\/bower-asset',\n        '\@bower' => '\@vendor\/yidas\/yii2-bower-asset\/bower',\n    \],/g" common/config/main-local.php
fi
