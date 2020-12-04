#!/bin/sh

numb='1339'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 3.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 0 --keyint 270 --lookahead-threads 1 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.4,1.1,3.0,0.2,0.8,0.7,2,0,2,0,270,1,29,10,3,4,65,18,2,2000,-2:-2,hex,show,veryfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"