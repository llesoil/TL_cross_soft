#!/bin/sh

numb='3085'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 1.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 35 --keyint 220 --lookahead-threads 4 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.4,1.3,1.8,0.5,0.8,0.5,0,0,6,35,220,4,26,50,4,0,60,18,3,2000,-2:-2,hex,show,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"