#!/bin/sh

numb='2103'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 3.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 35 --keyint 240 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 4 --qpmax 63 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.0,1.4,1.3,3.6,0.6,0.8,0.6,0,0,16,35,240,2,30,40,3,4,63,48,6,2000,-2:-2,hex,crop,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"