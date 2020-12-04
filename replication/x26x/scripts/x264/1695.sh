#!/bin/sh

numb='1696'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 4 --crf 45 --keyint 220 --lookahead-threads 2 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.5,1.0,1.2,0.8,0.5,0.8,0.8,1,2,4,45,220,2,30,50,3,1,63,28,5,1000,-2:-2,dia,crop,medium,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"