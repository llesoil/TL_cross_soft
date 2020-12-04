#!/bin/sh

numb='1882'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 0.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 40 --keyint 210 --lookahead-threads 0 --min-keyint 23 --qp 10 --qpstep 3 --qpmin 3 --qpmax 64 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.5,1.5,1.1,0.6,0.5,0.7,0.9,2,1,2,40,210,0,23,10,3,3,64,38,5,1000,-2:-2,dia,crop,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"