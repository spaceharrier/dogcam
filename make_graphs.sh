#!/bin/sh

# Create RRD Graphs of recorded parameters

# Movement
rrdtool graph /var/www/graphs/movement.png \
  -a PNG \
  -g \
  --slope-mode \
  --start -3600 --end now \
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
rrdtool graph /var/www/graphs/noise.png \
  -a PNG \
  -g \
  --slope-mode \
  --start -3600 --end now \
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


