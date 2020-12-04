#!/bin/sh

numb='2660'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 3.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 35 --keyint 280 --lookahead-threads 4 --min-keyint 21 --qp 50 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset ultrafast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.5,1.2,1.3,3.8,0.6,0.7,0.7,2,2,2,35,280,4,21,50,4,3,63,48,2,2000,-1:-1,dia,show,ultrafast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"