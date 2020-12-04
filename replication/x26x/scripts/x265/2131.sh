#!/bin/sh

numb='2132'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 0 --keyint 270 --lookahead-threads 0 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 3 --qpmax 64 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset veryslow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.1,1.2,3.8,0.6,0.7,0.1,3,0,10,0,270,0,29,40,4,3,64,28,4,2000,-2:-2,dia,crop,veryslow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"