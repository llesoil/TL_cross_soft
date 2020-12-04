#!/bin/sh

numb='409'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 45 --keyint 230 --lookahead-threads 4 --min-keyint 26 --qp 0 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.4,1.1,4.2,0.4,0.6,0.9,0,1,12,45,230,4,26,0,5,4,68,18,6,2000,-2:-2,hex,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"