#!/bin/sh

numb='1423'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 1.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.7 --aq-mode 3 --b-adapt 0 --bframes 4 --crf 45 --keyint 220 --lookahead-threads 0 --min-keyint 30 --qp 20 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.6,1.4,1.6,0.3,0.8,0.7,3,0,4,45,220,0,30,20,4,0,60,38,1,2000,-1:-1,hex,crop,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"