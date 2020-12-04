#!/bin/sh

numb='2760'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 2.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 30 --keyint 240 --lookahead-threads 4 --min-keyint 20 --qp 20 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,3.0,1.2,1.3,2.4,0.4,0.6,0.1,3,1,14,30,240,4,20,20,3,3,62,18,2,2000,1:1,umh,show,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"