#!/bin/sh

numb='1517'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 1.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 35 --keyint 260 --lookahead-threads 1 --min-keyint 20 --qp 30 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.0,1.1,1.2,0.3,0.8,0.3,2,1,16,35,260,1,20,30,5,3,66,28,1,2000,-1:-1,dia,show,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"