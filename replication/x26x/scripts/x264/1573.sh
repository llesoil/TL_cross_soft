#!/bin/sh

numb='1574'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 3.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 20 --keyint 240 --lookahead-threads 2 --min-keyint 24 --qp 50 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,3.0,1.1,1.0,3.2,0.5,0.6,0.3,3,2,2,20,240,2,24,50,3,0,65,28,3,2000,1:1,hex,crop,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"