#!/bin/bash
source ./common.sh
check_root
setup_logging

cp $Dir_name/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$log_file
validate $? "copying the rabbitmq.repo"

dnf install rabbitmq-server -y &>>$log_file
validate $? "installing rabbitmq"

USER_NAME=roboshop
USER_PASS=roboshop123

rabbitmqctl list_users | grep -w "$USER_NAME" &>>$log_file
if [ $? -ne 0 ]; then
 rabbitmqctl add_user $USER_NAME $USER_PASS &>>$log_file
 validate $? "username and password added"
else
    echo -e "username and password is already set $Y Skipping $N"  
fi      

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
validate $? "settingup permissions to allow all traffic to receive que"
print_time