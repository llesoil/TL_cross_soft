#!/bin/sh

numb='414'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 3.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 35 --keyint 240 --lookahead-threads 3 --min-keyint 25 --qp 30 --qpstep 5 --qpmin 2 --qpmax 60 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset placebo --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.5,1.3,1.2,3.6,0.2,0.7,0.4,0,0,10,35,240,3,25,30,5,2,60,28,1,1000,-2:-2,umh,crop,placebo,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"