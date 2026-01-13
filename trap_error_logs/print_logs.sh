#!/bin/bash

# sudo bash /home/dani/Work/Work-Projects/error_handling_tools/trap_error_logs/print_logs.sh

log_index=$(jq "length + 1" $TRAP_ERROR_LOGS_FILEPATH)
if (( log_index == $(wc -l < $BASH_ERROR_LOGS_FILEPATH) )); then
  bash_error=$(tail -n 1 $BASH_ERROR_LOGS_FILEPATH)
  error_log=$(echo "{
    \"log_index\": \"$log_index\",
    \"timestamp_utc\": \"$(date '+%Y-%m-%d %H:%M:%S.%3N')\",
    \"timestamp_local\": \"$(date '+%Y-%m-%d %H:%M:%S.%3N %Z')\",
    \"user\": \"$(whoami)\",
    \"command\": \"$BASH_COMMAND\",
    \"error\": \"$bash_error\",
    \"exit_code\": \"$?\"
  }" | jq .)
  updated_error_log=$(jq --argjson obj "$error_log" '. += [$obj]' $TRAP_ERROR_LOGS_FILEPATH)
  echo "$updated_error_log" > $TRAP_ERROR_LOGS_FILEPATH
fi