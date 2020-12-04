#!/bin/sh

numb='329'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 2.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 50 --keyint 280 --lookahead-threads 4 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.0,1.1,1.0,2.4,0.3,0.6,0.8,2,2,8,50,280,4,26,50,4,0,60,48,1,1000,-1:-1,hex,show,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"