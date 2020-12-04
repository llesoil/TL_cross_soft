#!/bin/sh

numb='3087'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 1.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 35 --keyint 220 --lookahead-threads 1 --min-keyint 28 --qp 30 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.0,1.4,1.4,0.5,0.9,0.7,1,1,10,35,220,1,28,30,3,1,67,28,4,2000,1:1,umh,crop,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"