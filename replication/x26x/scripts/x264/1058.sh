#!/bin/sh

numb='1059'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 2.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 35 --keyint 230 --lookahead-threads 3 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 0 --qpmax 68 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.0,1.6,1.4,2.8,0.6,0.6,0.0,2,1,6,35,230,3,28,20,5,0,68,38,1,1000,-1:-1,dia,crop,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"