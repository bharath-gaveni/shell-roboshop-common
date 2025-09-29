#!/bin/bash
source ./common.sh
name=cart

check_root
app_setup
nodejs_setup
systemd_setup

restart_app

print_time