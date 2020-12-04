#!/bin/sh

numb='699'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 15 --keyint 270 --lookahead-threads 1 --min-keyint 26 --qp 30 --qpstep 5 --qpmin 2 --qpmax 60 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.2,1.0,4.2,0.2,0.7,0.6,2,1,8,15,270,1,26,30,5,2,60,28,1,1000,-1:-1,hex,show,veryfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"