#!/bin/sh

numb='1774'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 4.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 45 --keyint 280 --lookahead-threads 3 --min-keyint 22 --qp 10 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,2.0,1.1,1.4,4.0,0.3,0.6,0.1,1,1,14,45,280,3,22,10,3,1,68,38,6,1000,1:1,umh,crop,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"