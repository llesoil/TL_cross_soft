#!/bin/sh

numb='1739'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 4.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 4 --crf 35 --keyint 250 --lookahead-threads 3 --min-keyint 24 --qp 0 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.5,1.2,4.2,0.3,0.7,0.6,1,2,4,35,250,3,24,0,3,2,60,38,3,2000,-2:-2,dia,crop,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"