#!/bin/sh

numb='2239'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 1.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 5 --keyint 220 --lookahead-threads 2 --min-keyint 24 --qp 20 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.2,1.4,1.4,0.2,0.9,0.3,2,2,10,5,220,2,24,20,3,1,60,18,2,1000,1:1,hex,show,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"