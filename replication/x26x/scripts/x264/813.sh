#!/bin/sh

numb='814'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 5.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 40 --keyint 260 --lookahead-threads 2 --min-keyint 21 --qp 30 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.0,1.4,5.0,0.4,0.8,0.5,0,2,2,40,260,2,21,30,3,4,68,18,5,1000,-1:-1,umh,show,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"