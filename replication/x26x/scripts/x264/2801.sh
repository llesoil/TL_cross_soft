#!/bin/sh

numb='2802'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 40 --keyint 290 --lookahead-threads 2 --min-keyint 23 --qp 10 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.5,1.0,1.2,4.6,0.6,0.9,0.4,1,1,14,40,290,2,23,10,5,0,64,28,1,2000,-1:-1,umh,crop,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"