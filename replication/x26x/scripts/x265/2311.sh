#!/bin/sh

numb='2312'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 1.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 45 --keyint 240 --lookahead-threads 0 --min-keyint 29 --qp 20 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset veryslow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.1,1.2,1.2,0.3,0.8,0.7,1,2,14,45,240,0,29,20,3,1,60,18,4,2000,-2:-2,hex,crop,veryslow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"