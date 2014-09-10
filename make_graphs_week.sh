#!/bin/sh

# Create RRD Graphs of recorded parameters

rrdtool graph /var/www/graphs/temperature_f_week.png \
  -a PNG \
  -g \
  --slope-mode \
  --start -604800 --end now \
  --font DEFAULT:7: \
  --title "Weekly" \
  --vertical-label "Temperature (°F)" \
  --color BACK#000000 \
  --color CANVAS#000000 \
  --color FONT#FFFFFF \
  --color SHADEA#222222 \
  --color SHADEB#222222 \
  --color MGRID#ff0000 \
  --x-grid HOUR:8:DAY:1:DAY:1:86400:"%a %e" \
  DEF:temperature_f=""/var/rrd/temp.rrd"":temperature_f:MAX \
  CDEF:trended_f=temperature_f,12600,TREND \
  LINE:trended_f#00ff00:"Temperature (°F)"


rrdtool graph /var/www/graphs/temperature_c_week.png \
  -a PNG \
  -g \
  --slope-mode \
  --start -604800 --end now \
  --font DEFAULT:7: \
  --title "Weekly" \
  --vertical-label "Temperature (°C)" \
  --color BACK#000000 \
  --color CANVAS#000000 \
  --color FONT#FFFFFF \
  --color SHADEA#222222 \
  --color SHADEB#222222 \
  --color MGRID#ff0000 \
  --x-grid HOUR:8:DAY:1:DAY:1:86400:"%a %e" \
  DEF:temperature_c=""/var/rrd/temp.rrd"":temperature_c:MAX \
  CDEF:trended_c=temperature_c,12600,TREND \
  LINE:trended_c#ffff00:"Temperature (°C)" \


