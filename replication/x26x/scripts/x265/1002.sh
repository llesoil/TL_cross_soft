#!/bin/sh

numb='1003'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 1.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 35 --keyint 210 --lookahead-threads 3 --min-keyint 27 --qp 20 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.3,1.2,1.8,0.6,0.6,0.5,3,0,14,35,210,3,27,20,5,1,69,18,2,1000,-1:-1,dia,show,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"