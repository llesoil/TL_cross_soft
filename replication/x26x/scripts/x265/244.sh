#!/bin/sh

numb='245'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 20 --keyint 270 --lookahead-threads 3 --min-keyint 28 --qp 0 --qpstep 4 --qpmin 1 --qpmax 63 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.0,1.2,1.2,0.6,0.5,0.8,0.0,3,2,8,20,270,3,28,0,4,1,63,18,4,1000,1:1,hex,show,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"