#!/bin/sh

numb='1985'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 35 --keyint 220 --lookahead-threads 1 --min-keyint 21 --qp 40 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.1,1.1,2.6,0.2,0.7,0.2,1,0,4,35,220,1,21,40,3,1,63,28,2,2000,-2:-2,umh,crop,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"