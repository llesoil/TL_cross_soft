#!/bin/sh

numb='490'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 5 --keyint 260 --lookahead-threads 0 --min-keyint 28 --qp 10 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset placebo --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.5,1.0,4.8,0.2,0.9,0.7,1,0,0,5,260,0,28,10,3,4,62,28,6,1000,1:1,dia,crop,placebo,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"