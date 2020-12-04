#!/bin/sh

numb='2861'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --intra-refresh --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 50 --keyint 300 --lookahead-threads 4 --min-keyint 20 --qp 0 --qpstep 4 --qpmin 4 --qpmax 69 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,--no-asm,--slow-firstpass,--weightb,1.0,1.1,1.2,3.4,0.3,0.7,0.2,3,1,10,50,300,4,20,0,4,4,69,38,1,2000,-1:-1,dia,crop,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"