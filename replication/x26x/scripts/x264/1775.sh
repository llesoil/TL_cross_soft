#!/bin/sh

numb='1776'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 3.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 45 --keyint 240 --lookahead-threads 0 --min-keyint 29 --qp 0 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,3.0,1.5,1.2,3.2,0.5,0.6,0.1,3,2,14,45,240,0,29,0,4,0,64,38,3,1000,1:1,dia,crop,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"