#!/bin/bash

source ./common.sh
check_root

dnf install mysql-server -y &>>$log_file
validate $? "installing mysql-server"

systemctl enable mysqld &>>$log_file
validate $? "enabled mysql"

systemctl start mysqld &>>$log_file
validate $? "started mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$log_file
validate $? "Settingup password for mysql DB as root is default user"

print_time
