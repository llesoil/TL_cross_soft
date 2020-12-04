#!/bin/sh

numb='787'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 4.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 0 --keyint 240 --lookahead-threads 4 --min-keyint 20 --qp 30 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,3.0,1.1,1.3,4.4,0.3,0.8,0.2,2,0,6,0,240,4,20,30,5,0,63,38,6,2000,-2:-2,umh,show,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"