#!/bin/sh

numb='1742'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 25 --keyint 240 --lookahead-threads 0 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.5,1.2,1.2,0.2,0.5,0.8,0.9,3,1,6,25,240,0,28,20,5,2,67,48,2,1000,1:1,dia,show,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"