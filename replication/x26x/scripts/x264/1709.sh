#!/bin/sh

numb='1710'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 2.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 5 --keyint 220 --lookahead-threads 1 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.3,1.4,2.6,0.3,0.8,0.4,1,0,10,5,220,1,28,40,5,0,65,18,3,1000,-1:-1,hex,show,fast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"