#!/bin/sh

PIC_PATH=/var/www/motion
TEMP_INFO=`cat /var/www/temp.html`
GDFONTPATH=/usr/share/fonts/truetype/msttcorefonts

# Take a pic with the USB webcam
/usr/bin/fswebcam -r 1920x1080 --scale 1024x576 --jpeg 95 -D 5 --set brightness=75% --set "Backlight Compensation"=1 --set sharpness=11% --set saturation=12% --overlay /home/pi/archer_cam_title.png --font arialbd.ttf:16 --timestamp "%Y - %A %B %e, %r (%Z)" --title "$TEMP_INFO" $PIC_PATH/cam2.jpg

# Take a pic with the camera, then use imagemagick to make a smaller version with a datestamp on it
#/usr/bin/raspistill -vf -hf -o $PIC_PATH/cam_new.jpg

# Do the resize
#/home/pi/resize_small.sh /var/www/motion/cam_new.jpg /var/www/motion/cam_small_new.jpg

# Add the timestamp to the small pic
#/home/pi/datestamp.sh /var/www/motion/cam_small_new.jpg /var/www/motion/cam_small_anno_new.jpg 16 

# Add the timestamp to the big pic
#/home/pi/datestamp.sh /var/www/motion/cam_new.jpg /var/www/motion/cam_anno_new.jpg 72 

# Move files into place
#mv $PIC_PATH/cam_small_anno_new.jpg $PIC_PATH/cam_small_anno.jpg
#mv $PIC_PATH/cam_anno_new.jpg $PIC_PATH/cam_anno.jpg

# Remove temp files
#rm $PIC_PATH/cam_new.jpg
#rm $PIC_PATH/cam_small_new.jpg
