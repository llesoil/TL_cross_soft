#!/bin/sh

numb='586'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 4.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 15 --keyint 280 --lookahead-threads 3 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.3,1.4,4.2,0.4,0.6,0.5,2,2,0,15,280,3,30,40,5,2,68,38,4,1000,-1:-1,hex,show,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"