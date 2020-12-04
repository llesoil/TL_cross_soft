#!/bin/sh

numb='28'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 3.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 50 --keyint 220 --lookahead-threads 0 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.5,1.3,1.4,3.6,0.6,0.6,0.9,1,0,8,50,220,0,25,0,3,0,68,28,5,2000,-2:-2,umh,show,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"