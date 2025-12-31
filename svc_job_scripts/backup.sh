#!/bin/bash

echo "I am a test script executing at $(date)" | tee -a /var/log/systemd/backup/backup.log