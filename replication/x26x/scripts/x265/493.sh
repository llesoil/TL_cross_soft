#!/bin/sh

numb='494'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 5.0 --qblur 0.6 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 10 --keyint 220 --lookahead-threads 0 --min-keyint 26 --qp 30 --qpstep 4 --qpmin 2 --qpmax 60 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.6,1.1,5.0,0.6,0.8,0.7,1,1,12,10,220,0,26,30,4,2,60,48,2,1000,-2:-2,dia,show,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"