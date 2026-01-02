#!/bin/bash

# run cmd: sudo bash /home/dani/IdeaProjects/custom-linux-backup/tests/reminder/init_reminder_test.sh

line_num='6'
minutes='1'
exec_start_cmd='/root/reminder.sh'
filename=/home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/reminder.timer
sed -i "${line_num}s|.*|OnCalendar=*:0/${minutes}|" "$filename"

# Remove any existing symlinks to the timer unit file:
symlink=$(find /etc/systemd/system/timers.target.wants/reminder.timer 2>&1)
symlink_err_msg="No such file or directory"

if [[ "$symlink" != *"$symlink_err_msg"* ]]; then
  unlink /etc/systemd/system/timers.target.wants/reminder.timer
else
  echo "No 'reminder.timer' symlink"
fi

# Remove any unit files and systemd exec scripts:
mv /etc/systemd/system/reminder.service.d/override.conf /tmp/custom-linux-backup || true
mv /etc/systemd/system/reminder.service /tmp/custom-linux-backup
mv /etc/systemd/system/reminder.timer /tmp/custom-linux-backup
mv /root/reminder.sh /tmp/custom-linux-backup

# For a test run of the modified files, copy the systemd_unit_files into the systemd folder:
sudo cp /home/dani/IdeaProjects/custom-linux-backup/svc_job_scripts/reminder.sh $exec_start_cmd
sudo chmod 700 $exec_start_cmd
sudo mkdir -p /etc/systemd/system/reminder.service.d/
sudo cp /home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/reminder.service.d/override.conf /etc/systemd/system/reminder.service.d/override.conf
sudo chmod 644 /etc/systemd/system/reminder.service.d/override.conf
sudo cp /home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/reminder.service /etc/systemd/system/reminder.service
sudo chmod 644 /etc/systemd/system/reminder.service
sudo cp /home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/reminder.timer /etc/systemd/system/reminder.timer
sudo chmod 644 /etc/systemd/system/reminder.timer

# Once the service and timer units are defined, reload the systemd daemon:
sudo systemctl daemon-reload

# Verify that systemd loaded the unit files:
#   Output: Col 1: Unit File Name; Col 2: State (Enablement); Col 3: Preset configuration -- note that this value is not applicable to static files
systemctl list-unit-files | grep reminder

# Enable and start the timer:
sudo systemctl enable --now reminder.timer
# 'start' cmd execs the timer, regardless of the time set in the timer unit
sudo systemctl start reminder.timer

# To read the unit file:
systemctl cat reminder.service
systemctl cat reminder.timer
cat $exec_start_cmd

# Verify that the unit files are read after daemon-reload and do not contain any syntax errors:
systemd-analyze verify /etc/systemd/system/reminder.service

# To view the status of the service jobs -- if it's loaded, active, it's current sub-state, and a description
# To view the status of the timer and see when it last ran and when it’s scheduled to run next, use:
sudo systemctl list-timers 'reminder.timer' --all
systemctl list-units --type=service --state=active | grep reminder

# You can also get specific details of a timer with:
sudo systemctl status reminder.timer
sudo systemctl status reminder.service

# Verify that the files contain the new file content:
file1=/home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/reminder.service.d/override.conf
file2=/etc/systemd/system/reminder.service.d/override.conf
file3=/home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/reminder.service
file4=/etc/systemd/system/reminder.service
file5=/home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/reminder.timer
file6=/etc/systemd/system/reminder.timer
file7=/home/dani/IdeaProjects/custom-linux-backup/svc_job_scripts/reminder.sh
file8=$exec_start_cmd

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