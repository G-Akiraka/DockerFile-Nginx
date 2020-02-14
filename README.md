### 编译 Nginx
> 特性：
1) 默认调优好 Nginx 配置
2) 默认添加虚拟配置，宿主机ip访问即可
3) 使用官方 nginx alpine 镜像安装
4) 新增 logrotate 将 nginx 日志按日期切割
5) 定义Nginx日志默认 JSON 输出，方便 ELK
> 目录说明：
1) Nginx项目路径 /data/wwwroot
2) Nginx日志路径 /data/wwwlogs
3) Nginx虚拟路径 /etc/nginx/conf.d
4) Nginx重写路径 /etc/nginx/conf.d/rewrite

#### 1、使用方法
```
git clone https://github.com/G-Akiraka/DockerFile-Nginx.git && cd DockerFile-Nginx
```
#### 2、开始构建 Docker Nginx 镜像 
```
docker build -f nginx_1.17.8-alpine.yml -t nginx:1.17.8 .
```
#### 3、运行 Nginx 容器
```
docker run -d -p 80:80 nginx:1.17.8
```
#### 4、查看 Nginx 容器是否运行
```
docker ps
# 调试容器，如果需要的话
docker run -it nginx:1.17.8 sh
```
#### 5、通过浏览器访问，默认可通过宿主机 ip 访问

### 通过 Dokcer compose 运行容器
```
# 启动并构建Nginx容器
sudo docker-compose up -d build
```