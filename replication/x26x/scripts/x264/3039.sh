#!/bin/sh

numb='3040'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 2.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 0 --keyint 300 --lookahead-threads 4 --min-keyint 23 --qp 50 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.0,1.1,2.4,0.5,0.8,0.8,2,1,14,0,300,4,23,50,3,2,67,18,2,1000,-1:-1,dia,show,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"