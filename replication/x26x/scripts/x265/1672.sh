#!/bin/sh

numb='1673'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 2.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 5 --keyint 300 --lookahead-threads 0 --min-keyint 21 --qp 50 --qpstep 4 --qpmin 3 --qpmax 64 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.5,1.2,2.6,0.2,0.9,0.6,1,0,12,5,300,0,21,50,4,3,64,48,5,2000,1:1,umh,crop,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"