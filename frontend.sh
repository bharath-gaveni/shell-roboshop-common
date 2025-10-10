#!/bin/bash
source ./common.sh

check_root
setup_logging

dnf module disable nginx -y
validate $? "disabling the defaut nginx"

dnf module enable nginx:1.24 -y
validate $? "enabling nginx version 1.24"

dnf install nginx -y
validate $? "installing nginx"

systemctl enable nginx 
validate $? "enabling nginx"

systemctl start nginx 
validate $? "start nginx"

rm -rf /usr/share/nginx/html/* 
validate $? "removing the default content in html directory"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
validate $? "dowloading the frontend in tmp location"

cd /usr/share/nginx/html 
validate $? "changing location to html directory"

unzip /tmp/frontend.zip
validate $? "unzipping the frontend code in html dir location"

cp $Dir_name/nginx.conf /etc/nginx/nginx.conf
validate $? "copying nginx.conf"

systemctl restart nginx 
validate $? "restart nginx"

print_time