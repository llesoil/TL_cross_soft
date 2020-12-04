#!/bin/sh

numb='2708'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 45 --keyint 270 --lookahead-threads 3 --min-keyint 25 --qp 50 --qpstep 5 --qpmin 3 --qpmax 68 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.0,1.2,2.8,0.4,0.7,0.5,3,0,8,45,270,3,25,50,5,3,68,38,5,1000,-1:-1,umh,show,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"