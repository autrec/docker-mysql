FROM alpine
#声明作者
LABEL maintainer="mysql docker Autre <mo@autre.cn>"
##设置变量
#ENV MYSQL_ROOT_PASSWORD=password \
#    MYSQL_DATABASE=test \
#    MYSQL_USER=test \
#    MYSQL_PASSWORD=test
ARG MYSQL_ROOT_PASSWORD=sdjfoweifjiwej
ARG MYSQL_DATABASE=test
ARG MYSQL_USER=test
ARG MYSQL_PASSWORD=test

#升级内核及软件
RUN apk update \
    && apk upgrade \
    ##设置时区
    && apk --update add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del tzdata \
    ## 清除安装软件及缓存
    && rm -rf /tmp/* /var/cache/apk/*
##安装msyql
RUN apk --update add --no-cache mysql \
    && rm -rf /tmp/* /var/cache/apk/*
#进入工作目录
WORKDIR /run/mysqld
##运行数据库
RUN mysql_install_db --user=root > /dev/null
RUN mysqld --user=root --bootstrap --verbose=0

##载入配置文件
COPY my.cnf /etc/mysql/my.cnf
##挂载目录
VOLUME ["/var/lib/mysql","/var/lib/mysql/mysql-bin"]

#开放端口
EXPOSE 3306
CMD ["mysqld","--user=root","--console","daemon off;"]
