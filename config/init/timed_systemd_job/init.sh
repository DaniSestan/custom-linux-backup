#!/bin/bash

# Uncomment line to run code-stepping:
trap 'echo "[${BASH_SOURCE}:${LINENO}] $BASH_COMMAND" ; read -p "Continue?"' DEBUG

unit=$1
project_root="$(dirname "$0")/../../.."
source $project_root/trap_error_logs/.env
source $TRAP_ERROR_LOGS_MAIN_EXEC
source $project_root/config/env/$unit.env

# Set timer file OnCalendar setting:
timer_filepath="$project_root/systemd_unit_files/services/$unit/$unit.timer"
sed -i "${LINE_NUM}s|.*|OnCalendar=*:0/${MINUTES}|" "$timer_filepath"

# Remove any existing symlinks to the timer unit file:
symlink=$(find /etc/systemd/system/timers.target.wants/$unit.timer)
symlink_err_msg="No such file or directory"
if [[ "$symlink" != *"$symlink_err_msg"* ]]; then
  echo "No '$unit.timer' symlink"
else
  unlink /etc/systemd/system/timers.target.wants/$unit.timer
fi

# Create any additional files required to run the systemd job:
for af in "${ADDITIONAL_FILEPATHS[@]}"; do
# Checks if the file exists, is a regular file, and is not empty:
  orig_filepath="${af%%:*}"
  dest_filepath="${af#*:}"
  if [ -n "$orig_filepath" ] && [ -f $orig_filepath ] && [ -s $orig_filepath ]; then
    install -D $orig_filepath $dest_filepath
  else
    install -D /dev/null $dest_filepath
  fi
done

# For a test run of the modified files, copy the systemd_unit_files into the systemd folder:
sudo cp $project_root/systemd_unit_files/services/$unit/exec/$unit.sh $EXEC_FILEPATH
sudo chmod 700 $EXEC_FILEPATH
install -D $project_root/systemd_unit_files/services/$unit/$unit.service.d/override.conf /etc/systemd/system/$unit.service.d/override.conf
sudo chmod 644 /etc/systemd/system/$unit.service.d/override.conf
sudo cp $project_root/systemd_unit_files/services/$unit/$unit.service /etc/systemd/system/$unit.service
sudo chmod 644 /etc/systemd/system/$unit.service
sudo cp $project_root/systemd_unit_files/services/$unit/$unit.timer /etc/systemd/system/$unit.timer
sudo chmod 644 /etc/systemd/system/$unit.timer

# Once the service and timer units are defined, reload the systemd daemon:
sudo systemctl daemon-reload

# Verify that systemd loaded the unit files:
# Output: Col 1: Unit File Name; Col 2: State (Enablement); Col 3: Preset configuration -- note that this value is not applicable to static files
systemctl list-unit-files | grep $unit

# Enable and start the timer:
sudo systemctl enable --now $unit.timer
# 'start' cmd execs the timer, regardless of the time set in the timer unit
sudo systemctl start $unit.timer

# To read the unit file:
systemctl cat $unit.service
systemctl cat $unit.timer
cat $EXEC_FILEPATH

# Verify that the unit files are read after daemon-reload and do not contain any syntax errors:
systemd-analyze verify /etc/systemd/system/$unit.service

# To view the status of the timer and see when it last ran and when it’s scheduled to run next, use:
systemctl list-timers "$unit.timer" --all
# To view the status of the service jobs -- if it's loaded, active, it's current sub-state, and a description
systemctl status $unit.timer
systemctl status $unit.service

# Verify that the files contain the new file content:
file1=$project_root/systemd_unit_files/services/$unit/$unit.service.d/override.conf
file2=/etc/systemd/system/$unit.service.d/override.conf
file3=$project_root/systemd_unit_files/services/$unit/$unit.service
file4=/etc/systemd/system/$unit.service
file5=$project_root/systemd_unit_files/services/$unit/$unit.timer
file6=/etc/systemd/system/$unit.timer
file7=$project_root/systemd_unit_files/services/$unit/exec/$unit.sh
file8=$EXEC_FILEPATH

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