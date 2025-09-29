#!/bin/bash

source ./common.sh

check_root

dnf module disable redis -y &>>$log_file
validate $? "disabled redis"

dnf module enable redis:7 -y &>>$log_file
validate $? "enabled redis 7 version"

dnf install redis -y &>>$log_file
validate $? "installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
validate $? "Allowing remote connections to redis and update proctected mode to no"

systemctl enable redis &>>$log_file
validate $? "enabling redis"

systemctl start redis &>>$log_file
validate $? "started redis"