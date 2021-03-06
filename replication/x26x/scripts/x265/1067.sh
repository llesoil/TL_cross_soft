#!/bin/sh

numb='1068'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 5.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 5 --keyint 290 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 1 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset placebo --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.6,1.4,5.0,0.2,0.6,0.7,2,0,14,5,290,2,30,40,5,1,66,38,2,2000,-2:-2,dia,crop,placebo,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"