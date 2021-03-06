#!/bin/sh

numb='2895'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 5 --keyint 200 --lookahead-threads 1 --min-keyint 25 --qp 50 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.0,1.4,4.6,0.6,0.6,0.8,0,0,14,5,200,1,25,50,3,1,63,38,1,1000,-1:-1,hex,crop,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"