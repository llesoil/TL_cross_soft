#!/bin/sh

numb='768'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 0.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 5 --keyint 260 --lookahead-threads 0 --min-keyint 26 --qp 0 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.5,1.1,1.0,0.4,0.3,0.6,0.3,1,1,10,5,260,0,26,0,4,4,61,48,5,1000,1:1,hex,show,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"