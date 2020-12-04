#!/bin/sh

numb='2722'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 0.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 15 --keyint 270 --lookahead-threads 0 --min-keyint 27 --qp 20 --qpstep 5 --qpmin 3 --qpmax 62 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.4,1.1,0.6,0.4,0.7,0.4,0,2,12,15,270,0,27,20,5,3,62,38,4,1000,-2:-2,hex,crop,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"