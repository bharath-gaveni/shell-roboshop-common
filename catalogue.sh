#!/bin/bash
source ./common.sh
name=catalogue
mongodb_Host_name=mongodb.bharathgaveni.fun
check_root
setup_logging
app_setup
nodejs_setup

cp $Dir_name/mongo.repo  /etc/yum.repos.d/mongo.repo &>>$log_file
validate $? "copying mongo.repo"

dnf install mongodb-mongosh -y &>>$log_file
validate $? "installing mongodb client to connect with mongodb and load the data"

index=$(mongosh $mongodb_Host_name --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $index -le 0 ]; then
mongosh --host $mongodb_Host_name </app/db/master-data.js &>>$log_file
    echo "Catalogue products are loaded to mongodb"
else
    echo -e "Database is already loaded with products so $Y Skipping $N" | tee -a $log_file
fi   

systemctl restart catalogue &>>$log_file
validate $? "restart catalogue"

print_time
