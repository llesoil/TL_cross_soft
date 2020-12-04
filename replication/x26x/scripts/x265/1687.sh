#!/bin/sh

numb='1688'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 5.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 15 --keyint 220 --lookahead-threads 3 --min-keyint 23 --qp 20 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.0,1.2,5.0,0.4,0.8,0.0,2,2,0,15,220,3,23,20,5,4,60,28,5,1000,-2:-2,dia,crop,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"