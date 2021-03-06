#!/bin/sh

numb='2076'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 4.0 --qblur 0.5 --qcomp 0.9 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 45 --keyint 240 --lookahead-threads 0 --min-keyint 25 --qp 0 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.5,1.0,1.1,4.0,0.5,0.9,0.4,2,0,0,45,240,0,25,0,5,3,63,18,6,2000,1:1,umh,show,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"