#!/bin/sh

numb='1777'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 4.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 15 --keyint 250 --lookahead-threads 0 --min-keyint 27 --qp 0 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.1,1.1,4.6,0.3,0.9,0.9,0,0,8,15,250,0,27,0,5,1,60,48,1,2000,-1:-1,dia,crop,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"