#!/bin/sh

numb='1510'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 2.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 50 --keyint 220 --lookahead-threads 1 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.6,1.4,2.2,0.4,0.7,0.8,3,1,8,50,220,1,23,20,3,0,63,38,4,2000,1:1,hex,crop,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"