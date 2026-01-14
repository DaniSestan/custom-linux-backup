#!/bin/bash

# TODO: sudo privileges on the trash command - modify from the sudoers file - get this script over with
# Clearing out files before re-running init script:
trash /etc/systemd/system/reminder.*
trash /etc/systemd/system/reminder.service.d/override.conf
trash /var/log/systemd/reminder/reminder.log
#trash /root/reminder.sh
#trash /home/dani/Work/Work-Projects/custom-linux-backup/tests/timed_svc_job/test.txt