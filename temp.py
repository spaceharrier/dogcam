#!/usr/bin/python

# Use DHT temp/humidity sensor to read t/h, use CharLCD to display it 
# Short script, but a few things packed in here (hey, it's a hack)
#   - reads temp and humidity (sensor library supplies Celsius for temp)
#   - calculates Fahrenheit temp from Celsius
#   - records temperatures to separate rrd databases for each unit (must exist already)
#   - Writes out text fragments of current conditions for use in webcam overlay/pages
#   - Displays values and timestamp on an attached Adafruit 18x2 RGB LCD
#	- Color varies by temp

import math
import time
import datetime
import os

from Adafruit_CharLCD import * 
import Adafruit_DHT

# Our output file location
out_file = "/etc/archer_motd"
out_file_2 = "/var/www/temp.html"

# Where the temp sensor IC lives 

sensor  = Adafruit_DHT.AM2302
pin = 4

# Try to grab a sensor reading.  Use the read_retry method which will retry up
# to 15 times to get a sensor reading (waiting 2 seconds between each retry).
humidity, temperature_c = Adafruit_DHT.read_retry(sensor, pin)

# Get F conversion from C temp
temperature_f = 32 + ((temperature_c * 9) / 5)

# Debug
print "Readings {0:0.1f} C, {1:0.1f} F, {2:0.1f} %H\n".format(temperature_c, temperature_f, humidity)


# Get timestamp
ts = time.time()
st = datetime.datetime.fromtimestamp(ts).strftime('%I:%M %p')

# Output temp fragment file
f = open(out_file, 'w')
file_message = "{0:0.1f}C / {1:0.1f}F {2:0.1f}%H".format(temperature_c, temperature_f, humidity)
f.write(file_message)
g = open(out_file_2, 'w')
g.write(file_message)

# Record data to RRD Database
command = "/usr/bin/rrdtool update /var/rrd/temp.rrd  {0:.0f}:{1:.0f}:{2:.0f}".format(ts, temperature_c, temperature_f)
os.system(command)

# Display Message on LCD display
message = "{0:0.1f}\xDFC / {1:0.1f}\xDFF \n{2:0.1f}%H  {3}".format(temperature_c, temperature_f, humidity, st)  

# Initialize the LCD using the pins
lcd = Adafruit_CharLCDPlate()

# Choose color
if temperature_c > 26:
  lcd.set_color(1.0, 0.0, 0.0)
elif temperature_c > 22:
  lcd.set_color(1.0, 1.0, 0.0)
elif temperature_c < 18:
  lcd.set_color(0.0, 0.0, 1.0)
else: 
  lcd.set_color(0.0, 1.0, 0.0)

lcd.clear()
lcd.message(message)

