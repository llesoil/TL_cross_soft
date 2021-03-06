#!/bin/sh

numb='1242'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 3.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 35 --keyint 280 --lookahead-threads 0 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset veryfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.0,1.4,1.3,3.8,0.4,0.6,0.5,1,1,14,35,280,0,25,20,3,0,61,18,6,1000,-2:-2,umh,crop,veryfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"