#!/bin/sh

numb='2754'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 20 --keyint 210 --lookahead-threads 2 --min-keyint 23 --qp 50 --qpstep 3 --qpmin 4 --qpmax 64 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.5,1.4,1.1,4.0,0.3,0.9,0.1,3,2,8,20,210,2,23,50,3,4,64,38,3,2000,1:1,dia,crop,superfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"