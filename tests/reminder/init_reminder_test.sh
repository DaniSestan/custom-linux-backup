#!/bin/bash

# TODO: move the init script in the system_d_unit files dir
source /home/dani/Work/Work-Projects/custom-linux-backup/trap_error_logs/.env
source $TRAP_ERROR_LOGS_MAIN_EXEC

echo "TRAP_ERROR_LOGS_MAIN_EXEC: $TRAP_ERROR_LOGS_MAIN_EXEC"

unit='reminder'
line_num='6'
minutes='1'
exec_start_cmd='/root/reminder.sh'
filename=/home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/$unit.timer
sed -i "${line_num}s|.*|OnCalendar=*:0/${minutes}|" "$filename"

# Remove any existing symlinks to the timer unit file:
symlink=$(find /etc/systemd/system/timers.target.wants/$unit.timer)
symlink_err_msg="No such file or directory"

if [[ "$symlink" != *"$symlink_err_msg"* ]]; then
  echo "No '$unit.timer' symlink"
else
  unlink /etc/systemd/system/timers.target.wants/$unit.timer
fi

# Remove any unit files and systemd exec scripts:
mkdir -p /tmp/custom-linux-backup
#install -D /dev/null /var/log/systemd/reminder/error_logs/initialize_systemd_job.log

mv /etc/systemd/system/$unit.service.d/override.conf /tmp/custom-linux-backup
mv /etc/systemd/system/$unit.service /tmp/custom-linux-backup
mv /etc/systemd/system/$unit.timer /tmp/custom-linux-backup
mv /root/$unit.sh /tmp/custom-linux-backup
#
#mv /etc/systemd/system/$unit.service.d/override.conf /tmp/custom-linux-backup 2>>/var/log/systemd/reminder/error_logs/initialize_systemd_job.log
#mv /etc/systemd/system/$unit.service /tmp/custom-linux-backup 2>>/var/log/systemd/reminder/error_logs/initialize_systemd_job.log
#mv /etc/systemd/system/$unit.timer /tmp/custom-linux-backup 2>>/var/log/systemd/reminder/error_logs/initialize_systemd_job.log
#mv /root/$unit.sh /tmp/custom-linux-backup 2>>/var/log/systemd/reminder/error_logs/initialize_systemd_job.log

#sudo systemctl list-timers "$unittimer" --all
sudo systemctl list-timers "$unit.timer" --all
systemctl list-units --type=service | grep reminder

# TODO: test changing file permissions without sudo
## For a test run of the modified files, copy the systemd_unit_files into the systemd folder:
#sudo cp /home/dani/IdeaProjects/custom-linux-backup/svc_job_scripts/$unitsh $exec_start_cmd
#sudo chmod 700 $exec_start_cmd
#sudo mkdir -p /etc/systemd/system/$unitservice.d/
#sudo cp /home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/$unitservice.d/override.conf /etc/systemd/system/$unitservice.d/override.conf
#sudo chmod 644 /etc/systemd/system/$unitservice.d/override.conf
#sudo cp /home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/$unitservice /etc/systemd/system/$unitservice
#sudo chmod 644 /etc/systemd/system/$unitservice
#sudo cp /home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/$unittimer /etc/systemd/system/$unittimer
#sudo chmod 644 /etc/systemd/system/$unittimer

## Once the service and timer units are defined, reload the systemd daemon:
#sudo systemctl daemon-reload
#
## Verify that systemd loaded the unit files:
##   Output: Col 1: Unit File Name; Col 2: State (Enablement); Col 3: Preset configuration -- note that this value is not applicable to static files
#systemctl list-unit-files | grep reminder
#
## Enable and start the timer:
#sudo systemctl enable --now $unittimer
## 'start' cmd execs the timer, regardless of the time set in the timer unit
#sudo systemctl start $unittimer
#
## To read the unit file:
#systemctl cat $unitservice
#systemctl cat $unittimer
#cat $exec_start_cmd
#
## Verify that the unit files are read after daemon-reload and do not contain any syntax errors:
#systemd-analyze verify /etc/systemd/system/$unitservice
#
## To view the status of the service jobs -- if it's loaded, active, it's current sub-state, and a description
## To view the status of the timer and see when it last ran and when it’s scheduled to run next, use:
#sudo systemctl list-timers "$unittimer" --all
#systemctl list-units --type=service --state=active | grep reminder
#
## You can also get specific details of a timer with:
#sudo systemctl status $unittimer
#sudo systemctl status $unitservice
#
## Verify that the files contain the new file content:
#file1=/home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/$unitservice.d/override.conf
#file2=/etc/systemd/system/$unitservice.d/override.conf
#file3=/home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/$unitservice
#file4=/etc/systemd/system/$unitservice
#file5=/home/dani/IdeaProjects/custom-linux-backup/systemd_unit_files/svc_jobs/reminder/$unittimer
#file6=/etc/systemd/system/$unittimer
#file7=/home/dani/IdeaProjects/custom-linux-backup/svc_job_scripts/$unitsh
#file8=$exec_start_cmd
#
#file_index=0
#file_list_len=8
#
#while [ $file_index -lt $file_list_len ]; do
#     ((file_index++))
#     file_a=$(eval echo "\$file$((file_index))")
#     ((file_index++))
#     file_b=$(eval echo "\$file$((file_index))")
#
#    if cmp -s $(eval echo "\$file${file_a}") $(eval echo "\$file${file_b}"); then
#        echo "file diff: false"
#        echo "files: '$file_a' and '$file_b' diff"
#    else
#        diff_output=$(diff -u "$file_a" "$file_b")
#        echo "file diff: true"
#        echo "files: '$file_a' and '$file_b'"
#        echo "diff_output: $diff_output"
#    fi
#done