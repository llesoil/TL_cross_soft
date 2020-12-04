#!/bin/sh

numb='3061'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 5 --keyint 280 --lookahead-threads 3 --min-keyint 22 --qp 30 --qpstep 3 --qpmin 2 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset ultrafast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.6,1.0,4.2,0.5,0.7,0.0,2,1,12,5,280,3,22,30,3,2,69,38,6,2000,1:1,umh,crop,ultrafast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"