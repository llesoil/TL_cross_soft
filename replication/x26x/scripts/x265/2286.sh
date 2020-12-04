#!/bin/sh

numb='2287'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 20 --keyint 240 --lookahead-threads 1 --min-keyint 22 --qp 30 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.5,1.2,1.4,0.2,0.4,0.7,0.2,2,1,0,20,240,1,22,30,4,4,65,18,4,2000,1:1,umh,show,faster,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"