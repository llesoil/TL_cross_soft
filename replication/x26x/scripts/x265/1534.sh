#!/bin/sh

numb='1535'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 10 --keyint 280 --lookahead-threads 1 --min-keyint 20 --qp 30 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.4,1.0,3.2,0.5,0.6,0.8,0,2,10,10,280,1,20,30,4,3,69,38,4,1000,-1:-1,hex,crop,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"