#!/bin/sh

numb='2880'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 3.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 15 --keyint 250 --lookahead-threads 4 --min-keyint 30 --qp 50 --qpstep 4 --qpmin 2 --qpmax 64 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.4,1.2,3.4,0.3,0.8,0.4,0,2,2,15,250,4,30,50,4,2,64,48,4,1000,-2:-2,hex,crop,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"