#!/bin/sh

numb='2951'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 0.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 15 --keyint 240 --lookahead-threads 3 --min-keyint 24 --qp 0 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.5,1.2,0.6,0.3,0.6,0.9,3,0,0,15,240,3,24,0,5,0,67,48,2,1000,-2:-2,hex,crop,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"