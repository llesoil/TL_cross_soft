#!/bin/sh

numb='1791'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 3.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 45 --keyint 280 --lookahead-threads 0 --min-keyint 24 --qp 30 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.5,1.6,1.0,3.4,0.5,0.9,0.5,3,0,6,45,280,0,24,30,5,2,65,38,4,2000,-2:-2,dia,crop,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"