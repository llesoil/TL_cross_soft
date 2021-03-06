#!/bin/sh

numb='1370'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.4 --qblur 0.2 --qcomp 0.8 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 50 --keyint 220 --lookahead-threads 0 --min-keyint 27 --qp 50 --qpstep 5 --qpmin 2 --qpmax 62 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset placebo --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.6,1.3,3.4,0.2,0.8,0.0,2,0,14,50,220,0,27,50,5,2,62,28,3,1000,1:1,umh,crop,placebo,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"