#!/bin/bash
N="\e[0m"
R="\e[0;31m"
G="\e[0;32m"
Y="\e[0;33m"
Dir_name=$PWD
# if root user id -u = 0 other than root user id -u = 1001 etc
check_root() {
    id=$(id -u)
    if [ $id -ne 0 ]; then
        echo -e "$R please execute this script with root user access privilage $N"
        exit 1
    fi
}

log_folder=/var/log/shell-roboshop-common
script_name=$(echo $0 | cut -d "." -f1)
log_file=$log_folder/$script_name.log

setup_logging() {
    start_time=$(date +%s)
    mkdir -p $log_folder
    echo "script $0 execution starts at time $(date)" | tee -a $log_file
}

validate() {
    if [ $1 -ne 0 ]; then
        echo -e "$2 $R Failed $N" | tee -a $log_file
        exit 1
    else
        echo -e "$2 $G Success $N" | tee -a $log_file
    fi
}

app_setup() {
    
    mkdir -p /app &>>$log_file
    validate $? "creating app directory"
    
    curl -o /tmp/$name.zip https://roboshop-artifacts.s3.amazonaws.com/$name-v3.zip &>>$log_file
    validate $? "dowloading the $name code to app directory"
    
    cd /app &>>$log_file
    validate $? "changing to app directory"
    
    rm -rf /app/* &>>$log_file
    validate $?  "remove the app $name code from app directory"
    
    unzip /tmp/$name.zip &>>$log_file
    validate $? "unzipping the $name code in app directory"
    
    cd /app &>>$log_file
    validate $? "changing to app directory"
    
}

java_setup() {

    dnf install maven -y &>>$log_file
    validate $? "installing maven which inturn downloads java"
    
    mvn clean package &>>$log_file
    validate $? "installing dependencies based on pom.xml"
    
    mv target/shipping-1.0.jar shipping.jar &>>$log_file
    validate $? "move target/shipping-1.0 jar to /app directory and change the name"
}


nodejs_setup() {
    
    dnf module disable nodejs -y &>>$log_file
    validate $? "disabling default nodejs"
    
    dnf module enable nodejs:20 -y &>>$log_file
    validate $? "enabling nodejs:20 version"
    
    dnf install nodejs -y &>>$log_file
    validate $? "installing nodejs"
    
    npm install &>>$log_file
    validate $? "installing dependencies based on package.json"
}

python_setup() {
    dnf install python3 gcc python3-devel -y &>>$log_file
    validate $? "installing python"

    pip3 install -r requirements.txt &>>$log_file
    validate $? "installing dependencies based on requirements.txt"

}

systemd_setup() {
    id roboshop
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file
        validate $? "user added succesfully"
    else
        echo -e "user already exists $Y Skipping $N" | tee -a $log_file
    fi
    
    cp $Dir_name/$name.service /etc/systemd/system/$name.service &>>$log_file
    validate $? "copying the service file"
    
    systemctl daemon-reload &>>$log_file
    validate $? "daemon-reload to recognise the new service"
    
    systemctl enable $name &>>$log_file
    validate $? "enabling $name"
    
    systemctl start $name &>>$log_file
    validate $? "starting the $name"
    
}

print_time() {
    end_time=$(date +%s)
    total_time=$(($end_time-$start_time))
    echo "total time taken to execute the script $0 is $total_time seconds" | tee -a $log_file
}