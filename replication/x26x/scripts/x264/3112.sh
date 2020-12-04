#!/bin/sh

numb='3113'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 1.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 35 --keyint 280 --lookahead-threads 2 --min-keyint 24 --qp 20 --qpstep 4 --qpmin 0 --qpmax 63 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.5,1.5,1.2,1.8,0.4,0.6,0.3,2,1,6,35,280,2,24,20,4,0,63,28,4,1000,-2:-2,dia,crop,medium,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"