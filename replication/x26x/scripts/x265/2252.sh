#!/bin/sh

numb='2253'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 2.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 30 --keyint 250 --lookahead-threads 3 --min-keyint 28 --qp 40 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset faster --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.0,1.2,1.3,2.8,0.4,0.7,0.3,0,1,12,30,250,3,28,40,4,1,62,28,4,1000,-1:-1,dia,show,faster,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"