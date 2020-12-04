#!/bin/sh

numb='1442'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 4.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 0 --keyint 230 --lookahead-threads 3 --min-keyint 23 --qp 40 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset veryfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.5,1.3,1.3,4.2,0.6,0.6,0.3,3,2,0,0,230,3,23,40,4,2,62,18,6,2000,1:1,dia,show,veryfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"