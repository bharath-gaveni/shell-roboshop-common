#!/bin/bash
source ./common.sh
name=user

check_root
app_setup
nodejs_setup
systemd_setup

cp $Dir_name/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
validate $? "copying the mongo.repo"


restart_app

print_time





