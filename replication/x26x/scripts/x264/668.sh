#!/bin/sh

numb='669'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 1.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 10 --keyint 220 --lookahead-threads 0 --min-keyint 20 --qp 30 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.0,1.6,1.0,1.4,0.5,0.6,0.7,0,1,16,10,220,0,20,30,5,3,66,38,2,2000,1:1,dia,show,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"