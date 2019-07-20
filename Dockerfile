FROM ubuntu:18.04
MAINTAINER akiraka@qq.com

ENV NGINX_VERSION   1.17.0
# 设置ENV
ENV SRC_PATH="/usr/local/src"
ENV NGINX_PATH="/usr/local/nginx"
ENV NGINX_CONF="/usr/local/nginx/conf"

# 使用阿里源
RUN sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

# 设置时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 更新系统\安装依赖包
RUN apt-get clean && apt-get update -y \
    && apt-get install -y --assume-yes apt-utils vim git bzip2 libssl-dev zlib1g-dev build-essential libtool \
    && rm -r /var/lib/apt/lists/* 

# 拉取git仓库
RUN git clone https://github.com/G-Akiraka/DockerFile-Nginx.git /usr/local/src

# 下载源码包

ADD http://nginx.org/download/nginx-1.17.1.tar.gz ${SRC_PATH}
ADD https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz ${SRC_PATH}
ADD https://github.com/jemalloc/jemalloc/releases/download/5.2.0/jemalloc-5.2.0.tar.bz2 ${SRC_PATH}
# 解压压缩包
WORKDIR ${SRC_PATH}
RUN tar xvf nginx-1.17.1.tar.gz \
    && tar xvf pcre-8.43.tar.gz \
    && tar xvf jemalloc-5.2.0.tar.bz2

# 编译 jemalloc
WORKDIR ${SRC_PATH}/jemalloc-5.2.0
RUN ./configure
RUN make && make install
RUN ln -s /usr/local/lib/libjemalloc.so.2 /usr/lib/libjemalloc.so.1 \
    && echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf
RUN ldconfig

# 编译 Nginx
RUN useradd -M -s /sbin/nologin www
WORKDIR ${SRC_PATH}/nginx-1.17.1
RUN ./configure --prefix=${NGINX_PATH} --user=www --group=www --with-http_stub_status_module \
    --with-http_v2_module --with-http_ssl_module --with-http_gzip_static_module --with-http_realip_module \
    --with-http_flv_module --with-http_mp4_module --with-pcre=../pcre-8.43 --with-pcre-jit --with-ld-opt='-ljemalloc'
RUN make && make install

# Nginx 后续配置
WORKDIR ${SRC_PATH}
RUN /bin/cp -rf conf/* ${NGINX_CONF} \
    && chown -R www:www ${NGINX_PATH} \
    && mkdir -p /data/wwwlogs

# 删除源码文件
RUN /bin/rm -rf ${SRC_PATH}/*

# 设置环境变量
ENV PATH /usr/local/nginx/sbin:$PATH

# 进入 Nginx 工作目录
WORKDIR ${NGINX_PATH}

# 配置端口
EXPOSE 80 443

# 添加开机启动项
CMD /bin/sh -c 'nginx -g "daemon off;"'