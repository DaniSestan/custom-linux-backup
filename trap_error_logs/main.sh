#!/bin/bash

print_logs_filepath="$(dirname "${BASH_SOURCE[0]}")/print_logs.sh"
exec 2> >(tee -a $BASH_ERROR_LOGS_FILEPATH >&2)
trap "source \"$print_logs_filepath\" \"$BASH_COMMAND\" \"$?\"" ERR