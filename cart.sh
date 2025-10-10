#!/bin/bash
name=cart
source ./common.sh
check_root
setup_logging
app_setup
nodejs_setup
systemd_setup
print_time