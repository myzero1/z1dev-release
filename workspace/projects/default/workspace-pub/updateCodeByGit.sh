#!/bin/bash
successMsg="Already up-to-date."
successMsg2="Already up to date." 

export GOPATH=/app/golang

while [ 1 -le 2 ]
do
        # autonym
        cd /app/app/autonym
        tmpMsg=$(git pull)
        if [[ "$tmpMsg" == "$successMsg" || "$tmpMsg" == "$successMsg2" ]]
                then
                echo 'autonym no update'
        else
                composer update -vvv
        fi

        # autonymIncrement
        cd /app/app/autonymIncrement
        tmpMsg=$(git pull)
        if [[ "$tmpMsg" == "$successMsg" || "$tmpMsg" == "$successMsg2" ]]
                then
                echo 'autonymIncrement no update'
        else
                composer update -vvv
        fi

        # autonymomc
        cd /app/app/autonymomc
        tmpMsg=$(git pull)
        if [[ "$tmpMsg" == "$successMsg" || "$tmpMsg" == "$successMsg2" ]]
                then
                echo 'autonymomc no update'
        else
                composer update -vvv
        fi

        # Center
        cd /app/golang/src/Center
        tmpMsg=$(git pull)
        if [[ "$tmpMsg" == "$successMsg" || "$tmpMsg" == "$successMsg2" ]]
                then
                echo 'Center no update'
        else
                cd /app/golang/src/Center/Core/Main/
                # go build -o centerMain Main.go
                CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o centerMain Main.go
        fi

        sleep 15s
        # sleep 10s #秒
        # sleep 3m #分
        # sleep 1h #时
done

