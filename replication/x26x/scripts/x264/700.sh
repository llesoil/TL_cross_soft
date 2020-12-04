#!/bin/sh

numb='701'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 0.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 45 --keyint 240 --lookahead-threads 1 --min-keyint 25 --qp 10 --qpstep 4 --qpmin 4 --qpmax 63 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.4,1.3,0.6,0.5,0.9,0.8,3,1,2,45,240,1,25,10,4,4,63,18,6,1000,-2:-2,hex,crop,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"