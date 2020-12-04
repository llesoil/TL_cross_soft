#!/bin/sh

numb='96'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 0 --keyint 260 --lookahead-threads 2 --min-keyint 25 --qp 10 --qpstep 5 --qpmin 3 --qpmax 68 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.3,1.1,4.6,0.6,0.7,0.1,2,1,10,0,260,2,25,10,5,3,68,48,3,1000,-1:-1,dia,show,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"