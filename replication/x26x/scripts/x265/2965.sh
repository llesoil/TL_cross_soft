#!/bin/sh

numb='2966'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 2.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 45 --keyint 250 --lookahead-threads 2 --min-keyint 21 --qp 0 --qpstep 3 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.2,1.0,2.8,0.4,0.9,0.7,1,0,0,45,250,2,21,0,3,3,63,48,3,2000,-2:-2,hex,crop,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"