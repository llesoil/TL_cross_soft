#!/bin/sh

numb='829'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 0.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 40 --keyint 280 --lookahead-threads 1 --min-keyint 20 --qp 40 --qpstep 5 --qpmin 1 --qpmax 64 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.0,1.4,0.8,0.4,0.9,0.6,1,0,4,40,280,1,20,40,5,1,64,28,3,2000,1:1,umh,crop,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"