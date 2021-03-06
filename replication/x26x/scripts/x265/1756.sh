#!/bin/sh

numb='1757'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 1.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 5 --keyint 220 --lookahead-threads 1 --min-keyint 23 --qp 20 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.5,1.2,1.1,1.2,0.5,0.6,0.0,0,2,16,5,220,1,23,20,5,4,64,38,5,2000,-2:-2,dia,crop,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"