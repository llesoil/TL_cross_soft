#!/bin/sh

numb='2174'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 25 --keyint 270 --lookahead-threads 1 --min-keyint 23 --qp 50 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.5,1.0,1.4,0.3,0.8,0.9,1,0,2,25,270,1,23,50,3,2,62,18,6,2000,-1:-1,umh,show,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"