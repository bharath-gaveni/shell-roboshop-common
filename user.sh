#!/bin/bash
source ./common.sh
name=user

check_root
setup_logging
app_setup
nodejs_setup
systemd_setup

restart_app

print_time





