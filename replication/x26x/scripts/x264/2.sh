#!/bin/bash

numb='3'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="./video$numb.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 15 --keyint 210 --lookahead-threads 3 --min-keyint 24 --qp 50 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "real" $logfilename | sed 's/real//; s/,/./' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded// ; s/fps// ; s/frames// ; s//,/' | cut -d "k" -f 1`
# clean
rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.4,1.1,4.6,0.4,0.6,0.6,1,0,0,15,210,3,24,50,5,4,60,38,2,1000,1:1,dia,show,fast,30,psnr,"
csvLine+="$size,$time,$persec"
echo "$csvLine"