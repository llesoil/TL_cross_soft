#!/bin/sh

numb='2981'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 35 --keyint 210 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.5,1.3,1.0,4.6,0.6,0.8,0.5,2,1,2,35,210,2,30,40,3,4,65,48,4,2000,1:1,umh,show,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"