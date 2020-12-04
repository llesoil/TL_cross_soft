#!/bin/bash

numb='1'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="./video$numb.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 0.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 50 --keyint 210 --lookahead-threads 3 --min-keyint 29 --qp 10 --qpstep 5 --qpmin 2 --qpmax 66 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset slower --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "real" $logfilename | sed 's/,/./; s/elapsed/,/ ; s/system/,/ ;s/real//; s/in/,/' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded// ; s/fps)// ; s/(/,/; s//,/' | cut -d "k" -f 1`
# clean
rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.4,1.3,0.4,0.6,0.7,0.6,1,0,8,50,210,3,29,10,5,2,66,28,6,1000,-2:-2,hex,crop,slower,40,ssim,"
csvLine+="$size,$time,$persec"
echo "$csvLine"