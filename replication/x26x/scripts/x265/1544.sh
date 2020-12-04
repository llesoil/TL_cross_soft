#!/bin/sh

numb='1545'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 1.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 40 --keyint 210 --lookahead-threads 4 --min-keyint 21 --qp 0 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.0,1.2,1.4,1.0,0.3,0.7,0.2,2,2,16,40,210,4,21,0,5,1,67,48,2,2000,-2:-2,hex,show,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"