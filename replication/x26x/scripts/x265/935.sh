#!/bin/sh

numb='936'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 15 --keyint 300 --lookahead-threads 3 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.4,1.1,4.6,0.3,0.8,0.7,2,2,14,15,300,3,24,0,4,2,68,18,4,1000,-1:-1,dia,show,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"