#!/bin/sh

numb='3110'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 35 --keyint 210 --lookahead-threads 1 --min-keyint 20 --qp 0 --qpstep 5 --qpmin 3 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.0,1.3,1.6,0.5,0.7,0.5,0,0,6,35,210,1,20,0,5,3,67,48,2,1000,-2:-2,hex,show,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"