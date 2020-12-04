#!/bin/sh

numb='282'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 10 --keyint 280 --lookahead-threads 1 --min-keyint 27 --qp 20 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.5,1.2,1.2,1.0,0.4,0.6,0.6,2,2,10,10,280,1,27,20,3,0,65,18,6,2000,-1:-1,dia,crop,veryslow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"