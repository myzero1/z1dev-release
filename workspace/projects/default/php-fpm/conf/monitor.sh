#!/bin/bash
# author myzero1 myzero1@qq.com

eg(){
    while [ 1 ]; do
        echo "$(date)---from monitor" >> /var/log/mycrontab

        sleep 15s
    done

    # while [ 1 ]; do
    #     count=`ps axu | grep -w "php /usr/share/nginx/app/app/shenji/yii queue/listen" | grep -v "grep" | wc -l`

    #     if [ $count -lt 10 ];then
    #         gap=`expr 10 - $count`
    #         idx=0
    #         while [ $idx -lt $gap ]; do
    #             php /usr/share/nginx/app/app/shenji/yii queue/listen &
    #             idx=`expr idx + 1`
    #             sleep 2s
    #         done
    #     fi

    # sleep 15s
    # done
}

main(){
    echo 'monitor starting......'

    eg
}

main
