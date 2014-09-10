#!/bin/sh

# Monitor RRD DB and restart upstream process if updates stop

# Bash script which starts a process, monitors a file's mtime for updates
# and restarts that process if monitored file goes too long between updates

# Written as a wrapper to noise_monitor.py because that script had a tendency to silently hang
# Could easily be used to wrap any command which is expected to cause a given file to be
# updated on some interval

COMMAND="/home/pi/noise_monitor.py"
DB_FILE="/var/rrd/noise.rrd"
THRESHOLD=100
RESTART=0

echo "Kicking off [$COMMAND]"
echo "Monitoring file [$DB_FILE] for updates and restarting if updates lag by [$THRESHOLD] seconds" 

$COMMAND &
PID=$!
renice -5 -p $PID

# Give our new process a chance to update the DB before we start killing it
sleep 60

while true; do
  TIMESTAMP=`date +%s`
  LAST_MODIFIED=`stat -c %Y $DB_FILE`
  INTERVAL=$(( $TIMESTAMP - $LAST_MODIFIED ))
  LOG_TIMESTAMP=`date +%F-%H:%M:%S`
  echo "[$LOG_TIMESTAMP] Interval is [$INTERVAL]"
  if [ $INTERVAL -gt $THRESHOLD ]; then
     echo "[$LOG_TIMESTAMP] Update interval exceeded [$INTERVAL vs. $THRESHOLD], restarting process"
     RESTART=1
  fi
  if [ $RESTART -eq 1 ]; then 
    if [ $PID ]; then
       echo "[$LOG_TIMESTAMP] Killing hung monitor process ID: $PID"
       kill $PID
    fi
    $COMMAND &
    PID=$!
    renice -5 -p $PID
    echo "[$LOG_TIMESTAMP] Started $COMMAND at [$PID]"
    RESTART=0
  fi
  sleep 20
done
