#!/bin/sh

numb='2504'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 0.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 10 --keyint 270 --lookahead-threads 0 --min-keyint 20 --qp 50 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset ultrafast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.0,1.4,1.1,0.8,0.3,0.6,0.6,0,2,2,10,270,0,20,50,4,0,69,38,5,2000,-1:-1,hex,crop,ultrafast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"