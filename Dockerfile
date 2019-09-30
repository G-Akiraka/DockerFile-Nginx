FROM alpine:3.10.2
MAINTAINER akiraka@qq.com

#   设置ENV
ENV SRC_PATH="/usr/local/src"
ENV NGINX_PATH="/usr/local/nginx"
ENV NGINX_CONF="/usr/local/nginx/conf"
#   设置容器中文，否则中文乱码
ENV LANG C.UTF-8
#   定义时区参数
ENV TZ Asia/Shanghai

#   使用阿里源与设置时间
RUN sed -i s@/dl-cdn.alpinelinux.org/@/mirrors.aliyun.com/@g /etc/apk/repositories \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone \
    #   更新系统\安装依赖包
    && apk update \
    && apk add fontconfig tzdata logrotate gcc g++ make openssl-dev \
    && rm -rf /tmp/* /var/cache/apk/*

#   准备编译要的文件
ADD src/pcre-8.43.tar.gz ${SRC_PATH}
ADD src/nginx-1.17.4.tar.gz ${SRC_PATH}
ADD src/jemalloc-5.2.0.tar.bz2 ${SRC_PATH}

#   编译 jemalloc
WORKDIR ${SRC_PATH}/jemalloc-5.2.0
RUN ./configure
RUN make && make install
RUN ln -s /usr/local/lib/libjemalloc.so.2 /usr/lib/libjemalloc.so.1 \
    && echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf
RUN ldconfig

# 编译 Nginx
RUN useradd -M -s /sbin/nologin www
WORKDIR ${SRC_PATH}/nginx-1.17.4
RUN ./configure --prefix=${NGINX_PATH} --user=www --group=www --with-http_stub_status_module \
    --with-http_v2_module --with-http_ssl_module --with-http_gzip_static_module --with-http_realip_module \
    --with-http_flv_module --with-http_mp4_module --with-pcre=../pcre-8.43 --with-pcre-jit --with-ld-opt='-ljemalloc'
RUN make && make install

#   删除源码文件
RUN /bin/rm -rf ${SRC_PATH}/*

#   Nginx 复制配置文件
ADD conf ${NGINX_CONF}

#   创建 Nginx 运行目录与授权
RUN mkdir -p /data/wwwlogs \
    && chown -R www:www ${NGINX_PATH} \
    && cat > /etc/logrotate.d/nginx << EOF
/data/wwwlogs/*nginx.log {
  daily
  rotate 5
  missingok
  dateext
  compress
  notifempty
  sharedscripts
  postrotate
    [ -e /var/run/nginx.pid ] && kill -USR1 \`cat /var/run/nginx.pid\`
  endscript
}
EOF

#   默认进入 Nginx 工作目录
WORKDIR ${NGINX_PATH}

#   设置环境变量
ENV PATH /usr/local/nginx/sbin:$PATH

#   配置端口
EXPOSE 80 443

#   添加开机启动项
CMD /bin/sh -c 'nginx -g "daemon off;"'
