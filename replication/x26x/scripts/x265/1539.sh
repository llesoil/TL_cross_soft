#!/bin/sh

numb='1540'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 0.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 15 --keyint 280 --lookahead-threads 2 --min-keyint 21 --qp 10 --qpstep 4 --qpmin 4 --qpmax 60 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,3.0,1.4,1.4,0.8,0.3,0.8,0.9,3,1,0,15,280,2,21,10,4,4,60,28,4,2000,-1:-1,umh,show,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"