#!/bin/sh

numb='1431'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 50 --keyint 200 --lookahead-threads 2 --min-keyint 24 --qp 0 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.6,1.2,2.4,0.6,0.9,0.9,2,2,2,50,200,2,24,0,3,4,67,38,1,2000,-2:-2,umh,crop,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"