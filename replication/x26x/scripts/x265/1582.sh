#!/bin/sh

numb='1583'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 0.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 25 --keyint 300 --lookahead-threads 2 --min-keyint 25 --qp 20 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.4,1.4,0.4,0.6,0.9,0.7,2,2,4,25,300,2,25,20,5,4,60,38,3,1000,1:1,umh,show,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"