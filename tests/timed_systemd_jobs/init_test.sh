#!/bin/bash

unit=logging
trash /etc/systemd/system/$unit.*
trash /etc/systemd/system/$unit.service.d/override.conf
ls /etc/systemd/system | grep logging
trash /var/log/systemd/$unit/test.log
[ -f "/var/log/systemd/$unit/test.log" ]
trash /root/$unit.sh
[ -f "/root/$unit.sh" ]
trash /tmp/$unit/test_file.txt
[ -f "/tmp/$unit/test_file.txt" ]