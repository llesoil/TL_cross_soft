#!/bin/sh

numb='969'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 45 --keyint 240 --lookahead-threads 1 --min-keyint 21 --qp 20 --qpstep 5 --qpmin 0 --qpmax 61 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset veryfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.0,1.2,1.3,1.6,0.4,0.9,0.4,1,0,10,45,240,1,21,20,5,0,61,18,5,2000,1:1,hex,show,veryfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"