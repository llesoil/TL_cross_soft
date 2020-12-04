#!/bin/sh

numb='1066'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 0.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 35 --keyint 210 --lookahead-threads 0 --min-keyint 27 --qp 0 --qpstep 4 --qpmin 1 --qpmax 66 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.2,1.3,0.8,0.6,0.7,0.8,0,2,8,35,210,0,27,0,4,1,66,48,1,2000,-2:-2,umh,show,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"