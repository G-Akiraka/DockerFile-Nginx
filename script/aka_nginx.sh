#!/bin/sh
#   启动 nginx
/bin/sh -c 'nginx -g "daemon off;"'
#   启动 crontab 服务
service cron start