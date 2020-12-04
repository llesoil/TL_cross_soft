#!/bin/sh

numb='2774'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 10 --keyint 290 --lookahead-threads 3 --min-keyint 27 --qp 0 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.0,1.2,1.4,0.2,0.6,0.6,0.7,3,2,12,10,290,3,27,0,3,0,68,18,3,2000,1:1,hex,crop,fast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"