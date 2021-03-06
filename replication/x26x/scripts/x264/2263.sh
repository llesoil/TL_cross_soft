#!/bin/sh

numb='2264'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 40 --keyint 300 --lookahead-threads 1 --min-keyint 27 --qp 0 --qpstep 3 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,3.0,1.3,1.1,4.0,0.4,0.8,0.5,1,2,2,40,300,1,27,0,3,3,63,18,4,2000,1:1,hex,crop,fast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"