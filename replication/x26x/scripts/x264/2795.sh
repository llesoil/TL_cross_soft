#!/bin/sh

numb='2796'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 35 --keyint 250 --lookahead-threads 4 --min-keyint 22 --qp 20 --qpstep 5 --qpmin 1 --qpmax 64 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.0,1.4,4.2,0.4,0.6,0.6,3,2,0,35,250,4,22,20,5,1,64,48,1,1000,-2:-2,hex,crop,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"