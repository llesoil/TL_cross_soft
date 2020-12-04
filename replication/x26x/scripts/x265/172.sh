#!/bin/sh

numb='173'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 50 --keyint 300 --lookahead-threads 2 --min-keyint 24 --qp 50 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.5,1.4,1.2,4.6,0.3,0.9,0.5,2,2,14,50,300,2,24,50,4,2,67,18,4,1000,-1:-1,dia,crop,ultrafast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"