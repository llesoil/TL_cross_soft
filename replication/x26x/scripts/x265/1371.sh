#!/bin/sh

numb='1372'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 10 --keyint 260 --lookahead-threads 4 --min-keyint 30 --qp 0 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.5,1.4,1.0,2.2,0.2,0.6,0.6,0,1,4,10,260,4,30,0,4,4,62,38,6,2000,-2:-2,hex,crop,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"