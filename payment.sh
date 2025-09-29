#!/bin/bash
source ./common.sh
name=payment

check_root
app_setup
python_setup
systemd_setup
restart_app
print_time