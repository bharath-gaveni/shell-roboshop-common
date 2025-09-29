#!/bin/bash

source ./common.sh
check_root
setup_logging

cp $Dir_name/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$log_file
validate $? "copying the repo"

dnf install rabbitmq-server -y &>>$log_file
validate $? "installing the rabbitmq"

systemctl enable rabbitmq-server &>>$log_file
validate $? "enabling the rabbitmq"

systemctl start rabbitmq-server &>>$log_file
validate $? "start the rabbitmq"

USER_NAME="roboshop"
USER_PASS="roboshop123"

rabbitmqctl list_users | grep -w "$USER_NAME" &>>$log_file
if [ $? -ne 0 ]; then
rabbitmqctl add_user $USER_NAME $USER_PASS &>>$log_file
validate $? "setting user and password"
else
    echo "User $USER_NAME already exists"
fi  

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
validate $? "setting up permissions to take que message from all components"

print_time