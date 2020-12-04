#!/bin/sh

numb='1883'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 40 --keyint 240 --lookahead-threads 1 --min-keyint 23 --qp 0 --qpstep 3 --qpmin 0 --qpmax 69 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.0,1.0,3.8,0.2,0.9,0.6,1,2,16,40,240,1,23,0,3,0,69,28,2,2000,-1:-1,hex,show,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"