#!/bin/sh

numb='10'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 1.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 50 --keyint 240 --lookahead-threads 4 --min-keyint 23 --qp 20 --qpstep 4 --qpmin 4 --qpmax 69 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,2.0,1.0,1.4,1.4,0.4,0.6,0.3,1,2,16,50,240,4,23,20,4,4,69,18,4,1000,-2:-2,dia,show,slower,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"