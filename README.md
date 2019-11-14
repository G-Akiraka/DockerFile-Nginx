### 编译Nginx 1.17.5版本
> 特性：
1) 默认调优好Nginx配置
2) 默认添加虚拟配置，宿主机ip访问即可
3) 类传统部署方式，源码编译安装
4) 新增logrotate将nginx日志按日期切割
5）定义Nginx日志默认JSON输出，方便ELK
> 目录说明：
1) Nginx项目路径 /data/wwwroot
2) Nginx日志路径 /data/wwwlogs
3) Nginx虚拟路径 /usr/local/nginx/conf/vhost
4) Nginx重写路径 /usr/local/nginx/conf/rewrite
> 其他说明：
1) 默认创建www用户组与用户
2) Nginx 默认运行用户组与用户 www
3) 如遇权限问题，请将项目授权chown -R www:www 项目目录
#### 1、使用方法
```
git clone https://github.com/G-Akiraka/DockerFile-Nginx.git && cd DockerFile-Nginx
```
#### 2、开始构建Docker Nginx镜像 
```
docker build -f Build.yml -t nginx:1.17.5 .
```
#### 3、运行Nginx容器
```
docker run -d -p 80:80 nginx:1.17.5
```
#### 4、查看Nginx容器是否运行
```
docker ps
# 调试容器，如果需要的话
docker run -it nginx:1.17.5 /bin/bash
```
#### 5、通过浏览器访问，默认可通过宿主机ip访问

### 通过Dokcer compose运行容器
```
# 启动并构建Nginx容器
sudo docker-compose up -d build
```