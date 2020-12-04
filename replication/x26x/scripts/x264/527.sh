#!/bin/sh

numb='528'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 1.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 35 --keyint 230 --lookahead-threads 0 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset faster --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.0,1.4,1.0,0.6,0.7,0.6,3,2,8,35,230,0,23,20,3,1,60,28,2,1000,-2:-2,hex,crop,faster,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"