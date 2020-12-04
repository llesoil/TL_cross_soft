#!/bin/sh

numb='338'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 40 --keyint 220 --lookahead-threads 2 --min-keyint 26 --qp 20 --qpstep 3 --qpmin 3 --qpmax 63 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset superfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.0,1.0,1.6,0.5,0.6,0.1,0,2,12,40,220,2,26,20,3,3,63,38,4,1000,1:1,dia,show,superfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"