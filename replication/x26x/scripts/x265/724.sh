#!/bin/sh

numb='725'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 15 --keyint 220 --lookahead-threads 4 --min-keyint 27 --qp 50 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.1,1.1,2.4,0.6,0.8,0.7,2,0,8,15,220,4,27,50,3,0,63,38,4,1000,-1:-1,dia,show,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"