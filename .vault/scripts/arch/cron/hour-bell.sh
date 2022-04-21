#! /bin/bash
OC=$(date +%H)\ o\'clock
echo $OC
# notify-send "$OC" "asdf"
notify-send -t 10000 'time check' "$OC"

# run:
# `crontab -e`
#
# paste this into the file opened
# ```
# DISPLAY=:0.0
# DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
# 0 * * * * setpriv --euid=1000 ~/repos/arch/scripts/hour-bell.sh
# ```

