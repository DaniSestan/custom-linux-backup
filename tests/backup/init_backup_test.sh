#!/bin/bash

# TODO: refer to files from blunix tutorial; there's some issue executing script from /usr/bin dir - either mod permissions or run script from diff location

# Change the backup timer sched:
line_num='6'
minutes='10'
filename=/home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/backup/backup.timer
sed -i "${line_num}s|.*|OnCalendar=*:0/${minutes}|" "$filename"

# For a test run of the modified files, copy the systemd_unit_files into the systemd folder:
sudo cp /home/dani/IdeaProjects/custom-linux-backup/svc_job_scripts/backup.sh /root/backup.sh
sudo chmod 700 /root/backup.sh
sudo cp /home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/backup/backup.service.d/override.conf /etc/systemd/system/backup.service.d/override.conf
sudo chmod 644 /etc/systemd/system/backup.service.d/override.conf
sudo cp /home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/backup/backup.service /etc/systemd/system/backup.service
sudo chmod 644 /etc/systemd/system/backup.service
sudo cp /home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/backup/backup.timer /etc/systemd/system/backup.timer
sudo chmod 777 /etc/systemd/system/backup.timer

# Once the service and timer units are defined, reload the systemd daemon:
sudo systemctl daemon-reload

# Enable and start the timer:
sudo systemctl enable --now backup.timer
# 'start' cmd execs the timer, regardless of the time set in the timer unit
sudo systemctl start backup.timer

# To read the unit file:
systemctl cat backup.service
systemctl cat backup.timer

# To view the status of the timer and see when it last ran and when it’s scheduled to run next, use:
sudo systemctl list-timers 'backup.timer' --all

# You can also get specific details of a timer with:
sudo systemctl status backup.timer
sudo systemctl status backup.service
systemctl list-units --type=service --state=inactive

# Verify that the files contain the new file content:
file1=/home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/backup/backup.service.d/override.conf
file2=/etc/systemd/system/backup.service.d/override.conf
file3=/home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/backup/backup.service
file4=/etc/systemd/system/backup.service
file5=/home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/backup/backup.timer
file6=/etc/systemd/system/backup.timer
file7=/home/dani/IdeaProjects/custom-linux-backup/svc_job_scripts/backup.sh
file8=/root/backup.sh

file_index=0
file_list_len=8

while [ $file_index -lt $file_list_len ]; do
     ((file_index++))
     file_a=$(eval echo "\$file$((file_index))")
     ((file_index++))
     file_b=$(eval echo "\$file$((file_index))")

    if cmp -s $(eval echo "\$file${file_a}") $(eval echo "\$file${file_b}"); then
        echo "file diff: false"
        echo "files: '$file_a' and '$file_b' diff"
    else
        diff_output=$(diff -u "$file_a" "$file_b")
        echo "file diff: true"
        echo "files: '$file_a' and '$file_b'"
        echo "diff_output: $diff_output"
    fi
done