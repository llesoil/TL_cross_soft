#!/bin/sh

numb='2337'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 1.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 20 --keyint 290 --lookahead-threads 1 --min-keyint 28 --qp 0 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset veryslow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.1,1.2,1.8,0.3,0.7,0.9,3,2,16,20,290,1,28,0,3,2,66,38,1,2000,-2:-2,hex,crop,veryslow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"