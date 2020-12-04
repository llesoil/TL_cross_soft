#!/bin/sh

numb='818'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 3.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 35 --keyint 230 --lookahead-threads 2 --min-keyint 29 --qp 50 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.6,1.0,3.4,0.6,0.9,0.0,0,1,2,35,230,2,29,50,4,4,65,48,1,1000,-1:-1,hex,crop,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"