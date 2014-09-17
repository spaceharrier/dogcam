#!/usr/bin/python

import time 
import os
import RPi.GPIO as io 
io.setmode(io.BCM) 

pir_pin = 17 
rrd_file = "/var/rrd/movement.rrd"

io.setup(pir_pin, io.IN) 

if __name__ == '__main__':

	while True:
  		move_count = 0
  		for x in range(0, 60):
    		if io.input(pir_pin):
        		move_count += 1
        		#print "   count [{0}]".format(move_count)
    		time.sleep(1)
  		#print "Move count last sixty seconds [{0}]\n".format(move_count)
  		ts = time.time()
  		output = "{0:.0f}:{1}".format(ts, move_count)
  		command = "/usr/bin/rrdtool update {0} {1}".format(rrd_file, output)
  		#print command
  		os.system(command)
	

