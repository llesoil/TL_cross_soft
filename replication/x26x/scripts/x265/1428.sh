#!/bin/sh

numb='1429'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 4.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 25 --keyint 270 --lookahead-threads 2 --min-keyint 20 --qp 0 --qpstep 3 --qpmin 0 --qpmax 67 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.1,1.2,4.2,0.5,0.8,0.9,1,0,0,25,270,2,20,0,3,0,67,38,6,1000,1:1,dia,show,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"