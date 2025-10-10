#!/bin/bash
source ./common.sh

check_root
setup_logging

dnf module disable nginx -y &>>$log_file
validate $? "disabling the defaut nginx"

dnf module enable nginx:1.24 -y &>>$log_file
validate $? "enabling nginx version 1.24"

dnf install nginx -y &>>$log_file
validate $? "installing nginx"

systemctl enable nginx &>>$log_file
validate $? "enabling nginx"

systemctl start nginx &>>$log_file
validate $? "start nginx"

rm -rf /usr/share/nginx/html/* &>>$log_file
validate $? "removing the default content in html directory"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$log_file
validate $? "dowloading the frontend in tmp location"

cd /usr/share/nginx/html &>>$log_file
validate $? "changing location to html directory"

unzip /tmp/frontend.zip &>>$log_file
validate $? "unzipping the frontend code in html dir location"

cp $Dir_name/nginx.conf /etc/nginx/nginx.conf &>>$log_file
validate $? "copying nginx.conf"

systemctl restart nginx &>>$log_file
validate $? "restart nginx"

print_time