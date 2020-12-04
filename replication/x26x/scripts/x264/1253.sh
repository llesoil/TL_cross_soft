#!/bin/sh

numb='1254'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 3.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 25 --keyint 220 --lookahead-threads 3 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.2,1.0,3.0,0.6,0.7,0.3,3,1,16,25,220,3,26,20,4,2,63,18,4,2000,-1:-1,dia,crop,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"