#!/bin/sh

numb='2944'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 5 --keyint 210 --lookahead-threads 2 --min-keyint 23 --qp 30 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,3.0,1.6,1.2,2.6,0.6,0.7,0.1,2,1,4,5,210,2,23,30,3,4,68,28,5,2000,-1:-1,hex,show,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"