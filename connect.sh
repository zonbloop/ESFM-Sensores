#! /bin/bash

a=$(lsusb | grep QinHeng | awk '{print $6}' | awk -F : '{print $1}') 
b=$(lsusb | grep QinHeng | awk '{print $6}' | awk -F : '{print $2}') 

echo "${a}"
echo "${b}"
sudo modprobe usbserial vendor=0x$a product=0x$b
echo 'Configure succesfully!'

stty -F /dev/ttyUSB0 9600 
sleep 2s
echo 'XFAT+WSSSID=WiFi IPN ' > /dev/ttyUSB0;
sleep 2s
echo 'XFAT+WSKEY=WPA2PSK,AES,nopreguntes' > /dev/ttyUSB0;
sleep 2s
echo 'XFAT+NETP=TCP,CLIENT,888,192.168.12.42' > /dev/ttyUSB0;

