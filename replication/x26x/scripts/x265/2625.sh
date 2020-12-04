#!/bin/sh

numb='2626'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 30 --keyint 200 --lookahead-threads 2 --min-keyint 27 --qp 10 --qpstep 3 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset veryfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.0,1.6,1.0,4.2,0.4,0.6,0.6,0,2,16,30,200,2,27,10,3,3,63,18,5,1000,-1:-1,umh,crop,veryfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"