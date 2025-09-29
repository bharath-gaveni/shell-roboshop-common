#!/bin/bash
source ./common.sh
name=shipping

check_root
app_setup
java_setup
systemd_setup
dnf install mysql -y &>>$log_file
validate $? "installing mysql client to load data to mysql DB"

mysql -h $mysql_Host_name -uroot -pRoboShop@1 -e 'use cities' &>>$log_file
if [ $? -ne 0 ]; then
    mysql -h $mysql_Host_name -uroot -pRoboShop@1 < /app/db/schema.sql &>>$log_file
    mysql -h $mysql_Host_name -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$log_file
    mysql -h $mysql_Host_name -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$log_file
else
    echo "Shipping data is already loaded"
fi  
restart_app
print_time