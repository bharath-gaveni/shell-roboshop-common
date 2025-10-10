#!/bin/bash
source ./common.sh
check_root
setup_logging

cp $Dir_name/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
validate $? "copying mongo.repo"

dnf install mongodb-org -y &>>$log_file
validate $? "installing mongodb"

systemctl enable mongod &>>$log_file
validate $? "enabling mongod"

systemctl start mongod &>>$log_file
validate $? "started mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$log_file
validate $? "Allowing remote connections to mongodb"

systemctl restart mongod &>>$log_file
validate $? "Restarting the mongodb"

print_time








