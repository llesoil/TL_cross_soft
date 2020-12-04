#!/bin/sh

numb='2033'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 4.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 35 --keyint 240 --lookahead-threads 1 --min-keyint 26 --qp 0 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.6,1.4,4.6,0.5,0.6,0.9,1,0,10,35,240,1,26,0,3,4,62,28,4,2000,1:1,dia,crop,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"