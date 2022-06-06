FROM alpine:3.14

MAINTAINER "qxw"

# https://www.cnblogs.com/yangzp/p/14609641.html
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update\
    && apk add --no-cache \
        bash \
    && mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# 设置时区为上海
RUN apk add tzdata \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone \
&& apk del tzdata

#更新源
RUN apk update

# ##################### custom,start #####################