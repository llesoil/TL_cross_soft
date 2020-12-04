#!/bin/sh

numb='1178'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 5 --keyint 300 --lookahead-threads 1 --min-keyint 21 --qp 20 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset faster --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.0,1.3,1.6,0.2,0.8,0.2,3,0,6,5,300,1,21,20,3,1,67,18,1,1000,-2:-2,umh,crop,faster,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"