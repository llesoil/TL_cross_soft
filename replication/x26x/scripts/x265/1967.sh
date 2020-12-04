#!/bin/sh

numb='1968'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 5 --keyint 230 --lookahead-threads 2 --min-keyint 28 --qp 40 --qpstep 3 --qpmin 0 --qpmax 69 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset veryfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,2.5,1.6,1.3,3.6,0.3,0.6,0.2,0,2,14,5,230,2,28,40,3,0,69,48,4,1000,1:1,umh,crop,veryfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"