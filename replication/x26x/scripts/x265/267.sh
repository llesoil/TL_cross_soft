#!/bin/sh

numb='268'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 30 --keyint 250 --lookahead-threads 2 --min-keyint 23 --qp 10 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.0,1.1,3.4,0.5,0.6,0.6,2,2,2,30,250,2,23,10,4,3,67,18,2,2000,1:1,dia,show,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"