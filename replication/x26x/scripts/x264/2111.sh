#!/bin/sh

numb='2112'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 45 --keyint 240 --lookahead-threads 0 --min-keyint 27 --qp 50 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.1,1.1,2.8,0.6,0.7,0.7,3,2,0,45,240,0,27,50,5,4,64,28,3,1000,-2:-2,dia,crop,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"