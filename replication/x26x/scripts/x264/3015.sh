#!/bin/sh

numb='3016'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 35 --keyint 290 --lookahead-threads 0 --min-keyint 24 --qp 20 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.0,1.0,1.6,0.3,0.8,0.7,3,1,6,35,290,0,24,20,5,3,60,48,2,2000,1:1,umh,show,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"