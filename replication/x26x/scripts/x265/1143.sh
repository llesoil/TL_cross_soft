#!/bin/sh

numb='1144'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 30 --keyint 210 --lookahead-threads 2 --min-keyint 30 --qp 20 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.0,1.0,1.3,4.6,0.6,0.8,0.1,1,0,6,30,210,2,30,20,4,2,67,18,2,1000,1:1,hex,show,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"