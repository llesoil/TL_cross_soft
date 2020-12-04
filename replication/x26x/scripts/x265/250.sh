#!/bin/sh

numb='251'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 3.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 25 --keyint 280 --lookahead-threads 2 --min-keyint 27 --qp 40 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset ultrafast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.2,1.4,3.2,0.6,0.9,0.1,2,1,4,25,280,2,27,40,5,3,60,38,3,1000,-1:-1,hex,crop,ultrafast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"