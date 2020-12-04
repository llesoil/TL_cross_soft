#!/bin/sh

numb='2207'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 0.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 5 --keyint 270 --lookahead-threads 4 --min-keyint 22 --qp 20 --qpstep 5 --qpmin 1 --qpmax 64 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset veryfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.5,1.5,1.2,0.8,0.6,0.6,0.6,1,2,12,5,270,4,22,20,5,1,64,18,3,2000,1:1,hex,crop,veryfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"