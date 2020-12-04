#!/bin/sh

numb='1644'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 40 --keyint 300 --lookahead-threads 0 --min-keyint 24 --qp 30 --qpstep 3 --qpmin 1 --qpmax 69 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.5,1.0,4.4,0.3,0.8,0.2,0,1,2,40,300,0,24,30,3,1,69,18,5,1000,-1:-1,umh,crop,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"