#!/bin/sh

numb='2667'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 1.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 15 --keyint 270 --lookahead-threads 0 --min-keyint 23 --qp 30 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.0,1.1,1.3,1.4,0.4,0.9,0.2,3,1,14,15,270,0,23,30,3,2,65,18,2,2000,-2:-2,umh,crop,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"