#!/bin/sh

numb='1159'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 50 --keyint 240 --lookahead-threads 2 --min-keyint 25 --qp 50 --qpstep 4 --qpmin 4 --qpmax 68 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.6,1.3,2.0,0.3,0.9,0.3,0,2,4,50,240,2,25,50,4,4,68,38,6,1000,-1:-1,hex,crop,veryslow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"