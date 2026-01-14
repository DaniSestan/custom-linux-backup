#!/bin/bash

mkdir -p /var/log/systemd/reminder/
echo "testing timed unit script etc: I am a test script executing at $(date)" | tee -a /var/log/systemd/reminder/reminder.log

# TODO: create a reminder script that can be exec'd from the timed systemd reminder job
# Setting: low
# Timing: 5 min - 300000 ms
# Description: Information about an upcoming backup
# Details: Notifications set to 'low' should only serve as reminders to the end-user of the conditions of an upcoming backup.

# Setting: normal
# Timing: 10 min - 600000 ms
# Description: Information about the status of the current backup
# Details:
#   Notifications set to 'medium' indicate something of immediate concern about a backup:
#     Confirmation of successful start/finish
#     Information about unsuccessful start/finish if the conditions for a scheduled backup were not met;
#     Notification that the backup must be manually triggered if it did not start/finish successfully.

# Setting: critical
# Timing: note that critical notifications need to be manually dismissed, there's no need to set any timer
# Description: Information any issue preventing a backup
# Details: Alerts set to 'high' should be rare -- e.g., If the data necessary for a backup is not accessible, corrupted or present on the system

## Sample notify-send commands:
##   Backup reminder should be set to low - 300000
#notify-send -t 300000 -u low "<b>Backup Service Job Reminder</b>" "The job is scheduled for <>: 1. The laptop needs to be powered on; 2. If this is a dual-boot system, the OS needs to be running on Linux; 3. The USB needs to be connected to the laptop with enough free space allocated for the backup"
#notify-send -u low 'test notification' 'test notification message'
#notify-send --urgency low 'test notification' 'test notification message'
#notify-send -u normal 'test notification' 'test notification message'
#notify-send -u critical 'test notification' 'test notification message'

#!/bin/bash
current_hour=$(date +%H)
current_day=$(date +%u)  # 1=Mon, 7=Sun

# Only run if it's Monday and before 09:00
if [[ "$current_day" -eq 1 && "$current_hour" -lt 9 ]]; then
    # Run the actual job
    /usr/local/bin/my-backup.sh
else
    echo "Skipping because outside allowed time window."
fi
