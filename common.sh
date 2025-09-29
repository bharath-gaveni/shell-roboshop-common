#!/bin/bash
N="\e[0m"
R="\e[0;31m"
G="\e[0;32m"
Y="\e[0;33m"
check_root(){
    id=$(id -u)
    if [ $id -ne 0 ]; then
        echo -e "$R Please execute this script as root user $N"
        exit 1
    fi
}

mongodb_Host_name=mongodb.bharathgaveni.fun
mysql_Host_name=mysql.bharathgaveni.fun
Dir_name=$PWD
log_folder=/var/log/roboshop-script
script_name=$(echo $0 | cut -d "." -f1)
log_file=$log_folder/$script_name.log

# Function to setup logging (run after check_root)
setup_logging() {
    mkdir -p "$log_folder"
    start_time=$(date +%s)
    echo "script execution started at time: $(date)" | tee -a "$log_file"
}


validate() {
    if [ $1 -ne 0 ]; then
        echo -e "$2 is $R FAILED $N" | tee -a $log_file
        exit 1
    else
        echo -e "$2 is $G SUCCESS $N" | tee -a $log_file
    fi
}

app_setup() {
    mkdir -p /app &>>$log_file
    validate $? "created the app directory"
    
    curl -o /tmp/$name.zip https://roboshop-artifacts.s3.amazonaws.com/$name-v3.zip &>>$log_file
    validate $? "dowloading the $name code"
    
    cd /app &>>$log_file
    validate $? "changing to app directory"
    
    rm -rf /app/* &>>$log_file
    validate $? "removing the existing code in app directory"
    
    unzip /tmp/$name.zip &>>$log_file
    validate $? "unzip the $name code in app directory"
    
    cd /app &>>$log_file
    validate $? "changing to app directory"
}

nodejs_setup() {
    dnf module disable nodejs -y &>>$log_file
    validate $? "Disabled the nodejs"
    
    dnf module enable nodejs:20 -y &>>$log_file
    validate $? "Enabled the nodejs 20"
    
    dnf install nodejs -y &>>$log_file
    validate $? "Installing NodeJS"
    
    npm install &>>$log_file
    validate $? "installing the dependencies for node"
}

java_setup() {
    dnf install maven -y &>>$log_file
    validate $? "installing maven which also install java"
    
    mvn clean package &>>$log_file
    validate $? "install dependecies and package application in to .jar file"
    
    mv target/shipping-1.0.jar shipping.jar &>>$log_file
    validate $? "moving the .jar file to current directory means /app"
    
}

python_setup() {
    dnf install python3 gcc python3-devel -y &>>$log_file
    validate $? "installing python"
    
    pip3 install -r requirements.txt &>>$log_file
    validate $? "installing dependencies"
}

systemd_setup() {
    id roboshop &>>$log_file
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    else
        echo -e "User already exists so $Y SKIPPING.. $N"
    fi
    
    cp $Dir_name/$name.service /etc/systemd/system/$name.service &>>$log_file
    validate $? "Setting the systemd service for $name"
    
    systemctl daemon-reload &>>$log_file
    validate $? "Deamon reload of $name to recognise the newly created service"
    
    systemctl enable $name &>>$log_file
    validate $? "enabled the $name"
    
    systemctl start $name &>>$log_file
    validate $? "started the $name"
}

restart_app() {
    systemctl restart $name
    validate $? "Restarted the $name"
}

print_time() {
    end_time=$(date +%s)
    total_time=$(($end_time-$start_time))
    echo "total time taken to execute this script is $total_time seconds" | tee -a $log_file
}




