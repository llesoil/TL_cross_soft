#!/bin/sh

numb='2686'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 1.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 45 --keyint 240 --lookahead-threads 1 --min-keyint 20 --qp 50 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset placebo --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.0,1.2,1.2,0.2,0.9,0.3,2,0,16,45,240,1,20,50,5,0,66,18,6,2000,-1:-1,dia,crop,placebo,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"