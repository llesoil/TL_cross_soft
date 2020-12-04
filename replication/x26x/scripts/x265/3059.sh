#!/bin/sh

numb='3060'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 30 --keyint 280 --lookahead-threads 3 --min-keyint 27 --qp 40 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.6,1.0,2.8,0.6,0.6,0.7,1,1,6,30,280,3,27,40,5,1,69,48,5,2000,-2:-2,hex,show,veryfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"