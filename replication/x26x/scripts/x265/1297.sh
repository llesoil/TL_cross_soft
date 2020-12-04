#!/bin/sh

numb='1298'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 4.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 15 --keyint 260 --lookahead-threads 1 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.4,1.4,4.6,0.6,0.6,0.3,0,0,14,15,260,1,27,10,5,4,68,18,2,2000,-1:-1,dia,crop,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"