#!/bin/bash
name=cart
source ./common.sh
check_root
setup_logging
app_setup
systemd_setup
print_time