#!/bin/bash
N="\e[0m"
R="\e[0;31m"
G="\e[0;32m"
Y="\e[0;33m"
check_root() {
    id=$(id -u)
    if [ $id -ne 0 ]; then
        echo -e "$R Please execute this script as root user $N"
        exit 1
    fi
}
Dir_name=$PWD
log_folder=/var/log/roboshop-script
script_name=$(echo $0 | cut -d "." -f1)
log_file=$log_folder/$script_name.log

mkdir -p $log_folder
start_time=$(date +%s)
echo "script execution started at time: $(date)" | tee -a $log_file

validate() {
    if [ $1 -ne 0 ]; then
        echo -e "$2 is $R FAILED $N" 
        exit 1
    else
        echo -e "$2 is $G SUCCESS $N"
    fi        
}

print_time() {
    end_time=$(date +%s)
    total_time=$(($end_time-$start_time))
    echo "total time taken to execute this script is $total_time seconds"
}




