# DockerFile-Nginx
＃使用方法
```
wget xxx
```
# 开始安装
```
docker build -f 文件位置 -t ubuntu/nginx:v1.17.0 .
```
# 运行容器
```
docker run -d -p 80:80 ubuntu/nginx:v1.17.0
```
# 查看是否运行
```
docker ps
```
# 通过浏览器访问
