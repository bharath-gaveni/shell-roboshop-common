#!/bin/bash
source ./common.sh
name=user
check_root
setup_logging
app_setup
nodejs_setup
systemd_setup
print_time