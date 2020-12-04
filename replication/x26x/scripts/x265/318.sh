#!/bin/sh

numb='319'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 30 --keyint 250 --lookahead-threads 1 --min-keyint 24 --qp 10 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset ultrafast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.2,1.2,1.4,0.3,0.7,0.3,1,2,14,30,250,1,24,10,4,0,68,18,4,2000,-2:-2,hex,crop,ultrafast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"