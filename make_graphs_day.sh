#!/bin/sh

# Create RRD Graphs of recorded parameters

# Movement
rrdtool graph /var/www/graphs/movement_day.png \
  -a PNG \
  -g \
  --slope-mode \
  --start -86400 --end now \
  --font DEFAULT:7: \
  --upper-limit 60 \
  --lower-limit 0 \
  --title "Movement" \
  --vertical-label "Seconds Active" \
  --color BACK#000000 \
  --color CANVAS#000000 \
  --color FONT#FFFFFF \
  --color SHADEA#222222 \
  --color SHADEB#222222 \
  --color MGRID#ff0000 \
  DEF:movement_count=""/var/rrd/movement.rrd"":movement_count:AVERAGE \
  AREA:movement_count#0000ff:"Movement"

# Noise 
rrdtool graph /var/www/graphs/noise_day.png \
  -a PNG \
  -g \
  --slope-mode \
  --start -28800 --end now \
  --font DEFAULT:7: \
  --upper-limit 10 \
  --lower-limit 0 \
  --title "Noise" \
  --vertical-label "Seconds Noisy" \
  --color BACK#000000 \
  --color CANVAS#000000 \
  --color FONT#FFFFFF \
  --color SHADEA#222222 \
  --color SHADEB#222222 \
  --color MGRID#ff0000 \
  DEF:noise_count=""/var/rrd/noise.rrd"":noise_count:AVERAGE \
  AREA:noise_count#ff0000:"Noise"

# Temperature
rrdtool graph /var/www/graphs/temperature_f_day.png \
  -a PNG \
  -g \
  --slope-mode \
  --start -86400 --end now \
  --font DEFAULT:7: \
  --title "Daily" \
  --vertical-label "Temperature (°F)" \
  --color BACK#000000 \
  --color CANVAS#000000 \
  --color FONT#FFFFFF \
  --color SHADEA#222222 \
  --color SHADEB#222222 \
  --color MGRID#ff0000 \
  --x-grid MINUTE:30:HOUR:6:HOUR:12:0:"%a %H:%M" \
  DEF:temperature_f=""/var/rrd/temp.rrd"":temperature_f:MAX \
  CDEF:trended_f=temperature_f,1800,TREND \
  LINE:trended_f#00ff00:"Temperature (°F)"


rrdtool graph /var/www/graphs/temperature_c_day.png \
  -a PNG \
  -g \
  --slope-mode \
  --start -86400 --end now \
  --font DEFAULT:7: \
  --title "Daily" \
  --vertical-label "Temperature (°C)" \
  --color BACK#000000 \
  --color CANVAS#000000 \
  --color FONT#FFFFFF \
  --color SHADEA#222222 \
  --color SHADEB#222222 \
  --color MGRID#ff0000 \
  --x-grid MINUTE:30:HOUR:6:HOUR:12:0:"%a %H:%M" \
  DEF:temperature_c=""/var/rrd/temp.rrd"":temperature_c:MAX \
  CDEF:trended_c=temperature_c,1800,TREND \
  LINE:trended_c#ffff00:"Temperature (°C)" \



