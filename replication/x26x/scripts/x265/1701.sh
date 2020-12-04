#!/bin/sh

numb='1702'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 2.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 30 --keyint 260 --lookahead-threads 0 --min-keyint 22 --qp 0 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.0,1.1,2.2,0.6,0.8,0.9,0,0,16,30,260,0,22,0,3,1,68,38,3,1000,-1:-1,umh,crop,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"