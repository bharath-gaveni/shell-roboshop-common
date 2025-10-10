#!/bin/bash
source ./common.sh
check_root
setup_logging

dnf install mysql-server -y &>>$log_file
validate $? "installing mysql-server"

systemctl enable mysqld &>>$log_file
validate $? "enabling mysqld"

systemctl start mysqld &>>$log_file
validate $? "start mysqld"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$log_file
validate $? "setupping root passowrd for mysql to connect"
