#!/bin/sh

numb='2494'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 20 --keyint 260 --lookahead-threads 2 --min-keyint 20 --qp 20 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.5,1.1,1.3,3.0,0.6,0.6,0.4,3,2,0,20,260,2,20,20,5,2,68,18,5,2000,-2:-2,dia,crop,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"