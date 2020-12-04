#!/bin/sh

numb='812'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 5.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 35 --keyint 270 --lookahead-threads 3 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.0,1.0,5.0,0.2,0.9,0.5,1,0,0,35,270,3,28,50,4,0,64,18,4,1000,-2:-2,dia,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"