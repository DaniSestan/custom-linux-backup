#!/bin/bash

#cmd to run: sudo bash /home/dani/IdeaProjects/custom-linux-backup/tests/reminder/reminder_timer_test.sh
#sed -i 's|OnCalendar=\*:0/1|OnCalendar=\*:0/10|' /home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/reminder.timer.bak
sed -i 's|OnCalendar=\*:0/10|OnCalendar=\*:0/1|' /home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/reminder.timer.bak
# tab
# cron job expression:
#  0 0 1 * * /home/dani/IdeaProjects/custom-linux-backup/tests/reminder/reminder_timer_test.sh
## /etc/systemd/system/reminder.timer
#[Unit]
#Description=Custom timer that triggers a systemd job to create timed reminders the week and day prior to a scheduled backup
#
#[Timer]
#OnCalendar=*:0/1
#
#[Install]
#WantedBy=timers.target