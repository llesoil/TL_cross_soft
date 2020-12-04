#!/bin/sh

numb='671'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 4.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 30 --keyint 250 --lookahead-threads 1 --min-keyint 29 --qp 0 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.1,1.0,4.6,0.5,0.6,0.9,3,1,16,30,250,1,29,0,3,0,66,48,3,1000,-2:-2,umh,crop,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"