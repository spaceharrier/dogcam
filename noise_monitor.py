#!/usr/bin/python

from sys import byteorder
from array import array
from struct import pack

import os
import threading
import Queue
import time
import datetime
import pyaudio
import wave
from math import sqrt
from os import system

THRESHOLD = 6000
CHUNK_SIZE = 2048 
FORMAT = pyaudio.paInt16
RATE = 32000 

def qmean(num):
    " Calculate Root Mean Square of array "
    return sqrt(sum(n*n for n in num)/len(num))

def monitor():
  """
  Monitor sound from the microphone. Mark as loud any second where RMS level exceeds THRESHOLD
  """
  while True:
   try:
    p = pyaudio.PyAudio()
    stream = p.open(
               format=FORMAT, 
               channels=2, 
               rate=RATE,
               input=True, 
               input_device_index=2,
               output=False,
               frames_per_buffer=CHUNK_SIZE)

    r = array('h')

    # Initialize our counters and timestamps
    timestamp = time.localtime()
    minute_timestamp = timestamp
    this_second = []
    rms_this_second = 0
    this_minute = 0

    while True:
       # little endian, signed short
        snd_data = array('h', stream.read(CHUNK_SIZE))
        if byteorder == 'big':
            snd_data.byteswap()
        
        # Update our timestamp. If we've finished a second, clean up and setup for the next one
        new_timestamp = time.localtime()
        if (new_timestamp > timestamp):

            # Get the RMS over the max values for the second, store as integer
            if this_second:
                rms_this_second = int(qmean(this_second))
            else:
                print "No data to calculate RMS value\n"
                pass
            if (rms_this_second > THRESHOLD):
                #print "{0}, [{1}][{2}] LOUD second".format(time.strftime("%T", timestamp), rms_this_second, this_minute)
                # Increment the number of seconds in this minute which are 'loud'
                this_minute += 1
            else:
                #print "{0}, [{1}][{2}] quiet second".format(time.strftime("%T", timestamp), rms_this_second, this_minute)
                pass
            timestamp = new_timestamp
            this_second = []
             
            # Are rolling over a minute boundary? If so, ship out the previous minute's data and reset event counter for next minute
            if (new_timestamp.tm_min > minute_timestamp.tm_min):
                print "[{0}][{1}] Minute total; New minute\n".format(time.strftime("%H:%M", minute_timestamp), this_minute)
                
                # Push information about previous minute onto queue
                # This will be consumed by store_minute looping in a separate thread
                minute_data.put([int(time.mktime(minute_timestamp)), this_minute])

                minute_timestamp = new_timestamp
                this_minute = 0

        # Add the loudest even this pass to this second's data
        this_second.append(max(snd_data))
        
    stream.stop_stream()
    stream.close()
    p.terminate()
    print "[{0}] monitor - stream closed \n".format(time.strftime("%H:%M", time.localtime()))
   except:
     print "[{0}] monitor - audio monitoring fell over, restarting\n".format(time.strftime("%H:%M", time.localtime()))
     time.sleep(30)
     pass

def store_minute():
    " Get minute values from the queue and store them "
    while True:
       (last_minute_timestamp, last_minute_data) = minute_data.get()
       #print "store_minute: last_minute: [{0}][{1}]".format(last_minute_timestamp, last_minute_data)
       command = "/usr/bin/rrdtool update /var/rrd/noise.rrd {0}:{1}".format(last_minute_timestamp, last_minute_data)
       os.system(command)
       time.sleep(3)


if __name__ == '__main__':
    
    # Kick off an audio monitoring thread
    threads = []

    # Queue for our monitor thread to dump events per minute values to the thread that will record them in an RRD DB
    minute_data = Queue.Queue()    

    # Let's make this a daemon thread, so it'll die by CTRL-C
    monitor_thread = threading.Thread(target=monitor)
    monitor_thread.daemon = True
    threads.append (monitor_thread)
    monitor_thread.start()

    store_thread = threading.Thread(target=store_minute)
    store_thread.daemon = True
    threads.append (store_thread)
    store_thread.start()

    # Keep main loop alive now we've kicked off our threads
    while True:
       time.sleep(1)
       try: 
          monitor_thread.start()
       except:
          pass
     
