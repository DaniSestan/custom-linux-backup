#!/bin/bash

# TODO: modify the script to refer to the test_file.txt
echo "I am a test script executing at $(date)" | tee -a /var/log/systemd/logging/test.log
echo "etc" >> /tmp/logging/test_file.txt