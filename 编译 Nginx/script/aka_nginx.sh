#!/bin/sh
#   启动 crontab 服务
service cron start
#   启动 rsyslog 服务
service rsyslog start
#   启动 nginx
/bin/sh -c 'nginx -g "daemon off;"'