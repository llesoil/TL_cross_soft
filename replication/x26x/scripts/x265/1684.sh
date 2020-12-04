#!/bin/sh

numb='1685'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 1.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 35 --keyint 240 --lookahead-threads 2 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.0,1.6,1.3,1.2,0.3,0.9,0.8,3,0,14,35,240,2,26,50,4,0,62,48,3,1000,-2:-2,hex,show,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"