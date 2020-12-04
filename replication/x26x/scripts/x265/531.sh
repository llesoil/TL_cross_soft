#!/bin/sh

numb='532'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 4.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 0 --keyint 260 --lookahead-threads 4 --min-keyint 29 --qp 30 --qpstep 3 --qpmin 0 --qpmax 67 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.0,1.4,1.4,4.6,0.2,0.8,0.2,0,0,2,0,260,4,29,30,3,0,67,38,1,2000,-1:-1,dia,crop,ultrafast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"