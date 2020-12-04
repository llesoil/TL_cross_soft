#!/bin/sh

numb='2778'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 3.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 45 --keyint 200 --lookahead-threads 4 --min-keyint 22 --qp 20 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.0,1.2,1.0,3.6,0.3,0.8,0.1,0,0,8,45,200,4,22,20,3,2,65,28,5,2000,-2:-2,dia,crop,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"