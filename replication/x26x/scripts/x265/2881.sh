#!/bin/sh

numb='2882'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 0.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 20 --keyint 220 --lookahead-threads 0 --min-keyint 21 --qp 10 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.0,1.6,1.4,0.6,0.4,0.6,0.0,1,2,0,20,220,0,21,10,3,3,69,18,1,1000,-2:-2,hex,show,veryfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"