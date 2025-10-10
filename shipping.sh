#!/bin/bash
source ./common.sh
name=shipping
Host_name=mysql.bharathgaveni.fun
check_root
app_setup
java_setup
systemd_setup

dnf install mysql -y &>>$log_file
validate $? "installing mysql client to load data into mysql"

mysql -h $Host_name -uroot -pRoboShop@1 -e 'use cities' &>>$log_file
if [ $? -ne 0 ]; then
mysql -h $Host_name -uroot -pRoboShop@1 < /app/db/schema.sql &>>$log_file
mysql -h $Host_name -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$log_file
mysql -h $Host_name -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$log_file
else
    echo -e "Data is already loaded so $Y Skipping $N" | tee -a $log_file
fi

print_time

