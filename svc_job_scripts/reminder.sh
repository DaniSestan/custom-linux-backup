#!/bin/bash

mkdir -p /var/log/systemd/reminder/
echo "testing I am a test script executing at $(date)" | tee -a /var/log/systemd/reminder/reminder.log

# TODO: create a reminder script that can be exec'd from the timed systemd reminder job
# Setting: low
# Timing: 5 min - 300000 ms
# Description: Information about an upcoming backup
# Details: Notifications set to 'low' should only serve as reminders to the end-user of the conditions of an upcoming backup.

# Setting: normal
# Timing: 10 min - 600000 ms
# Description: Information about the status of the current backup
# Details: Notifications set to 'medium' indicate something of immediate concern about a backup: what's the status of the backup -- has it started, has it stopped? If it has not started, what's the context? If it has stopped without completing successfully, what's the context. Successful start/stop, unsuccessful start/stop if the conditions for a scheduled backup were not met; the backup did not run as intended and must be manually triggered at this point.

# Setting: critical
# Timing: note that critical notifications need to be manually dismissed, there's no need to set any timer
# Description: Information about a verified threat or any issue preventing a backup
# Details: Alerts set to 'high' should be rare: If the data necessary for a backup is not accessible, corrupted or present on the system


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
