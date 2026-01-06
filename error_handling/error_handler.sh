#!/bin/bash

echo "printing BASH_CMD: $BASH_COMMAND"

#echo "{\"timestamp\":\"$(date)\", \"user\":\"$(whoami)\", \"error\":\"$BASH_COMMAND\", \"exit_code\":\"$?\"}" | jq .

#
#jq \
#--arg bash_command $BASH_COMMAND \
#'{
#  "timestamp": "",
#  "user": "",
#  "error": "",
#  "exit_code": '"$?"'
#}' \
#/home/dani/IdeaProjects/custom-linux-backup/error_handling/reminders_errors.log

#bash_fruit_var=Banana
#
# jq \
#--arg jq_fruit_var $bash_fruit_var \
#'{"fruit": $jq_fruit_var, "color": .color, "size": .size}' \
#/home/dani/IdeaProjects/custom-linux-backup/error_handling/fruits_template.json

#{
#    "fruit": "Banana",
#    "color": "Red",
#    "size": "Large"
#}