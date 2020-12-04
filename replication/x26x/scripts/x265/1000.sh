#!/bin/sh

numb='1001'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 10 --keyint 270 --lookahead-threads 3 --min-keyint 25 --qp 0 --qpstep 5 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset placebo --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.2,1.4,0.8,0.6,0.6,0.9,1,1,14,10,270,3,25,0,5,2,60,38,1,2000,-1:-1,hex,crop,placebo,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"