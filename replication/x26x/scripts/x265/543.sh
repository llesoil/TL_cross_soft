#!/bin/sh

numb='544'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 40 --keyint 240 --lookahead-threads 2 --min-keyint 28 --qp 20 --qpstep 3 --qpmin 3 --qpmax 61 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.4,1.0,2.6,0.4,0.7,0.3,1,1,10,40,240,2,28,20,3,3,61,28,1,1000,1:1,umh,crop,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"