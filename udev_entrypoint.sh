#!/bin/bash
set -e

# 1. Start the udev daemon
service udev start || /lib/systemd/systemd-udevd --daemon

# 2. Replay hardware events
udevadm trigger

# 3. Wait for rules to process
sleep 1

# 4. Hand over control to your command
exec "$@"