#!/bin/bash
cat /proc/net/dev | grep $1 | awk '{print "Receive:"$2/1024/1024"M","    ","Transmit:"$10/1024/1024"M"}'
