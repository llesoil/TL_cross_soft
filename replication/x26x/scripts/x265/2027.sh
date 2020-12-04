#!/bin/sh

numb='2028'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 3.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 20 --keyint 230 --lookahead-threads 4 --min-keyint 30 --qp 20 --qpstep 3 --qpmin 2 --qpmax 69 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.2,1.0,3.6,0.2,0.8,0.0,0,2,4,20,230,4,30,20,3,2,69,18,1,1000,-2:-2,umh,show,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"