#!/bin/sh

numb='1689'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 2.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 50 --keyint 220 --lookahead-threads 0 --min-keyint 28 --qp 30 --qpstep 3 --qpmin 0 --qpmax 62 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.4,1.2,2.6,0.3,0.7,0.8,0,0,4,50,220,0,28,30,3,0,62,48,4,1000,-2:-2,umh,crop,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"