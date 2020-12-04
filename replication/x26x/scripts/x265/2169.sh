#!/bin/sh

numb='2170'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 1.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 35 --keyint 230 --lookahead-threads 4 --min-keyint 30 --qp 20 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.4,1.1,1.6,0.2,0.8,0.9,1,1,4,35,230,4,30,20,3,3,65,18,2,1000,1:1,hex,show,slower,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"