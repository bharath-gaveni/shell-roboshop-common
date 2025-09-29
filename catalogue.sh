#!/bin/bash
source ./common.sh
name=catalogue

check_root
setup_logging
app_setup
nodejs_setup
systemd_setup

cp $Dir_name/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
validate $? "copying the mongo.repo"

dnf install mongodb-mongosh -y &>>$log_file
validate $? "installing mongodb cilent to connect with mongodb DB"

index=$(mongosh $mongodb_Host_name --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $index -le 0 ]; then
mongosh --host $mongodb_Host_name </app/db/master-data.js &>>$log_file
else
    echo "Database is already loaded with Catalogue DB products"
fi
restart_app
print_time





