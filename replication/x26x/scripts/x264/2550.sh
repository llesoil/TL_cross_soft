#!/bin/sh

numb='2551'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 3.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 45 --keyint 220 --lookahead-threads 2 --min-keyint 29 --qp 30 --qpstep 4 --qpmin 1 --qpmax 63 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset fast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.2,1.0,3.2,0.4,0.7,0.6,2,0,0,45,220,2,29,30,4,1,63,18,3,2000,-1:-1,hex,show,fast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"